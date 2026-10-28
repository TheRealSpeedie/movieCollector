import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/sync/sync_engine.dart';
import 'package:movie_shelf/core/sync/sync_provider.dart';
import 'package:movie_shelf/features/household/data/household_api.dart';

import 'sync_engine_test.dart' show Device, FakeServer;

/// One address whose collection changes, as when the account joins a
/// household: the same provider suddenly serves another collection.
class SwitchingServer implements CollectionSyncProvider {
  SwitchingServer(this.current, this.id);

  FakeServer current;
  String id;

  @override
  String get scope => 'switching';

  @override
  Future<List<SyncPushResult>> push(List<SyncChange> changes) =>
      current.push(changes);

  @override
  Future<SyncPullPage> pull(int cursor, {int limit = 200}) async {
    final page = await current.pull(cursor, limit: limit);
    return SyncPullPage(
      changes: page.changes,
      nextCursor: page.nextCursor,
      hasMore: page.hasMore,
      reset: page.reset,
      collectionId: id,
    );
  }

  @override
  Future<SyncSnapshotInfo> snapshot() => current.snapshot();
}

void main() {
  test(
    'a device that now syncs with another collection sends everything again',
    () async {
      final own = FakeServer();
      final household = FakeServer();
      final phone = Device(own);
      addTearDown(phone.db.close);
      final server = SwitchingServer(own, 'own');
      final engine = SyncEngine(phone.db, server);

      await phone.own(603);
      await engine.run();
      expect((await own.snapshot()).counts['title'], 1);

      // Someone else's household already holds a film.
      final other = Device(household);
      addTearDown(other.db.close);
      await other.own(604);
      await other.engine.run();

      server
        ..current = household
        ..id = 'household';
      await engine.run();

      expect((await household.snapshot()).counts['title'], 2);
      expect(await phone.movie(603), isNotNull);
      expect(await phone.movie(604), isNotNull);
    },
  );

  test('a household is read from the server answer', () {
    final household = Household.fromJson({
      'collectionId': 'c',
      'isOwner': false,
      'members': [
        {'id': 1, 'name': 'anna', 'owner': true, 'you': false},
        {'id': 2, 'name': 'ben', 'owner': false, 'you': true},
      ],
    });
    expect(household.shared, isTrue);
    expect(household.members.last.you, isTrue);
    expect(household.isOwner, isFalse);
  });
}
