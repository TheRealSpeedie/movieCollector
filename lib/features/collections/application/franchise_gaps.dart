import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/config_providers.dart';
import '../../movies/application/movie_providers.dart';
import 'collections_providers.dart';

/// What Speednema knows about missing parts of the user's film series.
///
/// "All complete" is only claimed when series are actually known. An empty
/// shelf, series that were never looked up, or a failed load are different
/// situations and say so.
sealed class FranchiseGaps {
  const FranchiseGaps();
}

class FranchiseGapsLoading extends FranchiseGaps {
  const FranchiseGapsLoading();
}

class FranchiseGapsFailed extends FranchiseGaps {
  const FranchiseGapsFailed(this.error);

  final Object error;
}

/// No films on the shelf yet, so there is nothing to compare.
class FranchiseGapsNoMovies extends FranchiseGaps {
  const FranchiseGapsNoMovies();
}

/// Films exist but no series is known, and without movie information none
/// can be found.
class FranchiseGapsNotConfigured extends FranchiseGaps {
  const FranchiseGapsNotConfigured();
}

/// Films exist, but none of them belongs to a known series.
class FranchiseGapsNoSeries extends FranchiseGaps {
  const FranchiseGapsNoSeries();
}

class FranchiseGapsComplete extends FranchiseGaps {
  const FranchiseGapsComplete(this.seriesCount);

  final int seriesCount;
}

class FranchiseGapsMissing extends FranchiseGaps {
  const FranchiseGapsMissing({
    required this.movieCount,
    required this.seriesCount,
  });

  /// Films missing across all series.
  final int movieCount;

  /// Series with at least one missing film.
  final int seriesCount;
}

final franchiseGapsProvider = Provider<FranchiseGaps>((ref) {
  final movies = ref.watch(allMoviesProvider);
  final collections = ref.watch(allCollectionsProvider);
  final groups = ref.watch(missingMoviesProvider);
  final tmdbConfigured = ref.watch(tmdbConfiguredProvider);

  for (final value in [movies, collections, groups]) {
    if (value.hasError) return FranchiseGapsFailed(value.error!);
  }
  if (!movies.hasValue || !collections.hasValue || !groups.hasValue) {
    return const FranchiseGapsLoading();
  }
  final seriesCount = collections.requireValue.length;
  if (seriesCount == 0) {
    if (movies.requireValue.isEmpty) return const FranchiseGapsNoMovies();
    return tmdbConfigured
        ? const FranchiseGapsNoSeries()
        : const FranchiseGapsNotConfigured();
  }
  final missing = groups.requireValue;
  if (missing.isEmpty) return FranchiseGapsComplete(seriesCount);
  return FranchiseGapsMissing(
    movieCount: missing.fold(0, (sum, g) => sum + g.missingEntries.length),
    seriesCount: missing.length,
  );
});

/// One line for a list row, e.g. in Entdecken and Mehr.
String franchiseGapsSummary(FranchiseGaps gaps) => switch (gaps) {
  FranchiseGapsLoading() => 'Wird geladen …',
  FranchiseGapsFailed() => 'Konnte gerade nicht geladen werden',
  FranchiseGapsNoMovies() => 'Füge Filme hinzu, um Lücken in Reihen zu sehen',
  FranchiseGapsNotConfigured() =>
    'Filminfos sind nicht eingerichtet, Reihen werden nicht erkannt',
  FranchiseGapsNoSeries() => 'Noch keine Reihen in deinem Regal erkannt',
  FranchiseGapsComplete(seriesCount: 1) => 'Deine Reihe ist vollständig',
  FranchiseGapsComplete(:final seriesCount) =>
    'Alle $seriesCount Reihen sind vollständig',
  FranchiseGapsMissing(movieCount: 1) => 'Ein Film fehlt in deinen Reihen',
  FranchiseGapsMissing(:final movieCount) =>
    '$movieCount Filme fehlen in deinen Reihen',
};
