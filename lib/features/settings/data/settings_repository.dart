import 'package:shared_preferences/shared_preferences.dart';

enum CollectionViewMode { grid, list }

/// Where the collection is kept. Independent of whether a media server is
/// connected: a server can be used for playback while the collection stays on
/// this device or syncs through Movie Shelf Cloud.
enum CollectionStorage {
  local,
  selfHosted,
  cloud;

  String get label => switch (this) {
    CollectionStorage.local => 'Nur auf diesem Gerät',
    CollectionStorage.selfHosted => 'Eigener Movie Shelf Server',
    CollectionStorage.cloud => 'Movie Shelf Cloud',
  };
}

/// Viewing preferences asked for during onboarding. Every value is optional.
class UserPreferences {
  const UserPreferences({
    this.region = 'DE',
    this.audioLanguage = 'de',
    this.subtitleLanguage,
    this.preferredFormats = const [],
  });

  final String region;
  final String audioLanguage;
  final String? subtitleLanguage;

  /// MediaFormat names, best first.
  final List<String> preferredFormats;

  UserPreferences copyWith({
    String? region,
    String? audioLanguage,
    String? subtitleLanguage,
    bool clearSubtitles = false,
    List<String>? preferredFormats,
  }) => UserPreferences(
    region: region ?? this.region,
    audioLanguage: audioLanguage ?? this.audioLanguage,
    subtitleLanguage: clearSubtitles
        ? null
        : subtitleLanguage ?? this.subtitleLanguage,
    preferredFormats: preferredFormats ?? this.preferredFormats,
  );
}

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _viewModeKey = 'collection_view_mode';
  static const _storageKey = 'collection_storage';
  static const _onboardingKey = 'onboarding_done';
  static const _regionKey = 'pref_region';
  static const _audioKey = 'pref_audio_language';
  static const _subtitleKey = 'pref_subtitle_language';
  static const _formatsKey = 'pref_formats';

  CollectionViewMode getViewMode() {
    return _prefs.getString(_viewModeKey) == 'list'
        ? CollectionViewMode.list
        : CollectionViewMode.grid;
  }

  Future<void> setViewMode(CollectionViewMode mode) =>
      _prefs.setString(_viewModeKey, mode.name);

  /// Devices that synced with a home server before storage modes existed
  /// keep doing so; see [migrateLegacyStorage].
  CollectionStorage getStorage() => CollectionStorage.values.firstWhere(
    (s) => s.name == _prefs.getString(_storageKey),
    orElse: () => CollectionStorage.local,
  );

  Future<void> setStorage(CollectionStorage storage) =>
      _prefs.setString(_storageKey, storage.name);

  bool get hasStorageChoice => _prefs.containsKey(_storageKey);

  bool get onboardingDone => _prefs.getBool(_onboardingKey) ?? false;

  Future<void> setOnboardingDone() => _prefs.setBool(_onboardingKey, true);

  UserPreferences getPreferences() => UserPreferences(
    region: _prefs.getString(_regionKey) ?? 'DE',
    audioLanguage: _prefs.getString(_audioKey) ?? 'de',
    subtitleLanguage: _prefs.getString(_subtitleKey),
    preferredFormats: _prefs.getStringList(_formatsKey) ?? const [],
  );

  Future<void> setPreferences(UserPreferences preferences) async {
    await _prefs.setString(_regionKey, preferences.region);
    await _prefs.setString(_audioKey, preferences.audioLanguage);
    if (preferences.subtitleLanguage == null) {
      await _prefs.remove(_subtitleKey);
    } else {
      await _prefs.setString(_subtitleKey, preferences.subtitleLanguage!);
    }
    await _prefs.setStringList(_formatsKey, preferences.preferredFormats);
  }
}
