import 'package:drift/drift.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/mappers/movie_mapper.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/movie.dart';
import '../../collections/data/collection_repository.dart';

enum MoviePersistKind { added, updated, alreadyExists }

class MovieUpsertResult {
  const MovieUpsertResult({required this.movie, required this.kind});

  final Movie movie;
  final MoviePersistKind kind;
}

class MovieRepository {
  MovieRepository(this._db, this._tmdb, this._collectionRepository);

  final AppDatabase _db;
  final TmdbApiClient _tmdb;
  final CollectionRepository _collectionRepository;

  Stream<List<Movie>> watchAllMovies() {
    final query = _db.select(_db.movies)
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch().asyncMap(_mapRows);
  }

  Stream<Movie?> watchMovie(int id) {
    final query = _db.select(_db.movies)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;
      return mapMovieRow(row, await _genreNames(row.id));
    });
  }

  Future<Movie?> getMovieByTmdbId(int tmdbId) async {
    final row = await (_db.select(
      _db.movies,
    )..where((t) => t.tmdbId.equals(tmdbId))).getSingleOrNull();
    if (row == null) return null;
    return mapMovieRow(row, await _genreNames(row.id));
  }

  Future<Movie> addFromTmdb(
    int tmdbId, {
    required CollectionStatus status,
    bool syncCollection = true,
  }) async {
    final existing = await getMovieByTmdbId(tmdbId);
    if (existing != null) throw const DuplicateMovieException();

    final details = await _tmdb.getMovieDetails(tmdbId);
    final result = await upsertFromDetails(
      details,
      status: status,
      syncCollection: syncCollection,
    );
    if (result.kind != MoviePersistKind.added) {
      throw const DuplicateMovieException();
    }
    return result.movie;
  }

  Future<MovieUpsertResult> upsertFromDetails(
    TmdbMovieDetails details, {
    required CollectionStatus status,
    bool syncCollection = true,
  }) async {
    final existing = await getMovieByTmdbId(details.id);
    if (existing != null) {
      return applyImportedStatus(existing, status);
    }

    try {
      final movie = await _insertMovie(details, status);
      if (syncCollection && details.collection != null) {
        try {
          await _collectionRepository.syncCollection(details.collection!.id);
        } catch (_) {}
      }
      return MovieUpsertResult(movie: movie, kind: MoviePersistKind.added);
    } catch (error) {
      final duplicate = await getMovieByTmdbId(details.id);
      if (duplicate != null) {
        return applyImportedStatus(duplicate, status);
      }
      rethrow;
    }
  }

  Future<MovieUpsertResult> applyImportedStatus(
    Movie existing,
    CollectionStatus incoming,
  ) async {
    final merged = existing.status.mergePreferringStronger(incoming);
    if (merged == existing.status) {
      return MovieUpsertResult(
        movie: existing,
        kind: MoviePersistKind.alreadyExists,
      );
    }
    await updateStatus(existing.id, merged);
    return MovieUpsertResult(
      movie: existing.copyWith(status: merged, updatedAt: DateTime.now()),
      kind: MoviePersistKind.updated,
    );
  }

  Future<Movie> _insertMovie(
    TmdbMovieDetails details,
    CollectionStatus status,
  ) async {
    final now = DateTime.now();
    final movieId = await _db.transaction(() async {
      final id = await _db
          .into(_db.movies)
          .insert(
            MoviesCompanion.insert(
              tmdbId: Value(details.id),
              title: details.title,
              originalTitle: Value(details.originalTitle),
              overview: Value(details.overview),
              releaseDate: Value(details.releaseDate),
              releaseYear: Value(details.releaseYear),
              runtime: Value(details.runtime),
              posterPath: Value(details.posterPath),
              backdropPath: Value(details.backdropPath),
              certification: Value(details.certification),
              originalLanguage: Value(details.originalLanguage),
              tmdbCollectionId: Value(details.collection?.id),
              userStatus: Value(status),
              createdAt: Value(now),
              updatedAt: Value(now),
              lastMetadataSyncAt: Value(now),
            ),
          );
      await _linkGenres(id, details.genres);
      return id;
    });

    final row = await (_db.select(
      _db.movies,
    )..where((t) => t.id.equals(movieId))).getSingle();
    return mapMovieRow(row, await _genreNames(movieId));
  }

  Future<void> updateStatus(int movieId, CollectionStatus status) async {
    await (_db.update(_db.movies)..where((t) => t.id.equals(movieId))).write(
      MoviesCompanion(
        userStatus: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<Movie> refreshMetadata(int movieId) async {
    final row = await (_db.select(
      _db.movies,
    )..where((t) => t.id.equals(movieId))).getSingle();
    if (row.tmdbId == null) return mapMovieRow(row, await _genreNames(movieId));

    final details = await _tmdb.getMovieDetails(row.tmdbId!);
    final now = DateTime.now();

    await _db.transaction(() async {
      await (_db.update(_db.movies)..where((t) => t.id.equals(movieId))).write(
        MoviesCompanion(
          title: Value(details.title),
          originalTitle: Value(details.originalTitle),
          overview: Value(details.overview),
          releaseDate: Value(details.releaseDate),
          releaseYear: Value(details.releaseYear),
          runtime: Value(details.runtime),
          posterPath: Value(details.posterPath),
          backdropPath: Value(details.backdropPath),
          certification: Value(details.certification),
          originalLanguage: Value(details.originalLanguage),
          tmdbCollectionId: Value(details.collection?.id),
          updatedAt: Value(now),
          lastMetadataSyncAt: Value(now),
        ),
      );
      await (_db.delete(
        _db.movieGenres,
      )..where((t) => t.movieId.equals(movieId))).go();
      await _linkGenres(movieId, details.genres);
    });

    if (details.collection != null) {
      try {
        await _collectionRepository.syncCollection(
          details.collection!.id,
          forceRefresh: true,
        );
      } catch (_) {}
    }

    final updated = await (_db.select(
      _db.movies,
    )..where((t) => t.id.equals(movieId))).getSingle();
    return mapMovieRow(updated, await _genreNames(movieId));
  }

  Future<void> deleteMovie(int movieId) async {
    await (_db.delete(_db.movies)..where((t) => t.id.equals(movieId))).go();
  }

  bool isMetadataStale(Movie movie) {
    if (movie.lastMetadataSyncAt == null) return true;
    return DateTime.now().difference(movie.lastMetadataSyncAt!) >
        AppConstants.metadataStaleAfter;
  }

  Future<void> _linkGenres(int movieId, List<TmdbGenre> genres) async {
    for (final genre in genres) {
      if (genre.id == 0 && genre.name.isEmpty) continue;
      final genreId = await _db.upsertGenre(
        tmdbId: genre.id,
        name: genre.name.isEmpty ? 'Genre ${genre.id}' : genre.name,
      );
      await _db
          .into(_db.movieGenres)
          .insertOnConflictUpdate(
            MovieGenresCompanion.insert(movieId: movieId, genreId: genreId),
          );
    }
  }

  Future<List<String>> _genreNames(int movieId) async {
    final query = _db.select(_db.genres).join([
      innerJoin(
        _db.movieGenres,
        _db.movieGenres.genreId.equalsExp(_db.genres.id),
      ),
    ])..where(_db.movieGenres.movieId.equals(movieId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(_db.genres).name).toList();
  }

  Future<List<Movie>> _mapRows(List<MovieRow> rows) async {
    final movies = <Movie>[];
    for (final row in rows) {
      movies.add(mapMovieRow(row, await _genreNames(row.id)));
    }
    return movies;
  }
}
