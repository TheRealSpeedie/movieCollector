import 'package:freezed_annotation/freezed_annotation.dart';

import 'collection_status.dart';

part 'tv_season.freezed.dart';

@freezed
abstract class TvSeason with _$TvSeason {
  const factory TvSeason({
    required int id,
    required int seriesId,
    int? tmdbSeasonId,
    required int seasonNumber,
    required String name,
    String? overview,
    String? posterPath,
    DateTime? airDate,
    int? episodeCount,
    CollectionStatus? status,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TvSeason;
}

extension TvSeasonX on TvSeason {
  bool get isSpecials => seasonNumber <= 0;
  bool get isOwned => status == CollectionStatus.owned;
  bool get isMissing => status == null;
}
