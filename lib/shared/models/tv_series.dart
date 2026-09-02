import 'package:freezed_annotation/freezed_annotation.dart';

part 'tv_series.freezed.dart';

@freezed
abstract class TvSeries with _$TvSeries {
  const factory TvSeries({
    required int id,
    required int tmdbId,
    required String name,
    String? originalName,
    String? overview,
    String? posterPath,
    String? backdropPath,
    DateTime? firstAirDate,
    DateTime? lastAirDate,
    int? numberOfSeasons,
    String? seriesStatus,
    String? originalLanguage,
    String? contentRating,
    @Default(<String>[]) List<String> genres,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastMetadataSyncAt,
  }) = _TvSeries;
}
