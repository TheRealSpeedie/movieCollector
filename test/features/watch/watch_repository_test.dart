import 'package:dio/dio.dart';
import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/collection/ownership_service.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/database/media_format.dart';
import 'package:movie_shelf/core/network/dio_client.dart';
import 'package:movie_shelf/core/network/network_info.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_api_client.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_watch_models.dart';
import 'package:movie_shelf/core/sync/collection_records.dart';
import 'package:movie_shelf/features/editions/data/copy_repository.dart';
import 'package:movie_shelf/features/personal/data/personal_state_repository.dart';
import 'package:movie_shelf/features/watch/data/watch_repository.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

class _Online implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}

class _FakeTmdb extends TmdbApiClient {
  _FakeTmdb() : super(DioClient(dio: Dio(), networkInfo: _Online()));

  var calls = 0;
  var offline = false;

  @override
  Future<TmdbWatchProviders> getWatchProviders(
    String mediaType,
    int tmdbId,
    String region,
  ) async {
    calls++;
    if (offline) throw Exception('offline');
    return const TmdbWatchProviders(
      offers: [
        TmdbWatchOffer(
          providerId: 8,
          providerName: 'Netflix',
          type: OfferType.flatrate,
        ),
      ],
      link: 'https://www.themoviedb.org/movie/603/watch',
    );
  }
}

void main() {
  late AppDatabase db;
  late _FakeTmdb tmdb;
  late DateTime now;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    tmdb = _FakeTmdb();
    now = DateTime(2026, 10, 27);
  });

  tearDown(() => db.close());

  group('streaming offers', () {
    late WatchRepository repository;
    setUp(() => repository = WatchRepository(db, tmdb, now: () => now));

    test('are cached for a week', () async {
      await repository.offers('movie', 603, 'DE');
      await repository.offers('movie', 603, 'DE');
      expect(tmdb.calls, 1);

      now = now.add(const Duration(days: 8));
      await repository.offers('movie', 603, 'DE');
      expect(tmdb.calls, 2);
    });

    test('fall back to the cache without a connection', () async {
      await repository.offers('movie', 603, 'DE');
      tmdb.offline = true;
      final cached = await repository.offers('movie', 603, 'DE', refresh: true);
      expect(cached.offers.single.providerName, 'Netflix');
      expect(cached.checkedAt, DateTime(2026, 10, 27));
    });

    test('are kept per region', () async {
      await repository.offers('movie', 603, 'DE');
      expect(await repository.isStale('movie', 603, 'AT'), isTrue);
      expect((await repository.allCached('DE'))['movie:603'], hasLength(1));
    });

    test('subscriptions are synced records', () async {
      await repository.setSubscribed(
        const TmdbProvider(id: 8, name: 'Netflix'),
        true,
      );
      final records = await CollectionRecords(db).buildAll();
      expect(
        records.values.where((r) => r.type == SyncEntityType.subscription),
        hasLength(1),
      );
    });
  });

  group('personal state', () {
    late PersonalStateRepository repository;
    late int movie;
    setUp(() async {
      repository = PersonalStateRepository(db, now: () => now);
      movie = await db
          .into(db.movies)
          .insert(
            MoviesCompanion.insert(title: 'Matrix', tmdbId: const Value(603)),
          );
    });

    test('watched counts viewings and unwatched keeps the history', () async {
      await repository.setWatched(movieSubject(movie), true);
      now = now.add(const Duration(days: 1));
      await repository.setWatched(movieSubject(movie), true);
      var state = await repository.get(movieSubject(movie));
      expect(state!.watchCount, 2);
      expect(state.lastWatchedAt, DateTime(2026, 10, 28));

      await repository.setWatched(movieSubject(movie), false);
      state = await repository.get(movieSubject(movie));
      expect(state!.watchStatus, 'unwatched');
      expect(state.watchCount, 2);
    });

    test('a finished playback counts once per hour', () async {
      await repository.recordViewing(movieSubject(movie));
      now = now.add(const Duration(minutes: 20));
      await repository.recordViewing(movieSubject(movie));
      expect((await repository.get(movieSubject(movie)))!.watchCount, 1);
    });

    test('rating and price limit do not touch the wishlist flag', () async {
      await OwnershipService(
        db,
      ).setMovieStatus(movie, CollectionStatus.wishlist);
      await repository.setRating(movieSubject(movie), 8);
      await repository.setMaxPrice(movieSubject(movie), 9.99);
      final state = await repository.get(movieSubject(movie));
      expect(state!.onWishlist, isTrue);
      expect(state.rating, 8);
      expect(state.maxPrice, 9.99);
    });
  });

  group('copies', () {
    late CopyRepository repository;
    late int movie;
    setUp(() async {
      repository = CopyRepository(db);
      movie = await db
          .into(db.movies)
          .insert(
            MoviesCompanion.insert(title: 'Matrix', tmdbId: const Value(603)),
          );
    });

    Future<CollectionStatus> status() async => (await (db.select(
      db.movies,
    )..where((t) => t.id.equals(movie))).getSingle()).userStatus;

    test(
      'a new owned edition makes the film owned, removing it does not',
      () async {
        final edition = await repository.addMovieEdition(
          movie,
          format: MediaFormat.uhd4k,
          editionName: 'Steelbook',
        );
        expect(await status(), CollectionStatus.owned);

        final editions = await repository.watchForMovie(movie).first;
        expect(editions.single.label, '4K UHD · Steelbook');
        await repository.removeCopy(editions.single.copies.single.id);
        expect(await status(), CollectionStatus.open);
        expect(await repository.removeEditionIfUnused(edition), isTrue);
      },
    );

    test('a season box makes that season owned', () async {
      final series = await db
          .into(db.tvSeriesTable)
          .insert(TvSeriesTableCompanion.insert(tmdbId: 1399, name: 'Serie'));
      final season = await db
          .into(db.tvSeasonsTable)
          .insert(
            TvSeasonsTableCompanion.insert(
              seriesId: series,
              seasonNumber: 3,
              name: 'Staffel 3',
            ),
          );
      await repository.addSeasonEdition(season, format: MediaFormat.bluray);
      final row = await (db.select(
        db.tvSeasonsTable,
      )..where((t) => t.id.equals(season))).getSingle();
      expect(row.userStatus, CollectionStatus.owned);
      final editions = await repository.watchForSeason(season).first;
      expect(editions.single.edition.productTitle, 'Serie – Staffel 3');
    });

    test('a second copy of the same edition is counted', () async {
      final edition = await repository.addMovieEdition(
        movie,
        format: MediaFormat.dvd,
      );
      await repository.addCopy(edition);
      final editions = await repository.watchForMovie(movie).first;
      expect(editions.single.copies, hasLength(2));
    });
  });
}
