import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/core/config/config_providers.dart';
import 'package:speednema/core/network/network_info.dart';
import 'package:speednema/core/providers/core_providers.dart';
import 'package:speednema/core/providers/shared_preferences_provider.dart';
import 'package:speednema/features/search/presentation/movie_search_screen.dart';
import 'package:speednema/features/settings/presentation/metadata_settings_screen.dart';

/// No test may reach the real TMDB.
class _Offline implements NetworkInfo {
  @override
  Future<bool> get isConnected async => false;
}

class _MemoryTokenStore implements TmdbTokenStore {
  String? value;

  @override
  Future<String?> read() async => value;

  @override
  Future<void> write(String? token) async =>
      value = token?.trim().isEmpty ?? true ? null : token!.trim();
}

void main() {
  late _MemoryTokenStore store;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    store = _MemoryTokenStore();
  });

  Future<GoRouter> pump(WidgetTester tester, String start) async {
    final prefs = await SharedPreferences.getInstance();
    final router = GoRouter(
      initialLocation: start,
      routes: [
        GoRoute(path: '/search', builder: (_, _) => const MovieSearchScreen()),
        GoRoute(
          path: '/settings/metadata',
          builder: (_, _) => const MetadataSettingsScreen(),
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sharedPreferencesProvider.overrideWithValue(prefs),
          tmdbTokenStoreProvider.overrideWithValue(store),
          networkInfoProvider.overrideWithValue(_Offline()),
        ],
        child: MaterialApp.router(theme: AppTheme.light, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    return router;
  }

  testWidgets('search without TMDB explains it and leads to setup', (
    tester,
  ) async {
    await pump(tester, '/search');

    expect(find.text('Filminfos sind noch nicht eingerichtet'), findsOneWidget);
    expect(find.text('Filmtitel suchen'), findsNothing);
    expect(find.text('Keine Treffer'), findsNothing);

    await tester.tap(find.text('Filminfos einrichten'));
    await tester.pumpAndSettle();
    expect(find.text('Filminfos'), findsOneWidget);
  });

  testWidgets('Filminfos without a key shows the state and offers an own key', (
    tester,
  ) async {
    await pump(tester, '/settings/metadata');

    expect(find.text('Nicht eingerichtet'), findsOneWidget);
    expect(find.text('Keiner'), findsOneWidget);
    expect(find.text('API-Lesezugriffstoken'), findsOneWidget);
  });

  testWidgets('saving an own key stores it and switches the source', (
    tester,
  ) async {
    await pump(tester, '/settings/metadata');

    await tester.enterText(find.byType(TextField), '  my-token  ');
    await tester.tap(find.text('Speichern'));
    // The check runs offline here; only the stored key and source matter.
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));

    expect(store.value, 'my-token');
    expect(find.text('Eigener Schlüssel'), findsWidgets);
    expect(find.text('Eigenen Schlüssel entfernen'), findsOneWidget);
  });
}
