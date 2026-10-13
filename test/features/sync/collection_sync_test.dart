import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/features/scanner/data/barcode_repository.dart';
import 'package:movie_shelf/features/server/data/server_client.dart';
import 'package:movie_shelf/features/sync/data/collection_sync_repository.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

class FakeServer implements ServerClient {
  final rows = <int, Map<String, dynamic>>{};
  bool offline = false;
  bool racing = false;

  @override
  Future<dynamic> get(String path, {Map<String, dynamic>? query}) async {
    if (offline) throw const ServerUnreachableException();
    return [
      for (final entry in rows.entries) {'tmdbId': entry.key, ...entry.value},
    ];
  }

  @override
  Future<dynamic> put(String path, {Object? body}) async {
    if (offline) throw const ServerUnreachableException();
    if (racing) throw const ServerRejectedException('Konflikt', 409);
    final id = int.parse(path.split('/').last);
    final request = body! as Map<String, dynamic>;
    final current = rows[id]?['revision'] as int? ?? 0;
    if (request['baseRevision'] != current && request['force'] != true) {
      throw const ServerRejectedException('Konflikt', 409);
    }
    return rows[id] = {'revision': current + 1, 'payload': request['payload']};
  }

  @override
  Future<dynamic> delete(String path) async {
    rows.remove(int.parse(path.split('/').last));
  }

