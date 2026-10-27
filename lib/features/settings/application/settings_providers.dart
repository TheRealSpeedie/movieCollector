import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../data/settings_repository.dart';

final settingsRepositoryProvider = Provider<SettingsRepository>(
  (ref) => SettingsRepository(ref.watch(sharedPreferencesProvider)),
);

class CollectionStorageController extends Notifier<CollectionStorage> {
  @override
  CollectionStorage build() =>
      ref.watch(settingsRepositoryProvider).getStorage();

  /// Only the storage migration and onboarding call this. Switching where the
  /// collection lives is never a side effect of connecting a server.
  Future<void> set(CollectionStorage storage) async {
    await ref.read(settingsRepositoryProvider).setStorage(storage);
    state = storage;
  }
}

final collectionStorageProvider =
    NotifierProvider<CollectionStorageController, CollectionStorage>(
      CollectionStorageController.new,
    );

class UserPreferencesController extends Notifier<UserPreferences> {
  @override
  UserPreferences build() =>
      ref.watch(settingsRepositoryProvider).getPreferences();

  Future<void> save(UserPreferences preferences) async {
    await ref.read(settingsRepositoryProvider).setPreferences(preferences);
    state = preferences;
  }
}

final userPreferencesProvider =
    NotifierProvider<UserPreferencesController, UserPreferences>(
      UserPreferencesController.new,
    );

class OnboardingController extends Notifier<bool> {
  @override
  bool build() => ref.watch(settingsRepositoryProvider).onboardingDone;

  Future<void> complete() async {
    await ref.read(settingsRepositoryProvider).setOnboardingDone();
    state = true;
  }
}

final onboardingDoneProvider = NotifierProvider<OnboardingController, bool>(
  OnboardingController.new,
);
