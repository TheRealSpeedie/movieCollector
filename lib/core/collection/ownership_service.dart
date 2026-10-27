import 'package:drift/drift.dart';

import '../../shared/models/collection_status.dart';
import '../../shared/models/physical_edition_kind.dart';
import '../database/app_database.dart';

/// The only place that changes what the user owns or wishes for.
///
/// Ownership is stored as copies of editions, the wishlist as personal state.
/// `user_status` on movies and seasons is a cache of both that the rest of the
/// app reads; [recompute] keeps it in step.
class OwnershipService {
  OwnershipService(this._db);

  final AppDatabase _db;

  /// Applies a status picked in the UI.
  ///
  /// Owned adds a copy (of [editionId] when given) unless one exists. Wishlist
  /// and open remove the copies of editions that hold only this movie; a movie
  /// that is part of an owned box set stays owned through that set.
  Future<void> setMovieStatus(
    int movieId,
    CollectionStatus status, {
    int? editionId,
  }) async {
    await _db.transaction(() async {
      switch (status) {
        case CollectionStatus.owned:
          if (editionId != null) {
            await _linkMovie(editionId, movieId);
            await ensureCopy(editionId);
          } else if (!await _movieOwned(movieId)) {
            await ensureCopy(await _singleMovieEdition(movieId));
          }
          await _setWishlist(movieId: movieId, onWishlist: false);
        case CollectionStatus.wishlist:
          await _removeSingleCopiesOfMovie(movieId);
          await _setWishlist(movieId: movieId, onWishlist: true);
        case CollectionStatus.open:
          await _removeSingleCopiesOfMovie(movieId);
          await _setWishlist(movieId: movieId, onWishlist: false);
      }
      await recompute();
    });
  }

  /// Season counterpart of [setMovieStatus]. `null` means the season is not
  /// tracked ("Fehlt").
  Future<void> setSeasonStatus(
    int seasonId,
    CollectionStatus? status, {
    int? editionId,
  }) async {
    await _db.transaction(() async {
      if (status == CollectionStatus.owned) {
        if (editionId != null) {
          await _linkSeason(editionId, seasonId);
          await ensureCopy(editionId);
        } else if (!await _seasonOwned(seasonId)) {
          await ensureCopy(await _singleSeasonEdition(seasonId));
        }
        await _setWishlist(seasonId: seasonId, onWishlist: false);
      } else {
        await _removeSingleCopiesOfSeason(seasonId);
        await _setWishlist(
          seasonId: seasonId,
          onWishlist: status == CollectionStatus.wishlist,
        );
      }
      await recompute();
    });
  }

  /// Marks an edition as owned, for example a scanned box set.
  Future<void> ownEdition(int editionId) async {
    await _db.transaction(() async {
      await ensureCopy(editionId);
      await recompute();
    });
  }

  Future<int> ensureCopy(int editionId) async {
    final existing =
        await (_db.select(_db.ownedCopies)
              ..where((t) => t.editionId.equals(editionId))
              ..limit(1))
            .getSingleOrNull();
    if (existing != null) return existing.id;
    return _db
        .into(_db.ownedCopies)
        .insert(OwnedCopiesCompanion.insert(editionId: editionId));
  }

