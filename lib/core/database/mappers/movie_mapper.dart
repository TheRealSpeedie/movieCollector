import '../../../shared/models/movie.dart';
import '../app_database.dart';

Movie mapMovieRow(MovieRow row, List<String> genres) {
  return Movie(
    id: row.id,
    tmdbId: row.tmdbId,
    title: row.title,
    originalTitle: row.originalTitle,
    overview: row.overview,
    releaseDate: row.releaseDate,
    releaseYear: row.releaseYear,
    runtime: row.runtime,
    posterPath: row.posterPath,
    backdropPath: row.backdropPath,
    certification: row.certification,
    originalLanguage: row.originalLanguage,
    tmdbCollectionId: row.tmdbCollectionId,
    status: row.userStatus,
    genres: genres,
    createdAt: row.createdAt,
    updatedAt: row.updatedAt,
    lastMetadataSyncAt: row.lastMetadataSyncAt,
  );
}
