import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/collection/ownership_service.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/sync/collection_records.dart';
import 'package:movie_shelf/core/sync/sync_engine.dart';
import 'package:movie_shelf/features/sync/data/self_hosted_sync_provider.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

import 'support.dart';

class Phone {
  Phone(this.db, this.sync) : ownership = OwnershipService(db);

  final AppDatabase db;
  final SyncEngine sync;
  final OwnershipService ownership;

  Future<int> addMovie(int tmdbId, CollectionStatus status) async {
    final id = await db
        .into(db.movies)
        .insert(
          MoviesCompanion.insert(title: 'Film $tmdbId', tmdbId: Value(tmdbId)),
        );
    await ownership.setMovieStatus(id, status);
    return id;
  }

  Future<MovieRow?> movie(int tmdbId) => (db.select(
    db.movies,
  )..where((t) => t.tmdbId.equals(tmdbId))).getSingleOrNull();

  Future<OwnedCopyRow> copyOf(int tmdbId) async {
    final movie = (await this.movie(tmdbId))!;
    final row = await db
        .customSelect(
          'SELECT c.id FROM owned_copies c '
          'JOIN physical_edition_movies em ON em.edition_id = c.edition_id '
          'WHERE em.movie_id = ? LIMIT 1',
          variables: [Variable.withInt(movie.id)],
        )
        .getSingle();
    return (db.select(
      db.ownedCopies,
    )..where((t) => t.id.equals(row.read<int>('id')))).getSingle();
  }
}

void main() {
  late Admin admin;

  setUpAll(() async {
    if (skipReason != null) return;
    admin = await Admin.login();
  });

  // Every phone signs in as the same user, so they share one collection.
  Future<Phone> phone(String name) async {
    final client = clientFor(await pair(await admin.newLink(), name: name));
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    return Phone(db, SyncEngine(db, SelfHostedSyncProvider(client)));
  }

  test('an owned film on one phone arrives on the other', () async {
    final first = await phone('Phone one');
    final second = await phone('Phone two');
    await first.addMovie(9990001, CollectionStatus.owned);

    expect((await first.sync.run()).pushed, greaterThan(0));
    await second.sync.run();

    final arrived = await second.movie(9990001);
    expect(arrived, isNotNull);
    expect(arrived!.userStatus, CollectionStatus.owned);
  }, skip: skipReason);

  test('the same film added on two phones offline stays one title', () async {
    final first = await phone('Phone three');
    final second = await phone('Phone four');
    await first.addMovie(9990002, CollectionStatus.owned);
    await second.addMovie(9990002, CollectionStatus.wishlist);

    await first.sync.run();
    await second.sync.run();
    await first.sync.run();

    for (final device in [first, second]) {
      final titles = (await CollectionRecords(device.db).buildAll()).values
          .where(
            (r) =>
                r.type == SyncEntityType.title && r.fields['tmdbId'] == 9990002,
          );
      expect(titles, hasLength(1));
      // The copy from the first phone means the film is owned everywhere.
      expect((await device.movie(9990002))!.userStatus, CollectionStatus.owned);
    }
  }, skip: skipReason);

  test(
    'a concurrent edit is kept on the device until the user chooses',
    () async {
      final first = await phone('Phone five');
      final second = await phone('Phone six');
      await first.addMovie(9990003, CollectionStatus.owned);
      await first.sync.run();
      await second.sync.run();

      Future<void> setLocation(Phone device, String location) async {
        final copy = await device.copyOf(9990003);
        await (device.db.update(device.db.ownedCopies)
              ..where((t) => t.id.equals(copy.id)))
            .write(OwnedCopiesCompanion(storageLocation: Value(location)));
      }

      await setLocation(first, 'Wohnzimmer');
      await setLocation(second, 'Keller');
      await first.sync.run();
      final report = await second.sync.run();

      expect(report.conflicts, 1);
      expect((await second.copyOf(9990003)).storageLocation, 'Keller');

      final conflict = await second.db
          .select(second.db.syncConflicts)
          .getSingle();
      await second.sync.resolve(conflict, keepLocal: false);
      expect((await second.copyOf(9990003)).storageLocation, 'Wohnzimmer');
      expect((await second.sync.run()).conflicts, 0);
    },
    skip: skipReason,
  );

  test('stopping sync never deletes the collection on the phone', () async {
    final first = await phone('Phone seven');
    await first.addMovie(9990004, CollectionStatus.owned);
    await first.sync.run();

    await first.sync.reset();

    expect((await first.movie(9990004))!.userStatus, CollectionStatus.owned);
    expect(await first.db.select(first.db.syncShadow).get(), isEmpty);
  }, skip: skipReason);
}
