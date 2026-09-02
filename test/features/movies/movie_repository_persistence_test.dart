import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_api_client.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/features/collections/data/collection_repository.dart';
import 'package:movie_shelf/features/movies/data/movie_repository.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

class _FakeTmdb extends Fake implements TmdbApiClient {
  _FakeTmdb(this.movies);

  final Map<int, TmdbMovieDetails> movies;

  @override
  Future<TmdbMovieDetails> getMovieDetails(int tmdbId) async {
    final details = movies[tmdbId];
    if (details == null) {
      throw StateError('No fixture for $tmdbId');
    }
    return details;
  }
}

void main() {
  late AppDatabase db;
  late MovieRepository movies;

  final action = const TmdbGenre(id: 28, name: 'Action');
  final comedy = const TmdbGenre(id: 35, name: 'Komödie');

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    final tmdb = _FakeTmdb({
      1: TmdbMovieDetails(
        id: 1,
        title: 'Pacific Rim',
        genres: [action, comedy],
      ),
      2: const TmdbMovieDetails(
        id: 2,
        title: 'Mr. Deeds',
        genres: [TmdbGenre(id: 35, name: 'Komödie')],
      ),
    });
    movies = MovieRepository(db, tmdb, CollectionRepository(db, tmdb));
  });

  tearDown(() => db.close());

  test(
    'two movies sharing a genre persist without a unique constraint error',
    () async {
      await movies.addFromTmdb(1, status: CollectionStatus.owned);
      await movies.addFromTmdb(2, status: CollectionStatus.owned);

      final stored = await db.select(db.movies).get();
      expect(stored, hasLength(2));
      final genres = await db.select(db.genres).get();
      expect(genres.map((g) => g.tmdbId), unorderedEquals([28, 35]));
    },
  );

  test('upserting an existing movie upgrades wishlist to owned', () async {
    await movies.addFromTmdb(1, status: CollectionStatus.wishlist);
    final result = await movies.upsertFromDetails(
      const TmdbMovieDetails(
        id: 1,
        title: 'Pacific Rim',
        genres: [TmdbGenre(id: 28, name: 'Action')],
      ),
      status: CollectionStatus.owned,
      syncCollection: false,
    );
    expect(result.kind, MoviePersistKind.updated);
    expect(result.movie.status, CollectionStatus.owned);
    expect(await db.select(db.movies).get(), hasLength(1));
  });
}
