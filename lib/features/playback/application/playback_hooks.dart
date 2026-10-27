import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Language preferences sent when playback starts. The phone app provides
/// them from its settings; the TV app has none and the server uses the
/// preferences stored for the user (`/api/me/preferences`).
final playbackPreferencesProvider = Provider<Map<String, Object?>?>(
  (ref) => null,
);

/// Records that a film with this TMDB id was watched to the end in the local
/// collection. Only the phone app has a collection.
final viewingRecorderProvider = Provider<Future<void> Function(int tmdbId)?>(
  (ref) => null,
);
