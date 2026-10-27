import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/collection/ownership_service.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/sync/collection_records.dart';
import 'package:movie_shelf/core/sync/sync_engine.dart';
import 'package:movie_shelf/core/sync/sync_provider.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

/// In-memory server with the merge rules of MovieShelf.Core.Sync.SyncMerger.
class FakeServer implements CollectionSyncProvider {
  final records = <String, _Stored>{};
  final ops = <String, SyncPushResult>{};
  var seq = 0;
  var pushes = 0;

  @override
  String get scope => 'fake';

  @override
  Future<List<SyncPushResult>> push(List<SyncChange> changes) async {
    pushes++;
    return [for (final c in changes) ops[c.opId] ??= _apply(c)];
  }

  SyncPushResult _apply(SyncChange c) {
    final current = records[c.entityId];
    final stored = current ?? _Stored(c.entityType);
    if (c.deleted) {
      if (stored.versions.values.any((v) => v > c.baseSeq)) {
        return _result(c, SyncOutcome.conflict, stored, [
          const FieldConflict(FieldConflict.deletedField, false, true),
        ]);
      }
      stored.deleted = true;
      stored.seq = ++seq;
      records[c.entityId] = stored;
      return _result(c, SyncOutcome.applied, stored, const []);
    }
    final conflicts = <FieldConflict>[];
    var applied = 0;
    final next = seq + 1;
    for (final e in c.fields.entries) {
      final exists = stored.data.containsKey(e.key);
      if (exists && sameJson(stored.data[e.key], e.value)) continue;
      if (exists && (stored.versions[e.key] ?? 0) > c.baseSeq) {
        conflicts.add(FieldConflict(e.key, stored.data[e.key], e.value));
        continue;
      }
      stored.data[e.key] = e.value;
      stored.versions[e.key] = next;
      applied++;
    }
    if (applied > 0) {
      stored.seq = ++seq;
      records[c.entityId] = stored;
    }
    final outcome = applied == 0 && conflicts.isEmpty
        ? SyncOutcome.unchanged
        : conflicts.isEmpty
        ? SyncOutcome.applied
        : applied == 0
        ? SyncOutcome.conflict
        : SyncOutcome.partial;
    return _result(c, outcome, stored, conflicts);
  }

  SyncPushResult _result(
    SyncChange c,
    SyncOutcome outcome,
    _Stored stored,
    List<FieldConflict> conflicts,
  ) => SyncPushResult(
    opId: c.opId,
    outcome: outcome,
    seq: stored.seq,
    conflicts: conflicts,
    record: outcome == SyncOutcome.applied
        ? null
        : RemoteRecord(
            type: c.entityType,
            uuid: c.entityId,
            seq: stored.seq,
            deleted: stored.deleted,
            data: Map.of(stored.data),
          ),
  );

  @override
  Future<SyncPullPage> pull(int cursor, {int limit = 200}) async {
    final changed = records.entries.where((e) => e.value.seq > cursor).toList()
      ..sort((a, b) => a.value.seq.compareTo(b.value.seq));
    final page = changed.take(limit).toList();
    return SyncPullPage(
      changes: [
        for (final e in page)
          RemoteRecord(
            type: e.value.type,
            uuid: e.key,
            seq: e.value.seq,
            deleted: e.value.deleted,
            data: e.value.deleted ? const {} : Map.of(e.value.data),
          ),
      ],
      nextCursor: page.isEmpty ? cursor : page.last.value.seq,
      hasMore: changed.length > limit,
      reset: false,
    );
  }

  @override
  Future<SyncSnapshotInfo> snapshot() async {
    final counts = <String, int>{};
    for (final r in records.values.where((r) => !r.deleted)) {
      counts[r.type] = (counts[r.type] ?? 0) + 1;
    }
    return SyncSnapshotInfo(lastSeq: seq, counts: counts);
  }
}

class _Stored {
  _Stored(this.type);

  final String type;
  final data = <String, Object?>{};
  final versions = <String, int>{};
  var seq = 0;
  var deleted = false;
}

class Device {
  Device(FakeServer server)
    : db = AppDatabase(NativeDatabase.memory()),
      _server = server {
    engine = SyncEngine(db, _server);
  }

  final AppDatabase db;
  final FakeServer _server;
  late final SyncEngine engine;

  Future<int> own(int tmdbId) async {
    final id = await db
        .into(db.movies)
        .insert(
          MoviesCompanion.insert(title: 'Film $tmdbId', tmdbId: Value(tmdbId)),
        );
    await OwnershipService(db).setMovieStatus(id, CollectionStatus.owned);
    return id;
  }

