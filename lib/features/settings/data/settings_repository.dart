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

/// When subtitles are shown during playback.
enum SubtitleMode {
  /// When the audio is not a language you understand, plus forced subtitles.
  auto,
  always,
  off;

  String get label => switch (this) {
    SubtitleMode.auto => 'Wenn nötig',
    SubtitleMode.always => 'Immer',
    SubtitleMode.off => 'Nie',
  };
}

/// Viewing preferences asked for during onboarding. Every value is optional.
class UserPreferences {
  const UserPreferences({
    this.region = 'DE',
    this.audioLanguage = 'de',
    this.secondaryAudioLanguage = 'en',
    this.subtitleLanguage,
    this.subtitleMode = SubtitleMode.auto,
    this.preferOriginal = false,
    this.hearingImpaired = false,
    this.preferredFormats = const [],
  });

  final String region;
  final String audioLanguage;

  /// Understood as well; used when the first language is missing.
  final String? secondaryAudioLanguage;
  final String? subtitleLanguage;
  final SubtitleMode subtitleMode;

  /// Play the original language when the file has it, with subtitles.
  final bool preferOriginal;
  final bool hearingImpaired;

  /// MediaFormat names, best first.
  final List<String> preferredFormats;

  UserPreferences copyWith({
    String? region,
    String? audioLanguage,
    String? secondaryAudioLanguage,
    bool clearSecondary = false,
    String? subtitleLanguage,
    bool clearSubtitles = false,
    SubtitleMode? subtitleMode,
    bool? preferOriginal,
    bool? hearingImpaired,
    List<String>? preferredFormats,
  }) => UserPreferences(
    region: region ?? this.region,
    audioLanguage: audioLanguage ?? this.audioLanguage,
    secondaryAudioLanguage: clearSecondary
        ? null
        : secondaryAudioLanguage ?? this.secondaryAudioLanguage,
    subtitleLanguage: clearSubtitles
        ? null
        : subtitleLanguage ?? this.subtitleLanguage,
    subtitleMode: subtitleMode ?? this.subtitleMode,
    preferOriginal: preferOriginal ?? this.preferOriginal,
    hearingImpaired: hearingImpaired ?? this.hearingImpaired,
    preferredFormats: preferredFormats ?? this.preferredFormats,
  );

  /// The shape of the server's TrackPreferences.
  Map<String, Object?> toServerJson() => {
    'audioLanguages': [
      audioLanguage,
      if (secondaryAudioLanguage != null &&
          secondaryAudioLanguage != audioLanguage)
        secondaryAudioLanguage,
    ],
    'subtitleLanguage': subtitleLanguage ?? audioLanguage,
    'subtitleMode': switch (subtitleMode) {
      SubtitleMode.auto => 'Auto',
      SubtitleMode.always => 'Always',
      SubtitleMode.off => 'Off',
    },
    'preferOriginal': preferOriginal,
    'hearingImpaired': hearingImpaired,
  };
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
  static const _secondaryAudioKey = 'pref_secondary_audio';
  static const _subtitleModeKey = 'pref_subtitle_mode';
  static const _originalKey = 'pref_original_language';
  static const _sdhKey = 'pref_hearing_impaired';

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
    secondaryAudioLanguage: switch (_prefs.getString(_secondaryAudioKey)) {
      null => 'en',
      '' => null,
      final code => code,
    },
    subtitleLanguage: _prefs.getString(_subtitleKey),
    subtitleMode: SubtitleMode.values.firstWhere(
      (m) => m.name == _prefs.getString(_subtitleModeKey),
      orElse: () => SubtitleMode.auto,
    ),
    preferOriginal: _prefs.getBool(_originalKey) ?? false,
    hearingImpaired: _prefs.getBool(_sdhKey) ?? false,
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
    // An empty string records "no second language", unlike a missing key.
    await _prefs.setString(
      _secondaryAudioKey,
      preferences.secondaryAudioLanguage ?? '',
    );
    await _prefs.setString(_subtitleModeKey, preferences.subtitleMode.name);
    await _prefs.setBool(_originalKey, preferences.preferOriginal);
    await _prefs.setBool(_sdhKey, preferences.hearingImpaired);
  }
}
