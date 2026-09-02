import '../../../shared/models/tv_season.dart';
import '../../../shared/models/tv_series.dart';
import '../app_database.dart';

TvSeries mapTvSeriesRow(TvSeriesRow row, List<String> genres) {
  return TvSeries(
    id: row.id,
    tmdbId: row.tmdbId,
    name: row.name,
    originalName: row.originalName,
    overview: row.overview,
    posterPath: row.posterPath,
    backdropPath: row.backdropPath,
    firstAirDate: row.firstAirDate,
    lastAirDate: row.lastAirDate,
    numberOfSeasons: row.numberOfSeasons,
    seriesStatus: row.seriesStatus,
    originalLanguage: row.originalLanguage,
    contentRating: row.contentRating,
    genres: genres,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    lastMetadataSyncAt: row.lastMetadataSyncAt,
  );
}

TvSeason mapTvSeasonRow(TvSeasonRow row) {
  return TvSeason(
    id: row.id,
    seriesId: row.seriesId,
    tmdbSeasonId: row.tmdbSeasonId,
    seasonNumber: row.seasonNumber,
    name: row.name,
    overview: row.overview,
    posterPath: row.posterPath,
    airDate: row.airDate,
    episodeCount: row.episodeCount,
    status: row.userStatus,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
  );
}
