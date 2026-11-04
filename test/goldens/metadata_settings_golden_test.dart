import 'package:speednema/core/config/config_providers.dart';
import 'package:speednema/core/network/network_info.dart';
import 'package:speednema/core/providers/core_providers.dart';
import 'package:speednema/features/settings/presentation/metadata_settings_screen.dart';

import '../support/golden_harness.dart';

class _Offline implements NetworkInfo {
  @override
  Future<bool> get isConnected async => false;
}

/// Filminfos without a key: the state, where the key comes from, and the
/// own-key field that only appears when needed.
void main() {
  screenGoldens(
    'metadata_settings_not_configured',
    () => const MetadataSettingsScreen(),
    overrides: () => [networkInfoProvider.overrideWithValue(_Offline())],
  );

  screenGoldens(
    'metadata_settings_own_key',
    () => const MetadataSettingsScreen(),
    overrides: () => [
      tmdbUserTokenProvider.overrideWith((ref) => 'own'),
      networkInfoProvider.overrideWithValue(_Offline()),
    ],
    textScales: const [1.0],
  );
}
