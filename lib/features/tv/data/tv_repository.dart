import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/mappers/tv_mapper.dart';
import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/tv_season.dart';
import '../../../shared/models/tv_series.dart';
import '../../../shared/models/tv_series_with_seasons.dart';

class TvUpsertResult {
  const TvUpsertResult({
    required this.saved,
    this.seasonsAdded = 0,
    this.seasonsUpdated = 0,
    this.seasonsAlreadyExisting = 0,
  });

  final TvSeriesWithSeasons saved;
  final int seasonsAdded;
  final int seasonsUpdated;
  final int seasonsAlreadyExisting;
}

class TvRepository {
  TvRepository(this._db, this._tmdb);

  final AppDatabase _db;
  final TmdbApiClient _tmdb;

  Stream<List<TvSeriesWithSeasons>> watchAllSeries() {
    final query = _db.select(_db.tvSeriesTable)
      ..orderBy([(t) => OrderingTerm.asc(t.name)]);
    return query.watch().asyncMap((rows) async {
      final result = <TvSeriesWithSeasons>[];
      for (final row in rows) {
        result.add(await _withSeasons(row));
      }
      return result;
    });
  }

  Stream<TvSeriesWithSeasons?> watchSeries(int id) {
    final query = _db.select(_db.tvSeriesTable)..where((t) => t.id.equals(id));
    return query.watchSingleOrNull().asyncMap((row) async {
      if (row == null) return null;
      return _withSeasons(row);
    });
  }

  Future<TvSeriesWithSeasons?> getSeriesWithSeasonsByTmdbId(int tmdbId) async {
    final row = await (_db.select(
      _db.tvSeriesTable,
    )..where((t) => t.tmdbId.equals(tmdbId))).getSingleOrNull();
    if (row == null) return null;
    return _withSeasons(row);
  }

  Future<TvSeries?> getSeriesByTmdbId(int tmdbId) async {
    final row = await (_db.select(
      _db.tvSeriesTable,
    )..where((t) => t.tmdbId.equals(tmdbId))).getSingleOrNull();
    if (row == null) return null;
    return mapTvSeriesRow(row, await _genreNames(row.id));
  }

  Future<TvSeason?> getSeasonByTmdb(int tmdbSeriesId, int seasonNumber) async {
    final series = await (_db.select(
      _db.tvSeriesTable,
    )..where((t) => t.tmdbId.equals(tmdbSeriesId))).getSingleOrNull();
    if (series == null) return null;
    final row =
        await (_db.select(_db.tvSeasonsTable)..where(
              (t) =>
                  t.seriesId.equals(series.id) &
                  t.seasonNumber.equals(seasonNumber),
            ))
            .getSingleOrNull();
    return row == null ? null : mapTvSeasonRow(row);
  }

  Future<TvSeriesWithSeasons> addOrUpdateFromTmdb(
    int tmdbId, {
    Map<int, CollectionStatus> seasonStatuses = const {},
  }) async {
    final details = await _tmdb.getTvDetails(tmdbId);
    final result = await upsertFromDetails(
      details,
      seasonStatuses: seasonStatuses,
    );
    return result.saved;
  }

  Future<TvUpsertResult> upsertFromDetails(
    TmdbTvDetails details, {
    Map<int, CollectionStatus> seasonStatuses = const {},
  }) async {
    final now = DateTime.now();
    final existing = await (_db.select(
      _db.tvSeriesTable,
    )..where((t) => t.tmdbId.equals(details.id))).getSingleOrNull();

    final persist = await _db.transaction(() async {
      late int id;
      if (existing == null) {
        id = await _db
            .into(_db.tvSeriesTable)
            .insert(
              TvSeriesTableCompanion.insert(
                tmdbId: details.id,
                name: details.name,
                originalName: Value(details.originalName),
                overview: Value(details.overview),
                posterPath: Value(details.posterPath),
                backdropPath: Value(details.backdropPath),
                firstAirDate: Value(details.firstAirDate),
                lastAirDate: Value(details.lastAirDate),
                numberOfSeasons: Value(details.numberOfSeasons),
                seriesStatus: Value(details.status),
                originalLanguage: Value(details.originalLanguage),
                contentRating: Value(details.contentRating),
                createdAt: Value(now),
                updatedAt: Value(now),
                lastMetadataSyncAt: Value(now),
              ),
            );
      } else {
        id = existing.id;
        await (_db.update(
          _db.tvSeriesTable,
        )..where((t) => t.id.equals(id))).write(
          TvSeriesTableCompanion(
            name: Value(details.name),
            originalName: Value(details.originalName),
            overview: Value(details.overview),
            posterPath: Value(details.posterPath),
            backdropPath: Value(details.backdropPath),
            firstAirDate: Value(details.firstAirDate),
            lastAirDate: Value(details.lastAirDate),
            numberOfSeasons: Value(details.numberOfSeasons),
            seriesStatus: Value(details.status),
            originalLanguage: Value(details.originalLanguage),
            contentRating: Value(details.contentRating),
            updatedAt: Value(now),
            lastMetadataSyncAt: Value(now),
          ),
        );
      }
      await _linkGenres(id, details.genres);
      final counts = await _upsertSeasons(
        id,
        details.seasons,
        seasonStatuses,
        now,
      );
      return (id: id, counts: counts);
    });

    final row = await (_db.select(
      _db.tvSeriesTable,
    )..where((t) => t.id.equals(persist.id))).getSingle();
    return TvUpsertResult(
      saved: await _withSeasons(row),
      seasonsAdded: persist.counts.added,
      seasonsUpdated: persist.counts.updated,
      seasonsAlreadyExisting: persist.counts.existing,
    );
  }

