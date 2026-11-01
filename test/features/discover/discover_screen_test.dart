import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/core/config/config_providers.dart';
import 'package:speednema/features/collections/application/collections_providers.dart';
import 'package:speednema/features/discover/domain/watch_suggestions.dart';
import 'package:speednema/features/discover/presentation/discover_screen.dart';
import 'package:speednema/features/movies/application/movie_providers.dart';
import 'package:speednema/features/server/application/server_providers.dart';
import 'package:speednema/features/tv/application/tv_providers.dart';
import 'package:speednema/features/watch/application/watch_providers.dart';
import 'package:speednema/shared/models/collection_with_entries.dart';
import 'package:speednema/shared/models/movie.dart';

import '../../fixtures/movie_fixtures.dart';
import '../../support/golden_harness.dart';

/// Overrides that keep Entdecken off the database and network.
List<Override> discoverOverrides({
  Stream<List<Movie>>? movies,
  Stream<List<CollectionWithEntries>>? collections,
  bool tmdb = true,
}) => [
  allMoviesProvider.overrideWith((ref) => movies ?? Stream.value([])),
  allCollectionsProvider.overrideWith((ref) => collections ?? Stream.value([])),
  allTvSeriesProvider.overrideWith((ref) => Stream.value([])),
  watchCandidatesProvider.overrideWith((ref) async => const <WatchCandidate>[]),
  subscriptionsProvider.overrideWith((ref) => Stream.value([])),
  serverClientProvider.overrideWith((ref) => null),
  tmdbConfiguredProvider.overrideWithValue(tmdb),
];

/// "Reihen vervollständigen" tells each situation apart; none of them is
/// a false "complete".
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

  Future<void> pump(WidgetTester tester, List<Override> overrides) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const DiscoverScreen()),
        GoRoute(
          path: '/settings/metadata',
          builder: (_, _) => const Scaffold(body: Text('Filminfos-Seite')),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: overrides,
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    for (var i = 0; i < 5; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  final cases = <String, (List<Override>, String)>{
    'empty shelf': (
      discoverOverrides(),
      'Füge Filme hinzu, um Lücken in Reihen zu sehen',
    ),
    'films without series': (
      discoverOverrides(movies: Stream.value([standaloneMovieFixture()])),
      'Noch keine Reihen in deinem Regal erkannt',
    ),
    'no movie information': (
      discoverOverrides(
        movies: Stream.value([standaloneMovieFixture()]),
        tmdb: false,
      ),
      'Filminfos sind noch nicht eingerichtet',
    ),
    'loading': (
      discoverOverrides(movies: StreamController<List<Movie>>().stream),
      // While loading the section stays quiet rather than guess.
      '',
    ),
    'failed': (
      discoverOverrides(
        movies: Stream.value([collectionMovieFixture()]),
        collections: Stream.error(StateError('db')),
      ),
      'Das hat nicht geklappt',
    ),
    'complete': (
      discoverOverrides(
        movies: Stream.value([collectionMovieFixture()]),
        collections: Stream.value([series(complete: true)]),
      ),
      'Deine Reihe ist vollständig',
    ),
    'missing': (
      discoverOverrides(
        movies: Stream.value([collectionMovieFixture()]),
        collections: Stream.value([series(complete: false)]),
      ),
      'Matrix Reloaded',
    ),
  };

  for (final MapEntry(key: name, value: (overrides, expected)) in cases.entries) {
    testWidgets('Reihen vervollständigen: $name', (tester) async {
      await pump(tester, overrides);
      if (expected.isNotEmpty) {
        expect(find.text(expected), findsOneWidget);
      }
      if (name != 'complete') {
        // The section is called "Reihen vervollständigen"; the false claim
        // to rule out is that something "ist/sind vollständig".
        expect(
          find.textContaining(RegExp(r'(ist|sind) vollständig')),
          findsNothing,
        );
      }
    });
  }

  testWidgets('without subscriptions, Entdecken offers to choose them', (
    tester,
  ) async {
    await pump(tester, discoverOverrides());
    expect(find.text('Abos auswählen'), findsOneWidget);
  });

  screenGoldens(
    'discover',
    () => const DiscoverScreen(),
    overrides: () => discoverOverrides(
      movies: Stream.value([collectionMovieFixture(), wishlistMovieFixture()]),
      collections: Stream.value([series(complete: false)]),
    ),
    textScales: const [1.0],
  );
}
