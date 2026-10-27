import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../server/application/server_providers.dart';
import '../../settings/application/settings_providers.dart';

/// Keeps the server's copy of the language preferences current, so a TV
/// paired to the same user plays with the phone's choices. Best effort: an
/// unreachable server is simply updated the next time.
final preferencesUploadProvider = Provider<void>((ref) {
  final client = ref.watch(serverClientProvider);
  final preferences = ref.watch(userPreferencesProvider);
  if (client == null) return;
  client
      .put('/api/me/preferences', body: preferences.toServerJson())
      .catchError((_) => null);
});
