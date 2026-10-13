import 'dart:convert';

import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/errors/app_exception.dart';
import '../../scanner/data/barcode_repository.dart';
import '../../server/data/server_client.dart';
import '../domain/collection_snapshot.dart';

class SyncDifference {
  const SyncDifference({
    required this.tmdbId,
    required this.title,
    required this.local,
    required this.server,
  });

  final int tmdbId;
  final String title;
  final CollectionSnapshot local;
  final CollectionSnapshot server;
}

class SyncReport {
  const SyncReport({
    this.pushed = 0,
    this.removed = 0,
    this.conflicts = const [],
    this.incoming = const [],
  });

  final int pushed;
  final int removed;
  final List<SyncDifference> conflicts;
  final List<SyncDifference> incoming;

  int get pending => conflicts.length + incoming.length;
}

class CollectionSyncRepository {
  CollectionSyncRepository(this._db, this._barcodes, this._client, this._scope);

  static const _path = '/api/collection/projection';

  final AppDatabase _db;
  final BarcodeRepository _barcodes;
  final ServerClient _client;
  final String _scope;

  Future<List<ServerProjection>> _remote() async => [
    for (final json in await _client.get(_path) as List)
      ServerProjection.fromJson(json as Map<String, dynamic>),
  ];

  Future<CollectionSnapshot> _snapshot(MovieRow movie) async {
    final rows = await (_db.select(
      _db.barcodes,
    )..where((t) => t.movieId.equals(movie.id))).get();
    return CollectionSnapshot(
      status: movie.userStatus,
      barcodes: [
        for (final row in rows)
          SnapshotBarcode(
            barcode: row.barcode,
            type: row.barcodeType,
            productTitle: row.productTitle,
            editionName: row.editionName,
            format: row.physicalFormat,
            region: row.region,
          ),
      ],
    );
  }

  Future<MovieRow?> _movie(int tmdbId) => (_db.select(
    _db.movies,
  )..where((t) => t.tmdbId.equals(tmdbId))).getSingleOrNull();

  Future<void> _remember(
    int tmdbId,
    int revision,
    CollectionSnapshot snapshot,
  ) => _db
      .into(_db.syncStates)
      .insertOnConflictUpdate(
        SyncStatesCompanion.insert(
          scope: _scope,
          tmdbId: tmdbId,
          revision: revision,
          syncedJson: snapshot.encode(),
          conflictJson: const Value(null),
        ),
      );

  Future<void> _holdConflict(ServerProjection server) => _db
      .into(_db.syncStates)
      .insert(
        SyncStatesCompanion.insert(
          scope: _scope,
          tmdbId: server.tmdbId,
          revision: 0,
          syncedJson: '',
          conflictJson: Value(jsonEncode(server.toJson())),
        ),
        onConflict: DoUpdate(
          (_) => SyncStatesCompanion(
            conflictJson: Value(jsonEncode(server.toJson())),
          ),
        ),
      );

  Future<bool> _push(
    int tmdbId,
    CollectionSnapshot local,
    int baseRevision, {
    bool force = false,
  }) async {
    try {
      final json =
          await _client.put(
                '$_path/$tmdbId',
                body: {
                  'baseRevision': baseRevision,
                  'payload': local.toJson(),
                  'force': force,
                },
              )
              as Map<String, dynamic>;
      await _remember(tmdbId, json['revision'] as int, local);
      return true;
    } on ServerRejectedException catch (e) {
      if (e.statusCode == 409) return false;
      rethrow;
    }
  }

  Future<SyncReport> sync() async {
    final remote = {for (final r in await _remote()) r.tmdbId: r};
    final states = {
      for (final s in await (_db.select(
        _db.syncStates,
      )..where((t) => t.scope.equals(_scope))).get())
        s.tmdbId: s,
    };
    final movies = await (_db.select(
      _db.movies,
    )..where((t) => t.tmdbId.isNotNull())).get();
    final conflicts = <SyncDifference>[];
    final incoming = <SyncDifference>[];
    var pushed = 0;
    var removed = 0;

    for (final movie in movies) {
      final tmdbId = movie.tmdbId!;
      final local = await _snapshot(movie);
      final server = remote[tmdbId];
      final state = states[tmdbId];

      if (server != null && server.snapshot.encode() == local.encode()) {
        await _remember(tmdbId, server.revision, local);
        continue;
      }

      final localChanged = state == null || state.syncedJson != local.encode();
      final serverChanged =
          server != null &&
          (state == null || state.revision != server.revision);

      if (localChanged && !serverChanged) {
        if (await _push(tmdbId, local, server?.revision ?? 0)) pushed++;
      } else if (localChanged && serverChanged) {
        await _holdConflict(server);
        conflicts.add(
          SyncDifference(
            tmdbId: tmdbId,
            title: movie.title,
            local: local,
            server: server.snapshot,
          ),
        );
      } else if (serverChanged) {
        incoming.add(
          SyncDifference(
            tmdbId: tmdbId,
            title: movie.title,
            local: local,
            server: server.snapshot,
          ),
        );
      }
    }

    final present = {for (final m in movies) m.tmdbId};
    for (final state in states.values.where(
      (s) => !present.contains(s.tmdbId),
    )) {
      if (remote[state.tmdbId]?.revision == state.revision) {
        await _client.delete('$_path/${state.tmdbId}');
        removed++;
      }
      await (_db.delete(_db.syncStates)..where(
            (t) => t.scope.equals(_scope) & t.tmdbId.equals(state.tmdbId),
          ))
          .go();
    }

    return SyncReport(
      pushed: pushed,
      removed: removed,
      conflicts: conflicts,
      incoming: incoming,
    );
  }

  Future<void> keepLocal(int tmdbId) async {
    final movie = await _movie(tmdbId);
    if (movie == null) return;
    final server = (await _remote()).where((r) => r.tmdbId == tmdbId);
    await _push(
      tmdbId,
      await _snapshot(movie),
      server.firstOrNull?.revision ?? 0,
      force: true,
    );
  }

  Future<void> keepServer(int tmdbId) async {
    final movie = await _movie(tmdbId);
    final server = (await _remote()).where((r) => r.tmdbId == tmdbId);
    if (movie == null || server.isEmpty) return;
    await _apply(movie, server.first.snapshot);
    await _remember(tmdbId, server.first.revision, await _snapshot(movie));
  }

  Future<void> _apply(MovieRow movie, CollectionSnapshot snapshot) async {
    final current = {
      for (final b in (await _snapshot(movie)).barcodes) b.barcode: b.key,
    };
    await (_db.update(_db.movies)..where((t) => t.id.equals(movie.id))).write(
      MoviesCompanion(
        userStatus: Value(snapshot.status),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await (_db.delete(_db.barcodes)..where(
          (t) =>
              t.movieId.equals(movie.id) &
              t.barcode.isNotIn([for (final b in snapshot.barcodes) b.barcode]),
        ))
        .go();
    for (final b in snapshot.barcodes.where(
      (b) => current[b.barcode] != b.key,
    )) {
      try {
        await _barcodes.saveMapping(
          barcode: b.barcode,
          barcodeType: b.type,
          movieId: movie.id,
          productTitle: b.productTitle,
          editionName: b.editionName,
          physicalFormat: b.format,
          region: b.region,
          source: 'sync',
        );
      } on DuplicateBarcodeException {
        continue;
      }
    }
  }
}
