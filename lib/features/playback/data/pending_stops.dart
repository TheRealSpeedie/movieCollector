import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/errors/app_exception.dart';

/// Where playback stopped while the server could not be reached. Sent the
/// next time playback starts, so the position is not lost.
class PendingStops {
  PendingStops(this._prefs);

  static const _key = 'pending_playback_stops';
  static const _max = 20;

  final SharedPreferences _prefs;

  List<Map<String, dynamic>> get all {
    try {
      return [
        for (final e in jsonDecode(_prefs.getString(_key) ?? '[]') as List)
          Map<String, dynamic>.from(e as Map),
      ];
    } on FormatException {
      return [];
    }
  }

  Future<void> add(String sessionId, double position, double duration) async {
    final list = [
      ...all.where((e) => e['session'] != sessionId),
      {'session': sessionId, 'position': position, 'duration': duration},
    ];
    await _prefs.setString(
      _key,
      jsonEncode(
        list.skip(list.length > _max ? list.length - _max : 0).toList(),
      ),
    );
  }

  /// Sends what is waiting. A stop the server no longer knows is dropped;
  /// one that cannot be sent yet stays for next time.
  Future<void> flush(
    Future<void> Function(String session, double position, double duration)
    stop,
  ) async {
    final left = <Map<String, dynamic>>[];
    for (final e in all) {
      try {
        await stop(
          e['session'] as String,
          (e['position'] as num).toDouble(),
          (e['duration'] as num).toDouble(),
        );
      } on ServerRejectedException {
        // Unknown session or another server: nothing to keep.
      } on AppException {
        left.add(e);
      }
    }
    await _prefs.setString(_key, jsonEncode(left));
  }
}
