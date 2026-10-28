import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_shelf/core/providers/shared_preferences_provider.dart';
import 'package:movie_shelf/features/cloud/application/cloud_providers.dart';
import 'package:movie_shelf/features/cloud/data/cloud_client.dart';
import 'package:movie_shelf/features/cloud/presentation/cloud_account_screen.dart';
import 'package:movie_shelf/features/collection/presentation/collection_screen.dart';
import 'package:movie_shelf/features/household/application/household_providers.dart';
import 'package:movie_shelf/features/household/data/household_api.dart';
import 'package:movie_shelf/features/household/presentation/household_screen.dart';
import 'package:movie_shelf/features/movies/application/movie_providers.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:movie_shelf/shared/models/movie.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../features/cloud/cloud_client_test.dart' show MemoryCloudStore;

/// Screens must stay usable with the largest common system text size on a
/// small phone: no overflow, everything reachable by scrolling.
void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pump(
    WidgetTester tester,
    Widget screen,
    List<Override> overrides,
  ) async {
    tester.view.physicalSize = const Size(360, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final prefs = await SharedPreferences.getInstance();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          ...overrides,
        ],
        child: MaterialApp.router(
          routerConfig: GoRouter(
            routes: [GoRoute(path: '/', builder: (_, _) => screen)],
          ),
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: const TextScaler.linear(2)),
            child: child!,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  final now = DateTime(2026, 10, 28);

  testWidgets('the collection grid', (tester) async {
    await pump(tester, const CollectionScreen(), [
      allMoviesProvider.overrideWith(
        (ref) => Stream.value([
          for (var i = 0; i < 6; i++)
            Movie(
              id: i,
              title: 'Der Herr der Ringe: Die Rückkehr des Königs $i',
              releaseYear: 2003,
              status: CollectionStatus.values[i % 3],
              createdAt: now,
              updatedAt: now,
            ),
        ]),
      ),
    ]);
    expect(tester.takeException(), isNull);
    expect(
      find.bySemanticsLabel(RegExp(r'^Der Herr der Ringe.*, 2003, ')),
      findsWidgets,
    );
  });

  testWidgets('the household screen', (tester) async {
    await pump(tester, const HouseholdScreen(), [
      householdApiProvider.overrideWithValue(
        HouseholdApi(
          get: (_) async => {},
          post: (_, _) async => {},
          delete: (_) async => {},
        ),
      ),
      householdProvider.overrideWith(
        (ref) async => const Household(
          isOwner: true,
          members: [
            HouseholdMember(id: 1, name: 'anna', owner: true, you: true),
            HouseholdMember(
              id: 2,
              name: 'benjamin.mustermann@example.org',
              owner: false,
              you: false,
            ),
          ],
        ),
      ),
    ]);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(find.text('Jemanden einladen'), 100);
    expect(
      find.byTooltip('benjamin.mustermann@example.org entfernen'),
      findsOneWidget,
    );
  });

  testWidgets('cloud sign-in', (tester) async {
    final store = MemoryCloudStore();
    await pump(tester, const CloudAccountScreen(), [
      cloudAvailableProvider.overrideWithValue(true),
      cloudSessionStoreProvider.overrideWithValue(store),
      cloudClientProvider.overrideWithValue(
        CloudClient(baseUrl: 'https://cloud.test', store: store),
      ),
    ]);
    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('Passwort vergessen?'),
      100,
      scrollable: find.byType(Scrollable).first,
    );
  });
}
