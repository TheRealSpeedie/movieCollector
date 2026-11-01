import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/features/server/application/server_providers.dart';
import 'package:speednema/features/server/data/server_discovery.dart';
import 'package:speednema/features/server/presentation/code_pairing_panel.dart';

import 'support/fakes.dart';

void main() {
  group('typed addresses', () {
    test('without a port the Speednema default is used, not Jellyfin\'s', () {
      expect(serverBaseUrl('192.168.1.20'), 'http://192.168.1.20:8420');
      expect(defaultServerPort, 8420);
    });

    test('a port, a scheme or a trailing slash are kept or cleaned', () {
      expect(serverBaseUrl('nas.local:9000'), 'http://nas.local:9000');
      expect(serverBaseUrl('http://nas.local:9000/'), 'http://nas.local:9000');
      expect(serverBaseUrl('  10.0.0.5 '), 'http://10.0.0.5:8420');
    });
  });

  Future<void> pump(WidgetTester tester, List<DiscoveredServer> servers) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          serverDiscoveryProvider.overrideWithValue(FakeDiscovery(servers)),
        ],
        child: MaterialApp(
          theme: AppTheme.dark,
          home: Scaffold(
            body: SingleChildScrollView(
              child: CodePairingPanel(deviceName: () => 'Testhandy'),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('servers on the network are offered by name', (tester) async {
    await pump(tester, const [
      DiscoveredServer(
        name: 'Wohnzimmer',
        host: '192.168.1.20',
        port: 8420,
        serverId: 's1',
        fingerprint: 'ab',
        tls: false,
      ),
    ]);
    expect(find.text('Wohnzimmer'), findsOneWidget);
    expect(find.text('192.168.1.20:8420'), findsOneWidget);
  });

  testWidgets('nothing found says what to check and offers the address', (
    tester,
  ) async {
    await pump(tester, const []);
    expect(find.textContaining('Kein Server gefunden'), findsOneWidget);
    expect(find.text('Adresse eingeben'), findsOneWidget);
  });
}
