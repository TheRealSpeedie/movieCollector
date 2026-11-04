import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/features/server/application/server_connection.dart';
import 'package:speednema/features/server/application/server_providers.dart';

import 'support/fakes.dart';

/// The server connection in the states people need to tell apart.
void main() {
  Future<ProviderContainer> container({bool paired = true}) async {
    final c = ProviderContainer(
      overrides: [
        credentialStoreProvider.overrideWithValue(
          MemoryStore(paired ? sampleCredentials() : null),
        ),
      ],
    );
    addTearDown(c.dispose);
    await c.read(serverSessionProvider.future);
    return c;
  }

  test('no server is "not connected", which is not a problem', () async {
    final c = await container(paired: false);
    final state = c.read(serverConnectionProvider);
    expect(state, isA<ServerNotConfigured>());
    expect(state.explanation, contains('funktioniert ohne Server'));
  });

  test(
    'paired but not yet asked is connecting, then follows real requests',
    () async {
      final c = await container();
      expect(c.read(serverConnectionProvider), isA<ServerConnecting>());

      final reach = c.read(serverReachabilityProvider.notifier);
      reach.report(true);
      final connected = c.read(serverConnectionProvider);
      expect(connected, isA<ServerConnected>());

      reach.report(false);
      final offline = c.read(serverConnectionProvider);
      expect(offline, isA<ServerOffline>());
      // Offline keeps when it last worked and reassures about local data.
      expect((offline as ServerOffline).lastOk, isNotNull);
      expect(offline.explanation, contains('Sammlung bleibt'));
    },
  );

  test('a device the server removed must reconnect', () async {
    final c = await container();
    c.read(serverSessionProvider.notifier).revoked();
    expect(c.read(serverConnectionProvider), isA<ServerAuthRequired>());
  });
}