  Future<void> setSeasonStatus(int seasonId, CollectionStatus? status) async {
    await (_db.update(
      _db.tvSeasonsTable,
    )..where((t) => t.id.equals(seasonId))).write(
      TvSeasonsTableCompanion(
        userStatus: Value(status),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  Future<void> setRegularSeasonsStatus(
    int seriesId,
    CollectionStatus status,
  ) async {
    final seasons = await (_db.select(
      _db.tvSeasonsTable,
    )..where((t) => t.seriesId.equals(seriesId))).get();
    final now = DateTime.now();
    for (final season in seasons) {
      if (season.seasonNumber <= 0) continue;
      await (_db.update(
        _db.tvSeasonsTable,
      )..where((t) => t.id.equals(season.id))).write(
        TvSeasonsTableCompanion(
          userStatus: Value(status),
          updatedAt: Value(now),
        ),
      );
    }
  }

  Future<({int added, int updated, int existing})> _upsertSeasons(
    int seriesId,
    List<TmdbTvSeason> seasons,
    Map<int, CollectionStatus> seasonStatuses,
    DateTime now,
  ) async {
    var added = 0;
    var updated = 0;
    var existingCount = 0;
    for (final season in seasons) {
      final existing =
          await (_db.select(_db.tvSeasonsTable)..where(
                (t) =>
                    t.seriesId.equals(seriesId) &
                    t.seasonNumber.equals(season.seasonNumber),
              ))
              .getSingleOrNull();
      final incomingStatus = seasonStatuses[season.seasonNumber];
      final selected = seasonStatuses.containsKey(season.seasonNumber);
      if (existing == null) {
        await _db
            .into(_db.tvSeasonsTable)
            .insert(
              TvSeasonsTableCompanion.insert(
                seriesId: seriesId,
                tmdbSeasonId: Value(season.id),
                seasonNumber: season.seasonNumber,
                name: season.name,
                overview: Value(season.overview),
                posterPath: Value(season.posterPath),
                airDate: Value(season.airDate),
                episodeCount: Value(season.episodeCount),
                userStatus: Value(incomingStatus),
                createdAt: Value(now),
                updatedAt: Value(now),
              ),
            );
        if (selected && incomingStatus != null) added++;
      } else {
        final merged = CollectionStatus.mergeNullable(
          existing.userStatus,
          incomingStatus,
        );
        await (_db.update(
          _db.tvSeasonsTable,
        )..where((t) => t.id.equals(existing.id))).write(
          TvSeasonsTableCompanion(
            tmdbSeasonId: Value(season.id),
            name: Value(season.name),
            overview: Value(season.overview),
            posterPath: Value(season.posterPath),
            airDate: Value(season.airDate),
            episodeCount: Value(season.episodeCount),
            userStatus: selected ? Value(merged) : const Value.absent(),
            updatedAt: Value(now),
          ),
        );
        if (selected) {
          if (existing.userStatus == null && merged != null) {
            added++;
          } else if (merged != existing.userStatus) {
            updated++;
          } else if (existing.userStatus != null) {
            existingCount++;
          }
        }
      }
    }
    return (added: added, updated: updated, existing: existingCount);
  }

  Future<TvSeriesWithSeasons> _withSeasons(TvSeriesRow row) async {
    final seasonRows =
        await (_db.select(_db.tvSeasonsTable)
              ..where((t) => t.seriesId.equals(row.id))
              ..orderBy([(t) => OrderingTerm.asc(t.seasonNumber)]))
            .get();
    return TvSeriesWithSeasons(
      series: mapTvSeriesRow(row, await _genreNames(row.id)),
      seasons: seasonRows.map(mapTvSeasonRow).toList(),
    );
  }

  Future<void> _linkGenres(int seriesId, List<TmdbGenre> genres) async {
    await (_db.delete(
      _db.tvSeriesGenres,
    )..where((t) => t.seriesId.equals(seriesId))).go();
    for (final genre in genres) {
      if (genre.id == 0 && genre.name.isEmpty) continue;
      final genreId = await _db.upsertGenre(
        tmdbId: genre.id,
        name: genre.name.isEmpty ? 'Genre ${genre.id}' : genre.name,
      );
      await _db
          .into(_db.tvSeriesGenres)
          .insertOnConflictUpdate(
            TvSeriesGenresCompanion.insert(
              seriesId: seriesId,
              genreId: genreId,
            ),
          );
    }
  }

  Future<List<String>> _genreNames(int seriesId) async {
    final query = _db.select(_db.genres).join([
      innerJoin(
        _db.tvSeriesGenres,
        _db.tvSeriesGenres.genreId.equalsExp(_db.genres.id),
      ),
    ])..where(_db.tvSeriesGenres.seriesId.equals(seriesId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(_db.genres).name).toList();
  }
}
