import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../shared/models/collection_status.dart';
import '../../../shared/models/tv_season.dart';
import '../../../shared/models/tv_series_with_seasons.dart';
import '../../tv/application/tv_providers.dart';

/// A series where the user owns some regular seasons but not all aired ones.
class SeasonGap {
  const SeasonGap({required this.entry, required this.missing});

  final TvSeriesWithSeasons entry;
  final List<TvSeason> missing;

  List<int> get ownedNumbers => [
    for (final s in entry.regularSeasons)
      if (s.status == CollectionStatus.owned) s.seasonNumber,
  ];

  /// "Du hast Staffel 1, 2 und 4. Es fehlt Staffel 3."
  String get message {
    String list(List<int> numbers) => numbers.length == 1
        ? '${numbers.single}'
        : '${numbers.take(numbers.length - 1).join(', ')} und ${numbers.last}';
    final missingNumbers = [for (final s in missing) s.seasonNumber];
    return 'Du hast Staffel ${list(ownedNumbers)}. '
        'Es fehl${missingNumbers.length == 1 ? 't' : 'en'} '
        'Staffel ${list(missingNumbers)}.';
  }
}

final seasonGapsProvider = Provider<AsyncValue<List<SeasonGap>>>((ref) {
  final now = DateTime.now();
  return ref.watch(allTvSeriesProvider).whenData((all) {
    final gaps = <SeasonGap>[];
    for (final entry in all) {
      final regular = entry.regularSeasons;
      if (!regular.any((s) => s.status == CollectionStatus.owned)) continue;
      final missing = [
        for (final s in regular)
          if (s.status != CollectionStatus.owned &&
              (s.airDate == null || s.airDate!.isBefore(now)))
            s,
      ];
      if (missing.isNotEmpty) {
        gaps.add(SeasonGap(entry: entry, missing: missing));
      }
    }
    return gaps;
  });
});
