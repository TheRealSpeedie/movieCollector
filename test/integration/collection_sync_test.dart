import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/features/scanner/data/barcode_repository.dart';
import 'package:movie_shelf/features/server/data/library_repository.dart';
import 'package:movie_shelf/features/sync/data/collection_sync_repository.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

import 'support.dart';

class Phone {
  Phone(this.db, this.sync);

  final AppDatabase db;
  final CollectionSyncRepository sync;

  Future<int> addMovie(int tmdbId, CollectionStatus status) => db
      .into(db.movies)
      .insert(
        MoviesCompanion.insert(
          title: 'Film $tmdbId',
          tmdbId: Value(tmdbId),
          userStatus: Value(status),
        ),
      );

  Future<CollectionStatus> status(int tmdbId) async => (await (db.select(
    db.movies,
  )..where((t) => t.tmdbId.equals(tmdbId))).getSingle()).userStatus;
}

void main() {
  late Admin admin;

  setUpAll(() async {
    if (skipReason != null) return;
    admin = await Admin.login();
  });

  Future<Phone> phone(String name) async {
    final client = clientFor(await pair(await admin.newLink(), name: name));
    final db = AppDatabase(NativeDatabase.memory());
    addTearDown(db.close);
    return Phone(
      db,
      CollectionSyncRepository(db, BarcodeRepository(db), client, name),
    );
  }

  test(
    'a second phone sees a conflict and keeps its data until it chooses',
    () async {
      final first = await phone('Phone one');
      final second = await phone('Phone two');
      await first.addMovie(9990001, CollectionStatus.owned);
      await second.addMovie(9990001, CollectionStatus.wishlist);

      expect((await first.sync.sync()).pushed, 1);
      final report = await second.sync.sync();

      expect(report.conflicts.single.tmdbId, 9990001);
      expect(await second.status(9990001), CollectionStatus.wishlist);

      await second.sync.keepServer(9990001);
      expect(await second.status(9990001), CollectionStatus.owned);
      expect((await second.sync.sync()).pending, 0);
      expect((await first.sync.sync()).pending, 0);
    },
    skip: skipReason,
  );

  test('a change on one phone arrives on the other after approval', () async {
    final first = await phone('Phone three');
    final second = await phone('Phone four');
    await first.addMovie(9990002, CollectionStatus.owned);
    await second.addMovie(9990002, CollectionStatus.owned);
    await first.sync.sync();
    await second.sync.sync();

    await (first.db.update(
      first.db.movies,
    )).write(const MoviesCompanion(userStatus: Value(CollectionStatus.open)));
    expect((await first.sync.sync()).pushed, 1);
    final report = await second.sync.sync();

    expect(report.incoming.single.server.status, CollectionStatus.open);
    expect(await second.status(9990002), CollectionStatus.owned);
    await second.sync.keepServer(9990002);
    expect(await second.status(9990002), CollectionStatus.open);
  }, skip: skipReason);

  test(
    'the server library exposes tmdb ids to match digital copies',
    () async {
      final client = clientFor(
        await pair(await admin.newLink(), name: 'Matcher'),
      );
      final page = await LibraryRepository(
        client,
      ).titles(const TitleQuery(kind: 'Movie'));

      expect(page.items, isNotEmpty);
      expect(page.items.every((t) => !t.isSeries), isTrue);
    },
    skip: skipReason,
  );
}