  Future<MovieRow?> movie(int tmdbId) => (db.select(
    db.movies,
  )..where((t) => t.tmdbId.equals(tmdbId))).getSingleOrNull();

  Future<OwnedCopyRow> onlyCopy() => db.select(db.ownedCopies).getSingle();

  Future<void> setCopy(OwnedCopiesCompanion values) async {
    final copy = await onlyCopy();
    await (db.update(
      db.ownedCopies,
    )..where((t) => t.id.equals(copy.id))).write(values);
  }
}

void main() {
  late FakeServer server;
  late Device phone;
  late Device tablet;

  setUp(() {
    server = FakeServer();
    phone = Device(server);
    tablet = Device(server);
  });

  tearDown(() async {
    await phone.db.close();
    await tablet.db.close();
  });

  test(
    'an owned film with its edition and copy reaches the other device',
    () async {
      await phone.own(603);
      final report = await phone.engine.run();
      expect(report.pushed, greaterThanOrEqualTo(4));

      await tablet.engine.run();
      expect((await tablet.movie(603))!.userStatus, CollectionStatus.owned);
      expect(
        await tablet.db.select(tablet.db.physicalEditions).get(),
        hasLength(1),
      );
      expect(await tablet.db.select(tablet.db.ownedCopies).get(), hasLength(1));
    },
  );

  test('a second run without changes sends nothing', () async {
    await phone.own(603);
    await phone.engine.run();
    expect((await phone.engine.pendingChanges()), isEmpty);
    final before = server.pushes;
    await phone.engine.run();
    expect(server.pushes, before);
  });

  test('edits of different fields on two devices merge', () async {
    await phone.own(603);
    await phone.engine.run();
    await tablet.engine.run();

    await phone.setCopy(const OwnedCopiesCompanion(condition: Value('gut')));
    await tablet.setCopy(
      const OwnedCopiesCompanion(storageLocation: Value('Regal B')),
    );
    await phone.engine.run();
    final report = await tablet.engine.run();
    await phone.engine.run();

    expect(report.conflicts, 0);
    for (final device in [phone, tablet]) {
      final copy = await device.onlyCopy();
      expect(copy.condition, 'gut');
      expect(copy.storageLocation, 'Regal B');
    }
  });

  test(
    'the same field changed on two devices is kept until resolved',
    () async {
      await phone.own(603);
      await phone.engine.run();
      await tablet.engine.run();

      await phone.setCopy(const OwnedCopiesCompanion(condition: Value('gut')));
      await tablet.setCopy(const OwnedCopiesCompanion(condition: Value('neu')));
      await phone.engine.run();
      final report = await tablet.engine.run();

      expect(report.conflicts, 1);
      expect((await tablet.onlyCopy()).condition, 'neu');
      // The conflicting value is not sent again while the user decides.
      expect(await tablet.engine.pendingChanges(), isEmpty);

      final conflict = await tablet.db
          .select(tablet.db.syncConflicts)
          .getSingle();
      await tablet.engine.resolve(conflict, keepLocal: true);
      await tablet.engine.run();
      await phone.engine.run();
      expect((await phone.onlyCopy()).condition, 'neu');
    },
  );

  test('removing a copy on one device removes it on the other', () async {
    await phone.own(603);
    await phone.engine.run();
    await tablet.engine.run();

    final movie = await phone.movie(603);
    await OwnershipService(
      phone.db,
    ).setMovieStatus(movie!.id, CollectionStatus.open);
    await phone.engine.run();
    await tablet.engine.run();

    expect(await tablet.db.select(tablet.db.ownedCopies).get(), isEmpty);
    expect((await tablet.movie(603))!.userStatus, CollectionStatus.open);
  });

  test('a lost push response is answered the same way on retry', () async {
    await phone.own(603);
    final changes = await phone.engine.pendingChanges();
    await server.push(changes);
    final seq = server.seq;
    // The phone never saw the answer and sends the same changes again.
    await phone.engine.run();
    expect(server.seq, seq);
    expect(await phone.engine.pendingChanges(), isEmpty);
  });

  test('two devices adding the same film offline end with one title', () async {
    await phone.own(603);
    await tablet.own(603);
    await phone.engine.run();
    await tablet.engine.run();
    await phone.engine.run();

    for (final device in [phone, tablet]) {
      final records = await CollectionRecords(device.db).buildAll();
      expect(
        records.values.where((r) => r.type == SyncEntityType.title),
        hasLength(1),
      );
    }
  });
}
