import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/core/providers/shared_preferences_provider.dart';
import 'package:speednema/features/collection/presentation/collection_screen.dart';
import 'package:speednema/features/movies/application/movie_providers.dart';
import 'package:speednema/features/server/application/server_providers.dart';
import 'package:speednema/shared/models/collection_status.dart';

import '../../fixtures/movie_fixtures.dart';
import '../../support/golden_harness.dart';

final _movies = [
  buildMovie(id: 1, tmdbId: 1, title: 'Arrival', genres: ['Science-Fiction'], releaseYear: 2016),
  buildMovie(id: 2, tmdbId: 2, title: 'Die Brücke', genres: ['Drama'], releaseYear: 1959, status: CollectionStatus.wishlist),
  buildMovie(id: 3, tmdbId: 3, title: 'Dune', genres: ['Science-Fiction'], releaseYear: 2021, status: CollectionStatus.open),
];

List<Override> collectionOverrides(SharedPreferences prefs) => [
  sharedPreferencesProvider.overrideWithValue(prefs),
  allMoviesProvider.overrideWith((ref) => Stream.value(_movies)),
  serverClientProvider.overrideWith((ref) => null),
];

void main() {
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  testWidgets('the filter sheet narrows by genre and marks active filters', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: collectionOverrides(prefs),
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: GoRouter(
            routes: [
              GoRoute(path: '/', builder: (_, _) => const CollectionScreen()),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Die Brücke'), findsOneWidget);

    await tester.tap(find.byTooltip('Filter & Ansicht'));
    await tester.pumpAndSettle();
    // Only genres that exist in the collection are offered.
    expect(find.widgetWithText(FilterChip, 'Drama'), findsOneWidget);
    expect(find.widgetWithText(FilterChip, 'Western'), findsNothing);

    await tester.tap(find.widgetWithText(FilterChip, 'Science-Fiction'));
    await tester.pumpAndSettle();
    Navigator.of(tester.element(find.text('Filter & Ansicht'))).pop();
    await tester.pumpAndSettle();

    expect(find.text('Arrival'), findsOneWidget);
    expect(find.text('Dune'), findsOneWidget);
    expect(find.text('Die Brücke'), findsNothing);
    final badge = tester.widget<Badge>(find.byType(Badge));
    expect(badge.isLabelVisible, isTrue);
  });

  group('goldens', () {
    late SharedPreferences goldenPrefs;
    setUpAll(() async {
      SharedPreferences.setMockInitialValues({});
      goldenPrefs = await SharedPreferences.getInstance();
    });
    screenGoldens(
      'collection_grid',
      () => const CollectionScreen(),
      overrides: () => collectionOverrides(goldenPrefs),
    );
  });
}
