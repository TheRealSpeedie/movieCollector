import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/core/collection/ownership_service.dart';
import 'package:speednema/core/database/app_database.dart';
import 'package:speednema/core/network/network_info.dart';
import 'package:speednema/core/providers/core_providers.dart';
import 'package:speednema/core/providers/shared_preferences_provider.dart';
import 'package:speednema/features/movie_details/presentation/movie_details_screen.dart';
import 'package:speednema/features/server/application/server_providers.dart';
import 'package:speednema/shared/models/collection_status.dart';

import '../../support/golden_harness.dart';

class _Offline implements NetworkInfo {
  @override
  Future<bool> get isConnected async => false;
}

/// The details page against a real in-memory database: hero, facts, the
/// status control, and technical details folded away.
void main() {
  late AppDatabase db;
  late int movieId;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
    movieId = await db.into(db.movies).insert(
      MoviesCompanion.insert(
        title: 'Arrival',
        tmdbId: const Value(329865),
        releaseYear: const Value(2016),
        runtime: const Value(116),
        certification: const Value('12'),
        overview: const Value(
          'Als zwölf außerirdische Raumschiffe auf der Erde landen, soll die '
          'Linguistin Louise Banks herausfinden, ob die Besucher in friedlicher '
          'Absicht gekommen sind.',
        ),
      ),
    );
    await OwnershipService(db).setMovieStatus(movieId, CollectionStatus.owned);
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester, {Brightness appearance = Brightness.dark}) async {
    mockPathProvider();
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
          networkInfoProvider.overrideWithValue(_Offline()),
          serverClientProvider.overrideWith((ref) => null),
        ],
        child: MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: appearance == Brightness.dark ? AppTheme.dark : AppTheme.light,
          routerConfig: GoRouter(
            routes: [
              GoRoute(
                path: '/',
                builder: (_, _) => MovieDetailsScreen(movieId: movieId),
              ),
            ],
          ),
        ),
      ),
    );
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('facts on one line, status control, delete only in the menu', (
    tester,
  ) async {
    await pump(tester);
    // The hero title is the page's heading.
    expect(
      find.ancestor(
        of: find.text('Arrival'),
        matching: find.byWidgetPredicate(
          (w) => w is Semantics && (w.properties.header ?? false),
        ),
      ),
      findsWidgets,
    );
    expect(find.text('2016 · 116 Min. · FSK 12'), findsOneWidget);
    expect(find.text('In meiner Sammlung als'), findsOneWidget);
    // Removing is not a one-tap icon on the page.
    expect(find.byTooltip('Aus Sammlung entfernen'), findsNothing);
    await tester.tap(find.byTooltip('Weitere Aktionen'));
    await tester.pump(const Duration(milliseconds: 300));
    expect(find.text('Aus Sammlung entfernen'), findsOneWidget);
    await close(tester);
  });

  for (final appearance in Brightness.values) {
    testWidgets('details golden, ${appearance.name}', (tester) async {
      final loaded = await tester.runAsync(loadAppFonts) ?? false;
      if (!loaded) return markTestSkipped('SDK fonts not found');
      tester.view
        ..physicalSize = GoldenDevice.phone.size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pump(tester, appearance: appearance);
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/details_${appearance.name}_phone.png'),
      );
      await close(tester);
    }, tags: ['golden']);
  }
}
