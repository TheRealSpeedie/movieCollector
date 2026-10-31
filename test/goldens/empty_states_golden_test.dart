import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/core/config/config_providers.dart';
import 'package:speednema/features/collections/application/collections_providers.dart';
import 'package:speednema/features/collections/presentation/missing_movies_screen.dart';
import 'package:speednema/features/discover/presentation/discover_screen.dart';
import 'package:speednema/features/movies/application/movie_providers.dart';
import 'package:speednema/features/tv/application/tv_providers.dart';

import '../fixtures/movie_fixtures.dart';
import '../support/golden_harness.dart';

/// Baselines of the states fixed in Phase 0. They are replaced when the
/// screens are redesigned; until then they show reviewers the honest copy.
void main() {
  screenGoldens(
    'discover_empty_shelf',
    () => const DiscoverScreen(),
    overrides: () => [
      allMoviesProvider.overrideWith((ref) => Stream.value([])),
      allCollectionsProvider.overrideWith((ref) => Stream.value([])),
      allTvSeriesProvider.overrideWith((ref) => Stream.value([])),
      tmdbConfiguredProvider.overrideWithValue(true),
    ],
  );

  screenGoldens(
    'missing_movies_without_tmdb',
    () => const MissingMoviesScreen(),
    overrides: () => [
      allMoviesProvider.overrideWith(
        (ref) => Stream.value([standaloneMovieFixture()]),
      ),
      allCollectionsProvider.overrideWith((ref) => Stream.value([])),
      tmdbConfiguredProvider.overrideWithValue(false),
    ],
  );
}