  void set(int tmdbId, String status, {List<Map<String, dynamic>>? barcodes}) {
    final current = rows[tmdbId]?['revision'] as int? ?? 0;
    rows[tmdbId] = {
      'revision': current + 1,
      'payload': {'status': status, 'barcodes': barcodes ?? []},
    };
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late AppDatabase db;
  late FakeServer server;
  late CollectionSyncRepository sync;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    server = FakeServer();
    sync = CollectionSyncRepository(
      db,
      BarcodeRepository(db),
      server,
      'home/owner',
    );
  });

  tearDown(() => db.close());

  Future<int> movie(
    int? tmdbId, {
    CollectionStatus status = CollectionStatus.owned,
  }) => db
      .into(db.movies)
      .insert(
        MoviesCompanion.insert(
          title: 'Film $tmdbId',
          tmdbId: Value(tmdbId),
          userStatus: Value(status),
        ),
      );

  Future<CollectionStatus> statusOf(int id) async => (await (db.select(
    db.movies,
  )..where((t) => t.id.equals(id))).getSingle()).userStatus;

  Future<List<String>> barcodesOf(int id) async => [
    for (final row in await (db.select(
      db.barcodes,
    )..where((t) => t.movieId.equals(id))).get())
      row.barcode,
  ];

  Future<void> addBarcode(int movieId, String barcode) =>
      BarcodeRepository(db).saveMapping(
        barcode: barcode,
        barcodeType: 'EAN-13',
        movieId: movieId,
        editionName: 'Steelbook',
        physicalFormat: 'Blu-ray',
      );

  test('a new local movie is pushed to the server by tmdb id', () async {
    await movie(157336);

    final report = await sync.sync();

    expect(report.pushed, 1);
    expect(report.pending, 0);
    expect(server.rows[157336]!['payload']['status'], 'owned');
  });

  test('movies without a tmdb id stay local only', () async {
    await movie(null);

    final report = await sync.sync();

    expect(report.pushed, 0);
    expect(server.rows, isEmpty);
  });

  test('a server copy that matches the local one links silently', () async {
    final id = await movie(1, status: CollectionStatus.wishlist);
    server.set(1, 'wishlist');

    final report = await sync.sync();

    expect(report.pending, 0);
    expect(report.pushed, 0);
    expect(await statusOf(id), CollectionStatus.wishlist);
    expect(server.rows[1]!['revision'], 1);
  });

  test(
    'a divergent server copy surfaces a conflict and changes nothing',
    () async {
      final id = await movie(1, status: CollectionStatus.owned);
      server.set(1, 'wishlist');

      final report = await sync.sync();

      expect(report.conflicts.single.tmdbId, 1);
      expect(report.conflicts.single.local.status, CollectionStatus.owned);
      expect(report.conflicts.single.server.status, CollectionStatus.wishlist);
      expect(await statusOf(id), CollectionStatus.owned);
      expect(server.rows[1]!['payload']['status'], 'wishlist');
      expect(server.rows[1]!['revision'], 1);
    },
  );

  test('keeping the server copy applies status and barcodes', () async {
    final id = await movie(1);
    await addBarcode(id, 'old-code');
    server.set(
      1,
      'wishlist',
      barcodes: [
        {'barcode': 'new-code', 'type': 'EAN-13', 'editionName': 'Collector'},
      ],
    );
    await sync.sync();

    await sync.keepServer(1);
    final report = await sync.sync();

    expect(await statusOf(id), CollectionStatus.wishlist);
    expect(await barcodesOf(id), ['new-code']);
    expect(report.pending, 0);
  });

  test('keeping the local copy overwrites the server revision', () async {
    final id = await movie(1);
    await addBarcode(id, 'code');
    server.set(1, 'wishlist');
    await sync.sync();

    await sync.keepLocal(1);
    final report = await sync.sync();

    expect(server.rows[1]!['payload']['status'], 'owned');
    expect(server.rows[1]!['revision'], 2);
    expect(await statusOf(id), CollectionStatus.owned);
    expect(report.pending, 0);
  });

  test('a later local edit is pushed without conflict', () async {
    final id = await movie(1);
    await sync.sync();
    await (db.update(db.movies)..where((t) => t.id.equals(id))).write(
      const MoviesCompanion(userStatus: Value(CollectionStatus.open)),
    );

    final report = await sync.sync();

    expect(report.pushed, 1);
    expect(server.rows[1]!['payload']['status'], 'open');
  });

  test(
    'a server edit over an untouched local copy waits for approval',
    () async {
      final id = await movie(1);
      await sync.sync();
      server.set(1, 'wishlist');

      final report = await sync.sync();

      expect(report.incoming.single.server.status, CollectionStatus.wishlist);
      expect(await statusOf(id), CollectionStatus.owned);

      await sync.keepServer(1);
      expect(await statusOf(id), CollectionStatus.wishlist);
    },
  );

  test('edits on both sides become a conflict', () async {
    final id = await movie(1);
    await sync.sync();
    await (db.update(db.movies)..where((t) => t.id.equals(id))).write(
      const MoviesCompanion(userStatus: Value(CollectionStatus.open)),
    );
    server.set(1, 'wishlist');

    final report = await sync.sync();

    expect(report.conflicts.single.tmdbId, 1);
    expect(await statusOf(id), CollectionStatus.open);
  });

  test('an unreachable server leaves local data untouched', () async {
    final id = await movie(1);
    server.offline = true;

    await expectLater(sync.sync(), throwsA(isA<ServerUnreachableException>()));

    expect(await statusOf(id), CollectionStatus.owned);
    server.offline = false;
    expect((await sync.sync()).pushed, 1);
  });

  test(
    'a push that races another device is retried on the next sync',
    () async {
      await movie(1);
      server.racing = true;

      final report = await sync.sync();
      server.racing = false;

      expect(report.pushed, 0);
      expect((await sync.sync()).pushed, 1);
    },
  );

  test('deleting a movie locally removes its server copy', () async {
    final id = await movie(1);
    await sync.sync();
    await (db.delete(db.movies)..where((t) => t.id.equals(id))).go();

    final report = await sync.sync();

    expect(report.removed, 1);
    expect(server.rows, isEmpty);
  });

  test('a barcode owned by another movie is not moved by the server', () async {
    final first = await movie(1);
    final second = await movie(2);
    await addBarcode(second, 'shared');
    server.set(
      1,
      'owned',
      barcodes: [
        {'barcode': 'shared', 'type': 'EAN-13'},
      ],
    );
    await sync.sync();

    await sync.keepServer(1);

    expect(await barcodesOf(first), isEmpty);
    expect(await barcodesOf(second), ['shared']);
  });
}
