import 'package:freezed_annotation/freezed_annotation.dart';

import 'collection_status.dart';
import 'movie.dart';

part 'collection_with_entries.freezed.dart';

@freezed
abstract class CollectionEntry with _$CollectionEntry {
  const factory CollectionEntry({
    required int tmdbMovieId,
    required String title,
    String? originalTitle,
    String? posterPath,
    DateTime? releaseDate,
    Movie? localMovie,
  }) = _CollectionEntry;
}

@freezed
abstract class CollectionWithEntries with _$CollectionWithEntries {
  const factory CollectionWithEntries({
    required int id,
    int? tmdbCollectionId,
    required String name,
    String? overview,
    String? posterPath,
    String? backdropPath,
    @Default(<CollectionEntry>[]) List<CollectionEntry> entries,
  }) = _CollectionWithEntries;
}

extension CollectionProgressX on CollectionWithEntries {
  int get ownedCount => entries
      .where((e) => e.localMovie?.status == CollectionStatus.owned)
      .length;

  int get totalCount => entries.length;

  int get missingCount => entries.where((e) => e.localMovie == null).length;

  double get progress => totalCount == 0 ? 0 : ownedCount / totalCount;
}
