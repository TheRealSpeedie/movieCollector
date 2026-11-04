import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:speednema/core/providers/shared_preferences_provider.dart';
import 'package:speednema/features/collection/presentation/collection_screen.dart';
import 'package:speednema/features/movies/application/movie_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  Future<GoRouter> pumpEmptyCollection(WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CollectionScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const Scaffold(body: Text('Suche')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          allMoviesProvider.overrideWith((ref) => Stream.value(const [])),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('shows the empty-collection state when no movies are saved', (
    tester,
  ) async {
    await pumpEmptyCollection(tester);

    expect(find.text('Deine Sammlung ist noch leer'), findsOneWidget);
    expect(find.text('Ersten Film hinzufügen'), findsOneWidget);
  });

  testWidgets('the empty-state action offers every way to add, including search', (
    tester,
  ) async {
    await pumpEmptyCollection(tester);

    await tester.tap(find.text('Ersten Film hinzufügen'));
    await tester.pumpAndSettle();
    expect(find.text('Barcode scannen'), findsOneWidget);

    await tester.tap(find.text('Titel suchen'));
    await tester.pumpAndSettle();
    expect(find.text('Suche'), findsOneWidget);
  });
}
