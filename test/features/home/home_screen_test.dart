import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/core/config/config_providers.dart';
import 'package:speednema/core/providers/shared_preferences_provider.dart';
import 'package:speednema/features/collections/application/collections_providers.dart';
import 'package:speednema/features/discover/domain/watch_suggestions.dart';
import 'package:speednema/features/home/presentation/home_screen.dart';
import 'package:speednema/features/movies/application/movie_providers.dart';
import 'package:speednema/features/server/application/server_connection.dart';
import 'package:speednema/features/server/application/server_providers.dart';
import 'package:speednema/features/sync/application/sync_providers.dart';
import 'package:speednema/features/watch/application/watch_providers.dart';
import 'package:speednema/shared/models/movie.dart';

import '../../fixtures/movie_fixtures.dart';
import '../../support/golden_harness.dart';
import '../server/support/fakes.dart';

/// Home follows the person's state: welcome when empty, content when not,
/// problems as notes above the content.
List<Override> homeOverrides(
  SharedPreferences prefs, {
  List<Movie> movies = const [],
  bool tmdb = true,
  bool paired = false,
}) => [
  sharedPreferencesProvider.overrideWithValue(prefs),
  allMoviesProvider.overrideWith((ref) => Stream.value(movies)),
  allCollectionsProvider.overrideWith((ref) => Stream.value([])),
  syncConflictsProvider.overrideWith((ref) => Stream.value([])),
  credentialStoreProvider.overrideWithValue(
    MemoryStore(paired ? sampleCredentials() : null),
  ),
  watchCandidatesProvider.overrideWith((ref) async => const <WatchCandidate>[]),
  collectionInsightsProvider.overrideWith(
    (ref) => const AsyncData(CollectionInsights()),
  ),
  wishlistOfferWatcherProvider.overrideWith((ref) {}),
  if (tmdb) tmdbUserTokenProvider.overrideWith((ref) => 'token'),
  // No test reaches a real server; reachability is set by the test.
  serverClientProvider.overrideWith((ref) => null),
];

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  Future<ProviderContainer> pump(
    WidgetTester tester,
    List<Override> overrides,
  ) async {
    final container = ProviderContainer(overrides: overrides);
    addTearDown(container.dispose);
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const HomeScreen()),
        GoRoute(
          path: '/settings/metadata',
          builder: (_, _) => const Scaffold(body: Text('Filminfos-Seite')),
        ),
      ],
    );
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return container;
  }

  testWidgets('an empty shelf is a welcome, not a dashboard of zeros', (
    tester,
  ) async {
    await pump(tester, homeOverrides(prefs));

    expect(find.text('Dein Regal ist noch leer.'), findsOneWidget);
    expect(find.text('0'), findsNothing);
    expect(find.text('Deine Sammlung'), findsNothing);

    await tester.tap(find.text('Ersten Film hinzufügen'));
    await tester.pumpAndSettle();
    expect(find.text('Barcode scannen'), findsOneWidget);
    expect(find.text('Liste importieren'), findsOneWidget);
  });

  testWidgets(
    'without TMDB the welcome says so once, and remembers a dismissal',
    (tester) async {
      await pump(tester, homeOverrides(prefs, tmdb: false));
      expect(
        find.text('Filminfos sind noch nicht eingerichtet'),
        findsOneWidget,
      );

      await tester.tap(find.byTooltip('Ausblenden'));
      await tester.pumpAndSettle();
      expect(find.text('Filminfos sind noch nicht eingerichtet'), findsNothing);

      // A fresh start of the screen keeps it hidden.
      await pump(tester, homeOverrides(prefs, tmdb: false));
      expect(find.text('Filminfos sind noch nicht eingerichtet'), findsNothing);
    },
  );

  testWidgets('with films, Home shows them and a one-line summary', (
    tester,
  ) async {
    await pump(
      tester,
      homeOverrides(
        prefs,
        movies: [ownedMovieFixture(), wishlistMovieFixture()],
      ),
    );
    expect(find.text('Dein Regal ist noch leer.'), findsNothing);
    expect(find.text('2 Filme · 1 auf der Wunschliste'), findsOneWidget);
    expect(find.text('Zuletzt hinzugefügt'), findsOneWidget);
    // Sections without content stay away.
    expect(find.text('Weiterschauen'), findsNothing);
    expect(find.text('Reihen vervollständigen'), findsNothing);
  });

  testWidgets('a server that cannot be reached is a note; the shelf stays', (
    tester,
  ) async {
    final container = await pump(
      tester,
      homeOverrides(prefs, movies: [ownedMovieFixture()], paired: true),
    );
    container.read(serverReachabilityProvider.notifier).report(false);
    await tester.pumpAndSettle();

    expect(find.text('Server nicht erreichbar'), findsOneWidget);
    expect(find.text('Zuletzt hinzugefügt'), findsOneWidget);
  });

  group('goldens', () {
    late SharedPreferences goldenPrefs;
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      goldenPrefs = await SharedPreferences.getInstance();
    });
    screenGoldens(
      'home_empty',
      () => const HomeScreen(),
      overrides: () => homeOverrides(goldenPrefs, tmdb: false),
    );
    screenGoldens(
      'home_populated',
      () => const HomeScreen(),
      overrides: () => homeOverrides(
        goldenPrefs,
        movies: [
          ownedMovieFixture(),
          wishlistMovieFixture(),
          openMovieFixture(),
        ],
      ),
      textScales: const [1.0],
    );
  });
}