  Future<void> removeCopy(int copyId) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.ownedCopies,
      )..where((t) => t.id.equals(copyId))).go();
      await recompute();
    });
  }

  /// Rewrites the status cache of every movie and season from copies and
  /// personal state.
  Future<void> recompute() async {
    await _db.customStatement('''
UPDATE movies SET user_status = CASE
  WHEN EXISTS (
    SELECT 1 FROM owned_copies c
    JOIN physical_edition_movies em ON em.edition_id = c.edition_id
    WHERE em.movie_id = movies.id) THEN 'owned'
  WHEN EXISTS (
    SELECT 1 FROM personal_states p
    WHERE p.movie_id = movies.id AND p.on_wishlist = 1) THEN 'wishlist'
  ELSE 'open' END
''');
    await _db.customStatement('''
UPDATE tv_seasons SET user_status = CASE
  WHEN EXISTS (
    SELECT 1 FROM owned_copies c
    JOIN physical_edition_tv_seasons es ON es.edition_id = c.edition_id
    WHERE es.season_id = tv_seasons.id) THEN 'owned'
  WHEN EXISTS (
    SELECT 1 FROM personal_states p
    WHERE p.season_id = tv_seasons.id AND p.on_wishlist = 1) THEN 'wishlist'
  ELSE NULL END
''');
    // Drift streams only notice writes made through its own APIs.
    _db.notifyUpdates({
      TableUpdate.onTable(_db.movies, kind: UpdateKind.update),
      TableUpdate.onTable(_db.tvSeasonsTable, kind: UpdateKind.update),
    });
  }

  Future<bool> _movieOwned(int movieId) async {
    final rows = await _db
        .customSelect(
          'SELECT 1 FROM owned_copies c '
          'JOIN physical_edition_movies em ON em.edition_id = c.edition_id '
          'WHERE em.movie_id = ? LIMIT 1',
          variables: [Variable.withInt(movieId)],
        )
        .get();
    return rows.isNotEmpty;
  }

  Future<bool> _seasonOwned(int seasonId) async {
    final rows = await _db
        .customSelect(
          'SELECT 1 FROM owned_copies c '
          'JOIN physical_edition_tv_seasons es ON es.edition_id = c.edition_id '
          'WHERE es.season_id = ? LIMIT 1',
          variables: [Variable.withInt(seasonId)],
        )
        .get();
    return rows.isNotEmpty;
  }

  /// Editions that contain exactly this movie and nothing else.
  Future<List<int>> _singleEditionsOfMovie(int movieId) async {
    final rows = await _db
        .customSelect(
          'SELECT em.edition_id AS id FROM physical_edition_movies em '
          'WHERE em.movie_id = ? '
          'AND (SELECT COUNT(*) FROM physical_edition_movies o '
          '  WHERE o.edition_id = em.edition_id) = 1 '
          'AND NOT EXISTS (SELECT 1 FROM physical_edition_tv_seasons s '
          '  WHERE s.edition_id = em.edition_id)',
          variables: [Variable.withInt(movieId)],
        )
        .get();
    return rows.map((r) => r.read<int>('id')).toList();
  }

  Future<List<int>> _singleEditionsOfSeason(int seasonId) async {
    final rows = await _db
        .customSelect(
          'SELECT es.edition_id AS id FROM physical_edition_tv_seasons es '
          'WHERE es.season_id = ? '
          'AND (SELECT COUNT(*) FROM physical_edition_tv_seasons o '
          '  WHERE o.edition_id = es.edition_id) = 1 '
          'AND NOT EXISTS (SELECT 1 FROM physical_edition_movies m '
          '  WHERE m.edition_id = es.edition_id)',
          variables: [Variable.withInt(seasonId)],
        )
        .get();
    return rows.map((r) => r.read<int>('id')).toList();
  }

  Future<int> _singleMovieEdition(int movieId) async {
    final existing = await _singleEditionsOfMovie(movieId);
    if (existing.isNotEmpty) return existing.first;
    final movie = await (_db.select(
      _db.movies,
    )..where((t) => t.id.equals(movieId))).getSingle();
    final editionId = await _db
        .into(_db.physicalEditions)
        .insert(
          PhysicalEditionsCompanion.insert(
            productTitle: Value(movie.title),
            mediaKind: PhysicalEditionKind.singleMovie.name,
          ),
        );
    await _linkMovie(editionId, movieId);
    return editionId;
  }

  Future<int> _singleSeasonEdition(int seasonId) async {
    final existing = await _singleEditionsOfSeason(seasonId);
    if (existing.isNotEmpty) return existing.first;
    final season = await (_db.select(
      _db.tvSeasonsTable,
    )..where((t) => t.id.equals(seasonId))).getSingle();
    final series = await (_db.select(
      _db.tvSeriesTable,
    )..where((t) => t.id.equals(season.seriesId))).getSingle();
    final editionId = await _db
        .into(_db.physicalEditions)
        .insert(
          PhysicalEditionsCompanion.insert(
            productTitle: Value(
              '${series.name} – Staffel ${season.seasonNumber}',
            ),
            mediaKind: PhysicalEditionKind.singleTvSeason.name,
            tmdbTvSeriesId: Value(series.tmdbId),
          ),
        );
    await _linkSeason(editionId, seasonId);
    return editionId;
  }

  Future<void> _linkMovie(int editionId, int movieId) => _db
      .into(_db.physicalEditionMovies)
      .insert(
        PhysicalEditionMoviesCompanion.insert(
          editionId: editionId,
          movieId: movieId,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> _linkSeason(int editionId, int seasonId) => _db
      .into(_db.physicalEditionTvSeasons)
      .insert(
        PhysicalEditionTvSeasonsCompanion.insert(
          editionId: editionId,
          seasonId: seasonId,
        ),
        mode: InsertMode.insertOrIgnore,
      );

  Future<void> _removeSingleCopiesOfMovie(int movieId) async {
    final editions = await _singleEditionsOfMovie(movieId);
    if (editions.isEmpty) return;
    await (_db.delete(
      _db.ownedCopies,
    )..where((t) => t.editionId.isIn(editions))).go();
  }

  Future<void> _removeSingleCopiesOfSeason(int seasonId) async {
    final editions = await _singleEditionsOfSeason(seasonId);
    if (editions.isEmpty) return;
    await (_db.delete(
      _db.ownedCopies,
    )..where((t) => t.editionId.isIn(editions))).go();
  }

  Future<void> _setWishlist({
    int? movieId,
    int? seasonId,
    required bool onWishlist,
  }) async {
    final query = _db.select(_db.personalStates)
      ..where(
        (t) => movieId != null
            ? t.movieId.equals(movieId)
            : t.seasonId.equals(seasonId!),
      );
    final existing = await query.getSingleOrNull();
    if (existing == null) {
      if (!onWishlist) return;
      await _db
          .into(_db.personalStates)
          .insert(
            PersonalStatesCompanion.insert(
              movieId: Value(movieId),
              seasonId: Value(seasonId),
              onWishlist: const Value(true),
            ),
          );
      return;
    }
    if (existing.onWishlist == onWishlist) return;
    await (_db.update(
      _db.personalStates,
    )..where((t) => t.id.equals(existing.id))).write(
      PersonalStatesCompanion(
        onWishlist: Value(onWishlist),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }
}
