import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../cloud/application/cloud_providers.dart';
import '../../server/application/server_providers.dart';
import '../domain/discovery.dart';

/// Whether the person agreed that the wish and the shortlist may be sent to
/// an AI service. Off by default; can be withdrawn at any time.
class AiConsent extends Notifier<bool> {
  static const _key = 'ai_discovery_consent';

  @override
  bool build() => ref.watch(sharedPreferencesProvider).getBool(_key) ?? false;

  Future<void> set(bool value) async {
    await ref.read(sharedPreferencesProvider).setBool(_key, value);
    state = value;
  }
}

final aiConsentProvider = NotifierProvider<AiConsent, bool>(AiConsent.new);

/// A model on the device. No build ships one yet; when one does, it is used
/// first because nothing leaves the device.
final onDeviceModelProvider = Provider<OnDeviceModel?>((ref) => null);

/// AI suggestions offered by the own server (with its administrator's
/// setup) or Movie Shelf Cloud. Null when neither offers them.
final remoteRankerProvider = FutureProvider<RemoteDiscoveryRanker?>((
  ref,
) async {
  final server = ref.watch(serverClientProvider);
  if (server != null) {
    try {
      final status = await server.get('/api/discover/status') as Map;
      if (status['available'] == true) {
        return RemoteDiscoveryRanker(
          label: 'KI über deinen Server',
          post: (path, body) => server.post(path, body: body),
        );
      }
    } on Exception {
      // An older server or no connection: try the cloud.
    }
  }
  final cloud = ref.watch(cloudClientProvider);
  if (cloud?.session != null) {
    try {
      final status = await cloud!.get('/api/discover/status') as Map;
      if (status['available'] == true) {
        return RemoteDiscoveryRanker(
          label: 'KI über Movie Shelf Cloud',
          post: (path, body) => cloud.post(path, body: body),
        );
      }
    } on Exception {
      return null;
    }
  }
  return null;
});

/// Who orders the suggestions: a model on the device, otherwise a remote
/// one only with consent, otherwise nobody (rules alone).
final discoveryRankerProvider = FutureProvider<DiscoveryRanker?>((ref) async {
  final onDevice = ref.watch(onDeviceModelProvider);
  if (onDevice != null && await onDevice.isReady()) return onDevice;
  if (!ref.watch(aiConsentProvider)) return null;
  return ref.watch(remoteRankerProvider.future);
});
