import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/core/config/config_providers.dart';
import 'package:speednema/features/collections/application/collections_providers.dart';
import 'package:speednema/features/collections/application/franchise_gaps.dart';
import 'package:speednema/features/movies/application/movie_providers.dart';
import 'package:speednema/shared/models/collection_with_entries.dart';
import 'package:speednema/shared/models/movie.dart';

import '../../fixtures/movie_fixtures.dart';

/// "Deine Reihen sind vollständig" used to appear with an empty shelf, while
/// loading, after an error and without TMDB. Each case now says what it is.
void main() {
  CollectionWithEntries series({required bool complete}) {
    final owned = collectionMovieFixture();
    return CollectionWithEntries(
      id: 1,
      name: 'Matrix',
      entries: [
        CollectionEntry(tmdbMovieId: 603, title: 'Matrix', localMovie: owned),
        CollectionEntry(
          tmdbMovieId: 604,
          title: 'Matrix Reloaded',
          localMovie: complete ? owned : null,
        ),
      ],
    );
  }

  Future<FranchiseGaps> gapsFor({
    Stream<List<Movie>>? movies,
    Stream<List<CollectionWithEntries>>? collections,
    bool tmdb = true,
  }) async {
    final container = ProviderContainer(
      overrides: [
        allMoviesProvider.overrideWith((ref) => movies ?? Stream.value([])),
        allCollectionsProvider.overrideWith(
          (ref) => collections ?? Stream.value([]),
        ),
        tmdbConfiguredProvider.overrideWithValue(tmdb),
      ],
    );
    addTearDown(container.dispose);
    container.listen(franchiseGapsProvider, (_, _) {});
    await Future<void>.delayed(Duration.zero);
    return container.read(franchiseGapsProvider);
  }

  test('an empty shelf is not "complete"', () async {
    final gaps = await gapsFor();
    expect(gaps, isA<FranchiseGapsNoMovies>());
    expect(franchiseGapsSummary(gaps), isNot(contains('vollständig')));
  });

  test('films without any known series say so', () async {
    final gaps = await gapsFor(
      movies: Stream.value([standaloneMovieFixture()]),
    );
    expect(gaps, isA<FranchiseGapsNoSeries>());
    expect(franchiseGapsSummary(gaps), isNot(contains('vollständig')));
  });

  test('without TMDB, missing series are blamed on the setup', () async {
    final gaps = await gapsFor(
      movies: Stream.value([standaloneMovieFixture()]),
      tmdb: false,
    );
    expect(gaps, isA<FranchiseGapsNotConfigured>());
    expect(franchiseGapsSummary(gaps), contains('Filminfos'));
  });

  test('while loading nothing is claimed', () async {
    final gaps = await gapsFor(movies: StreamController<List<Movie>>().stream);
    expect(gaps, isA<FranchiseGapsLoading>());
  });

  test('a failed load is reported as failed', () async {
    final gaps = await gapsFor(
      collections: Stream.error(StateError('db closed')),
      movies: Stream.value([collectionMovieFixture()]),
    );
    expect(gaps, isA<FranchiseGapsFailed>());
    expect(franchiseGapsSummary(gaps), isNot(contains('vollständig')));
  });

  test(
    '"complete" only when series are known and nothing is missing',
    () async {
      final gaps = await gapsFor(
        movies: Stream.value([collectionMovieFixture()]),
        collections: Stream.value([series(complete: true)]),
      );
      expect(gaps, isA<FranchiseGapsComplete>());
      expect(franchiseGapsSummary(gaps), 'Deine Reihe ist vollständig');
    },
  );

  test('missing films are counted', () async {
    final gaps = await gapsFor(
      movies: Stream.value([collectionMovieFixture()]),
      collections: Stream.value([series(complete: false)]),
    );
    expect(gaps, isA<FranchiseGapsMissing>());
    expect(franchiseGapsSummary(gaps), 'Ein Film fehlt in deinen Reihen');
  });

  // The screen-level checks for every state live in
  // test/features/discover/discover_screen_test.dart.
}
