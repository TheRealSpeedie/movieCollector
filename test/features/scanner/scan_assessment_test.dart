import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/collection/ownership_service.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/features/scanner/domain/scan_assessment.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:movie_shelf/shared/models/physical_edition_kind.dart';

void main() {
  late AppDatabase db;
  late OwnershipService ownership;
  late ScanAssessor assessor;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    ownership = OwnershipService(db);
    assessor = ScanAssessor(db);
  });

  tearDown(() => db.close());

  Future<int> movie(int tmdbId, {int? collection}) => db
      .into(db.movies)
      .insert(
        MoviesCompanion.insert(
          title: 'Film $tmdbId',
          tmdbId: Value(tmdbId),
          tmdbCollectionId: Value(collection),
        ),
      );

  Future<int> edition(int movieId, String format) async {
    final id = await db
        .into(db.physicalEditions)
        .insert(
          PhysicalEditionsCompanion.insert(
            mediaKind: PhysicalEditionKind.singleMovie.name,
            format: Value(format),
          ),
        );
    await db
        .into(db.physicalEditionMovies)
        .insert(
          PhysicalEditionMoviesCompanion.insert(
            editionId: id,
            movieId: movieId,
          ),
        );
    return id;
  }

  test('the exact owned edition is recognised offline', () async {
    final id = await movie(1);
    final bluray = await edition(id, 'bluray');
    await ownership.setMovieStatus(
      id,
      CollectionStatus.owned,
      editionId: bluray,
    );

    final result = await assessor.forEdition(bluray);
    expect(result.confidence, MatchConfidence.exact);
    expect(result.primary, ScanVerdict.alreadyOwnedExact);
    expect(result.insights.first.message, contains('Blu-ray'));
  });

  test('a 4K edition of a film owned on DVD is an upgrade', () async {
    final id = await movie(1);
    final dvd = await edition(id, 'dvd');
    final uhd = await edition(id, 'uhd4k');
    await ownership.setMovieStatus(id, CollectionStatus.owned, editionId: dvd);

    final result = await assessor.forEdition(uhd);
    expect(result.primary, ScanVerdict.upgrade);
    expect(
      result.insights.first.message,
      'Du hast die DVD. Das hier ist ein Upgrade auf 4K UHD.',
    );
  });

  test('a wishlist film shows the price limit', () async {
    final id = await movie(1);
    await ownership.setMovieStatus(id, CollectionStatus.wishlist);
    await (db.update(db.personalStates)..where((t) => t.movieId.equals(id)))
        .write(const PersonalStatesCompanion(maxPrice: Value(12)));

    final result = await assessor.forTitle(tmdbId: 1);
    expect(result.confidence, MatchConfidence.probable);
    expect(result.primary, ScanVerdict.wishlistMatch);
    expect(result.maxPrice, 12);
  });

  test('the missing part of a franchise completes it', () async {
    final collection = await db
        .into(db.collections)
        .insert(
          CollectionsCompanion.insert(
            name: 'Trilogie',
            tmdbCollectionId: const Value(10),
          ),
        );
    for (final (tmdbId, year) in [(1, 2001), (2, 2002), (3, 2003)]) {
      await db
          .into(db.collectionMovies)
          .insert(
            CollectionMoviesCompanion.insert(
              collectionId: collection,
              tmdbMovieId: tmdbId,
              title: 'Film $tmdbId',
              releaseDate: Value(DateTime(year)),
            ),
          );
    }
    for (final tmdbId in [1, 3]) {
      await ownership.setMovieStatus(
        await movie(tmdbId, collection: 10),
        CollectionStatus.owned,
      );
    }

    final result = await assessor.forTitle(tmdbId: 2, tmdbCollectionId: 10);
    expect(result.primary, ScanVerdict.collectionGap);
    expect(
      result.insights.first.message,
      'Du hast Teil 1 und 3 von „Trilogie“. Das vervollständigt deine Reihe.',
    );
  });

  test(
    'a film on the home server but not on disc is a digital duplicate',
    () async {
      final result = await assessor.forTitle(tmdbId: 7, digitalTmdbIds: {7});
      expect(result.primary, ScanVerdict.digitalDuplicate);
    },
  );

  test('anything else is a new discovery', () async {
    final result = await assessor.forTitle(tmdbId: 42);
    expect(result.primary, ScanVerdict.newDiscovery);
  });

  test('a scanned season box names the missing season', () async {
    final series = await db
        .into(db.tvSeriesTable)
        .insert(TvSeriesTableCompanion.insert(tmdbId: 1399, name: 'Serie'));
    final seasons = <int, int>{};
    for (final n in [1, 2, 3, 4]) {
      seasons[n] = await db
          .into(db.tvSeasonsTable)
          .insert(
            TvSeasonsTableCompanion.insert(
              seriesId: series,
              seasonNumber: n,
              name: 'Staffel $n',
            ),
          );
    }
    for (final n in [1, 2, 4]) {
      await ownership.setSeasonStatus(seasons[n]!, CollectionStatus.owned);
    }
    final box = await db
        .into(db.physicalEditions)
        .insert(
          PhysicalEditionsCompanion.insert(
            mediaKind: PhysicalEditionKind.singleTvSeason.name,
          ),
        );
    await db
        .into(db.physicalEditionTvSeasons)
        .insert(
          PhysicalEditionTvSeasonsCompanion.insert(
            editionId: box,
            seasonId: seasons[3]!,
          ),
        );

    final result = await assessor.forEdition(box);
    expect(result.primary, ScanVerdict.missingSeason);
    expect(
      result.insights.first.message,
      'Du hast Staffel 1, 2 und 4. Das hier ist die fehlende Staffel 3.',
    );
  });

  test('owning a box set does not create a copy per film', () async {
    final a = await movie(1);
    final b = await movie(2);
    final set = await db
        .into(db.physicalEditions)
        .insert(
          PhysicalEditionsCompanion.insert(
            mediaKind: PhysicalEditionKind.movieBundle.name,
          ),
        );
    for (final id in [a, b]) {
      await ownership.setMovieStatus(
        id,
        CollectionStatus.owned,
        editionId: set,
      );
    }
    expect(await db.select(db.ownedCopies).get(), hasLength(1));
    // Marking one film of an owned set as open cannot un-own the set.
    await ownership.setMovieStatus(a, CollectionStatus.open);
    final movies = await db.select(db.movies).get();
    expect(movies.every((m) => m.userStatus == CollectionStatus.owned), isTrue);
  });
}
