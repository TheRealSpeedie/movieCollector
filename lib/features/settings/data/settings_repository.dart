import 'package:shared_preferences/shared_preferences.dart';

enum CollectionViewMode { grid, list }

class SettingsRepository {
  SettingsRepository(this._prefs);

  final SharedPreferences _prefs;
  static const _viewModeKey = 'collection_view_mode';

  CollectionViewMode getViewMode() {
    return _prefs.getString(_viewModeKey) == 'list'
        ? CollectionViewMode.list
        : CollectionViewMode.grid;
  }

  Future<void> setViewMode(CollectionViewMode mode) =>
      _prefs.setString(_viewModeKey, mode.name);
}
