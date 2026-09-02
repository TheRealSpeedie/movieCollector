import 'package:freezed_annotation/freezed_annotation.dart';

import 'collection_status.dart';

part 'movie.freezed.dart';

@freezed
abstract class Movie with _$Movie {
  const factory Movie({
    required int id,
    int? tmdbId,
    required String title,
    String? originalTitle,
    String? overview,
    DateTime? releaseDate,
    int? releaseYear,
    int? runtime,
    String? posterPath,
    String? backdropPath,
    String? certification,
    String? originalLanguage,
    int? tmdbCollectionId,
    required CollectionStatus status,
    @Default(<String>[]) List<String> genres,
    required DateTime createdAt,
    required DateTime updatedAt,
    DateTime? lastMetadataSyncAt,
  }) = _Movie;
}
