import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/collection/ownership_service.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/sync/collection_records.dart';
import 'package:movie_shelf/core/sync/sync_engine.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

import '../sync/collection_switch_test.dart' show SwitchingServer;
import '../sync/sync_engine_test.dart' show Device, FakeServer;

void main() {
  late Device phone;

  setUp(() => phone = Device(FakeServer()));
  tearDown(() => phone.db.close());

  Future<void> giveToBen(int copyId) =>
      (phone.db.update(phone.db.ownedCopies)..where((t) => t.id.equals(copyId)))
          .write(const OwnedCopiesCompanion(ownerId: Value('7')));

  test(
    'owning a film someone else in the household owns adds my own copy',
    () async {
      await phone.own(603);
      await giveToBen((await phone.onlyCopy()).id);
      final edition =
          (await phone.db.select(phone.db.physicalEditions).get()).single;

      await OwnershipService(phone.db).ensureCopy(edition.id);

      final copies = await phone.db.select(phone.db.ownedCopies).get();
      expect(copies, hasLength(2));
      expect(copies.where((c) => c.ownerId == null), hasLength(1));
    },
  );

  test('removing a movie others own keeps it and their copy', () async {
    final id = await phone.own(603);
    await giveToBen((await phone.onlyCopy()).id);
    final edition =
        (await phone.db.select(phone.db.physicalEditions).get()).single;
    await OwnershipService(phone.db).ensureCopy(edition.id);

    final ownership = OwnershipService(phone.db);
    expect(await ownership.othersCopiesOfMovie(id), 1);
    await ownership.removeMyCopiesOfMovie(id);

    final copies = await phone.db.select(phone.db.ownedCopies).get();
    expect(copies.single.ownerId, '7');
    expect((await phone.movie(603))!.userStatus, CollectionStatus.owned);
  });

  test('my own copies arrive without an owner, others keep theirs', () async {
    await phone.own(603);
    final edition =
        (await phone.db.select(phone.db.physicalEditions).get()).single;
    await phone.db
        .into(phone.db.syncMeta)
        .insert(SyncMetaCompanion.insert(key: 'me', value: '3'));
    final records = CollectionRecords(phone.db);
    final editionUuid = edition.uuid!;

    await records.apply(
      [
        SyncRecord(SyncEntityType.copy, 'mine', {
          'editionId': editionUuid,
          'ownerId': '3',
        }),
        SyncRecord(SyncEntityType.copy, 'bens', {
          'editionId': editionUuid,
          'ownerId': '7',
          'private': false,
        }),
      ],
      const [],
      await records.buildAll(),
    );

    final copies = {
      for (final c in await phone.db.select(phone.db.ownedCopies).get())
        c.uuid: c,
    };
    expect(copies['mine']!.ownerId, isNull);
    expect(copies['bens']!.ownerId, '7');
    final built = await records.buildAll();
    expect(built['mine']!.fields.containsKey('ownerId'), isFalse);
    expect(built['bens']!.fields['ownerId'], '7');
  });

  test('after leaving, other people\'s copies stay behind', () async {
    final household = FakeServer();
    final mineAfter = FakeServer();
    final server = SwitchingServer(household, 'household');
    final engine = SyncEngine(phone.db, server);
    await phone.own(603);
    await phone.own(604);
    await engine.run();
    // The copy of 604 belongs to Ben.
    final copies = await phone.db.select(phone.db.ownedCopies).get();
    await giveToBen(copies.last.id);

    server
      ..current = mineAfter
      ..id = 'own';
    await engine.run();

    final left = await phone.db.select(phone.db.ownedCopies).get();
    expect(left, hasLength(1));
    expect(left.single.ownerId, isNull);
    expect((await mineAfter.snapshot()).counts['copy'], 1);
    expect((await phone.movie(604))!.userStatus, CollectionStatus.open);
  });
}
