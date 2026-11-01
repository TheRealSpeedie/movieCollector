import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/core/database/app_database.dart';
import 'package:speednema/core/providers/core_providers.dart';
import 'package:speednema/core/providers/shared_preferences_provider.dart';
import 'package:speednema/features/cloud/application/cloud_providers.dart';
import 'package:speednema/features/onboarding/presentation/onboarding_screen.dart';
import 'package:speednema/features/server/application/server_providers.dart';

import '../../support/golden_harness.dart';
import '../server/support/fakes.dart';

/// First run: short, skippable, the server only when chosen, and never for
/// installs that already have a collection.
void main() {
  late AppDatabase db;
  late SharedPreferences prefs;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
    db = AppDatabase(NativeDatabase.memory());
  });

  tearDown(() => db.close());

  Future<void> pump(WidgetTester tester, {bool cloud = false}) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          sharedPreferencesProvider.overrideWithValue(prefs),
          credentialStoreProvider.overrideWithValue(MemoryStore()),
          cloudAvailableProvider.overrideWithValue(cloud),
        ],
        child: MaterialApp.router(
          theme: AppTheme.dark,
          routerConfig: GoRouter(
            initialLocation: '/onboarding',
            routes: [
              GoRoute(
                path: '/onboarding',
                builder: (_, _) => const OnboardingScreen(),
              ),
              GoRoute(
                path: '/home',
                builder: (_, _) => const Scaffold(body: Text('Home-Seite')),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> close(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pump(const Duration(milliseconds: 1));
  }

  testWidgets('a new install starts with a welcome, three steps in all', (
    tester,
  ) async {
    await pump(tester);
    expect(find.text('Deine Filme. Alles an einem Ort.'), findsOneWidget);
    expect(find.bySemanticsLabel('Schritt 1 von 3'), findsOneWidget);
    await close(tester);
  });

  testWidgets('choosing an own server adds the server step', (tester) async {
    await pump(tester);
    await tester.ensureVisible(find.text("Los geht's"));
    await tester.tap(find.text("Los geht's"));
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.text('Eigener Speednema Server'));
    await tester.tap(find.text('Eigener Speednema Server'));
    await tester.pumpAndSettle();
    expect(find.bySemanticsLabel('Schritt 2 von 4'), findsOneWidget);

    await tester.ensureVisible(find.text('Weiter'));
    await tester.tap(find.text('Weiter'));
    await tester.pumpAndSettle();
    expect(find.text('Deinen Server verbinden'), findsOneWidget);
    await close(tester);
  });

  testWidgets('Cloud is not offered where this version has none', (
    tester,
  ) async {
    await pump(tester);
    await tester.ensureVisible(find.text("Los geht's"));
    await tester.tap(find.text("Los geht's"));
    await tester.pumpAndSettle();
    expect(find.text('Speednema Cloud'), findsNothing);
    expect(find.text('Nur auf diesem Gerät'), findsOneWidget);
    await close(tester);
  });

  testWidgets('every step can be skipped', (tester) async {
    await pump(tester);
    await tester.tap(find.text('Überspringen'));
    await tester.pumpAndSettle();
    expect(find.text('Home-Seite'), findsOneWidget);
    await close(tester);
  });

  testWidgets('an existing collection skips onboarding', (tester) async {
    await db.into(db.movies).insert(
      MoviesCompanion.insert(title: 'Arrival', tmdbId: const Value(1)),
    );
    await pump(tester);
    expect(find.text('Home-Seite'), findsOneWidget);
    await close(tester);
  });

  for (final appearance in Brightness.values) {
    testWidgets('welcome golden, ${appearance.name}', (tester) async {
      final loaded = await tester.runAsync(loadAppFonts) ?? false;
      if (!loaded) return markTestSkipped('SDK fonts not found');
      tester.view
        ..physicalSize = GoldenDevice.phone.size
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            sharedPreferencesProvider.overrideWithValue(prefs),
            credentialStoreProvider.overrideWithValue(MemoryStore()),
            cloudAvailableProvider.overrideWithValue(false),
          ],
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            theme: appearance == Brightness.dark ? AppTheme.dark : AppTheme.light,
            routerConfig: GoRouter(
              initialLocation: '/onboarding',
              routes: [
                GoRoute(
                  path: '/onboarding',
                  builder: (_, _) => const OnboardingScreen(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      await expectLater(
        find.byType(MaterialApp),
        matchesGoldenFile('goldens/welcome_${appearance.name}_phone.png'),
      );
      await close(tester);
    }, tags: ['golden']);
  }
}
