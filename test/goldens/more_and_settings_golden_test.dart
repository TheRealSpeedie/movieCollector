import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speednema/core/providers/shared_preferences_provider.dart';
import 'package:speednema/features/collections/application/collections_providers.dart';
import 'package:speednema/features/movies/application/movie_providers.dart';
import 'package:speednema/features/server/application/server_providers.dart';
import 'package:speednema/features/settings/presentation/more_screen.dart';
import 'package:speednema/features/settings/presentation/settings_screen.dart';
import 'package:speednema/features/sync/application/sync_providers.dart';

import '../features/server/support/fakes.dart';
import '../fixtures/movie_fixtures.dart';
import '../support/golden_harness.dart';

/// Mehr as a hub (connections, library, settings) and Einstellungen with
/// only real settings, for review in both appearances.
void main() {
  late SharedPreferences prefs;

  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    prefs = await SharedPreferences.getInstance();
  });

  List<Override> base() => [
    sharedPreferencesProvider.overrideWithValue(prefs),
    allMoviesProvider.overrideWith((ref) => Stream.value([ownedMovieFixture()])),
    allCollectionsProvider.overrideWith((ref) => Stream.value([])),
    syncConflictsProvider.overrideWith((ref) => Stream.value([])),
    credentialStoreProvider.overrideWithValue(MemoryStore()),
  ];

  screenGoldens('more_hub', () => const MoreScreen(), overrides: base);
  screenGoldens(
    'settings',
    () => const SettingsScreen(),
    overrides: base,
    textScales: const [1.0],
  );
}
