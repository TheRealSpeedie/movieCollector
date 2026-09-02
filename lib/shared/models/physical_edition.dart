import 'movie.dart';
import 'physical_edition_kind.dart';
import 'tv_season.dart';
import 'tv_series.dart';

class PhysicalEditionContents {
  const PhysicalEditionContents({
    required this.id,
    required this.kind,
    this.productTitle,
    this.editionName,
    this.tmdbCollectionId,
    this.tmdbTvSeriesId,
    this.movies = const [],
    this.seasons = const [],
    this.series,
    required this.createdAt,
  });

  final int id;
  final PhysicalEditionKind kind;
  final String? productTitle;
  final String? editionName;
  final int? tmdbCollectionId;
  final int? tmdbTvSeriesId;
  final List<Movie> movies;
  final List<TvSeason> seasons;
  final TvSeries? series;
  final DateTime createdAt;

  int get itemCount => movies.length + seasons.length;
}
