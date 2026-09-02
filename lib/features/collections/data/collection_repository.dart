import 'package:drift/drift.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/mappers/movie_mapper.dart';
import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../shared/models/collection_with_entries.dart';

class CollectionRepository {
  CollectionRepository(this._db, this._tmdb);

  final AppDatabase _db;
  final TmdbApiClient _tmdb;

  Future<void> syncCollection(
    int tmdbCollectionId, {
    bool forceRefresh = false,
  }) async {
    final existing =
        await (_db.select(_db.collections)
              ..where((t) => t.tmdbCollectionId.equals(tmdbCollectionId)))
            .getSingleOrNull();

    if (existing != null && !forceRefresh && existing.lastSyncedAt != null) {
      final age = DateTime.now().difference(existing.lastSyncedAt!);
      if (age < AppConstants.collectionStaleAfter) return;
    }

    final details = await _tmdb.getCollection(tmdbCollectionId);

    await _db.transaction(() async {
      await _db
          .into(_db.collections)
          .insert(
            CollectionsCompanion.insert(
              tmdbCollectionId: Value(tmdbCollectionId),
              name: details.name,
              overview: Value(details.overview),
              posterPath: Value(details.posterPath),
              backdropPath: Value(details.backdropPath),
              lastSyncedAt: Value(DateTime.now()),
            ),
            onConflict: DoUpdate(
              (_) => CollectionsCompanion(
                name: Value(details.name),
                overview: Value(details.overview),
                posterPath: Value(details.posterPath),
                backdropPath: Value(details.backdropPath),
                lastSyncedAt: Value(DateTime.now()),
              ),
              target: [_db.collections.tmdbCollectionId],
            ),
          );

      final row = await (_db.select(
        _db.collections,
      )..where((t) => t.tmdbCollectionId.equals(tmdbCollectionId))).getSingle();
      final resolvedId = row.id;

      await (_db.delete(
        _db.collectionMovies,
      )..where((t) => t.collectionId.equals(resolvedId))).go();

      for (final part in details.parts) {
        await _db
            .into(_db.collectionMovies)
            .insert(
              CollectionMoviesCompanion.insert(
                collectionId: resolvedId,
                tmdbMovieId: part.id,
                title: part.title,
                originalTitle: Value(part.originalTitle),
                posterPath: Value(part.posterPath),
                releaseDate: Value(part.releaseDate),
              ),
            );
      }
    });
  }

  Stream<List<CollectionWithEntries>> watchAllCollections() {
    final query = _db.select(_db.collections)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch().asyncMap((rows) async {
      final result = <CollectionWithEntries>[];
      for (final row in rows) {
        result.add(await _buildCollectionWithEntries(row));
      }
      return result;
    });
  }

  Stream<CollectionWithEntries?> watchCollection(int collectionId) {
    final query = _db.select(_db.collections)
      ..where((t) => t.id.equals(collectionId));
    return query.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;
      return _buildCollectionWithEntries(row);
    });
  }

  Stream<CollectionWithEntries?> watchCollectionByTmdbId(int tmdbCollectionId) {
    final query = _db.select(_db.collections)
      ..where((t) => t.tmdbCollectionId.equals(tmdbCollectionId));
    return query.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;
      return _buildCollectionWithEntries(row);
    });
  }

  Future<CollectionWithEntries> _buildCollectionWithEntries(
    CollectionRow row,
  ) async {
    final partsQuery = _db.select(_db.collectionMovies)
      ..where((t) => t.collectionId.equals(row.id))
      ..orderBy([(t) => OrderingTerm.asc(t.releaseDate)]);
    final parts = await partsQuery.get();

    final entries = <CollectionEntry>[];
    for (final part in parts) {
      final localRow = await (_db.select(
        _db.movies,
      )..where((t) => t.tmdbId.equals(part.tmdbMovieId))).getSingleOrNull();
      final localMovie = localRow == null
          ? null
          : mapMovieRow(localRow, await _genreNames(localRow.id));
      entries.add(
        CollectionEntry(
          tmdbMovieId: part.tmdbMovieId,
          title: part.title,
          originalTitle: part.originalTitle,
          posterPath: part.posterPath,
          releaseDate: part.releaseDate,
          localMovie: localMovie,
        ),
      );
    }

    return CollectionWithEntries(
      id: row.id,
      tmdbCollectionId: row.tmdbCollectionId,
      name: row.name,
      overview: row.overview,
      posterPath: row.posterPath,
      backdropPath: row.backdropPath,
      entries: entries,
    );
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
}
