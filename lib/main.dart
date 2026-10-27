import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:media_kit/media_kit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app/app.dart';
import 'core/providers/shared_preferences_provider.dart';
import 'features/onboarding/application/onboarding_gate.dart';
import 'features/playback/application/playback_hooks.dart';
import 'features/settings/application/settings_providers.dart';
import 'features/settings/data/settings_repository.dart';
import 'features/watch/application/watch_providers.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  onboardingGate.value = SettingsRepository(prefs).onboardingDone;

  runApp(
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(prefs),
        playbackPreferencesProvider.overrideWith(
          (ref) => ref.watch(userPreferencesProvider).toServerJson(),
        ),
        viewingRecorderProvider.overrideWith(phoneViewingRecorder),
      ],
      child: const MovieShelfApp(),
    ),
  );
}
