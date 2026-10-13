import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/app/theme/app_theme.dart';
import 'package:movie_shelf/features/server/application/server_providers.dart';
import 'package:movie_shelf/features/server/data/pairing_crypto.dart';
import 'package:movie_shelf/features/server/data/pairing_service.dart';
import 'package:movie_shelf/features/server/data/server_discovery.dart';
import 'package:movie_shelf/features/television/presentation/tv_connect_screen.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../server/support/fakes.dart';

const _sessionId = 'aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee';
final _secret = List<int>.generate(32, (i) => i);

String get _link {
  final fingerprint = sampleCredentials().fingerprint;
  return 'movieshelf://pair?v=1&m=tv&sid=$_sessionId&s=${base64Url.encode(_secret).replaceAll('=', '')}&h=192.168.1.10&p=8096&tls=0&fp=$fingerprint&id=server-1&n=Wohnzimmer';
}

Future<String> _sealedCredentials() async {
  final keys = await PairingCrypto.derive(_secret);
  final credentials = sampleCredentials();
  return PairingCrypto.seal(
    keys.encKey,
    utf8.encode(
      jsonEncode({
        'serverId': credentials.serverId,
        'serverName': credentials.serverName,
        'fingerprint': credentials.fingerprint,
        'deviceId': credentials.deviceId,
        'refreshToken': credentials.refreshToken,
        'userId': 1,
        'username': 'owner',
        'role': 'Admin',
      }),
    ),
    'credential|$_sessionId',
  );
}

void main() {
  late MemoryStore store;
  late int polls;
  late int approveAfter;

  setUp(() {
    store = MemoryStore();
    polls = 0;
    approveAfter = 2;
  });

  PairingService service() => PairingService(
    dio: fakeDio((options) async {
      final path = options.uri.path;
      if (path == '/api/server/identity') {
        return jsonBody(
          await identityResponse(options.queryParameters['nonce']),
        );
      }
      if (path == '/api/pairing/tv-sessions') {
        return jsonBody({
          'sessionId': _sessionId,
          'secret': '',
          'shortCode': 'K7M2QX',
          'expiresAt': DateTime.utc(2026, 10, 12, 20).toIso8601String(),
          'link': _link,
        });
      }
      polls++;
      return jsonBody({
        'status': polls >= approveAfter ? 'approved' : 'waiting',
        'sealedCredential': polls >= approveAfter
            ? await _sealedCredentials()
            : null,
      });
    }),
  );

  Future<ProviderContainer> pump(
    WidgetTester tester, {
    List<DiscoveredServer> servers = const [],
  }) async {
    tester.view.physicalSize = const Size(1920, 1080);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final container = ProviderContainer(
      overrides: [
        credentialStoreProvider.overrideWithValue(store),
        serverDiscoveryProvider.overrideWithValue(FakeDiscovery(servers)),
        pairingServiceProvider.overrideWithValue(service()),
      ],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: MaterialApp(theme: AppTheme.dark, home: const TvConnectScreen()),
      ),
    );
    await tester.pump();
    return container;
  }

  final server = DiscoveredServer(
    name: 'Wohnzimmer',
    host: '192.168.1.10',
    port: 8096,
    serverId: 'server-1',
    fingerprint: sampleCredentials().fingerprint,
    tls: false,
  );

  testWidgets('shows the QR code, short code and server fingerprint', (
    tester,
  ) async {
    final container = await pump(tester, servers: [server]);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(QrImageView), findsOneWidget);
    expect(find.text('K7M2QX'), findsOneWidget);
    expect(find.textContaining('62DA D5BB 09CD 5A45'), findsOneWidget);
    expect(container.read(serverSessionProvider).valueOrNull, isNull);

    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(seconds: 3));
  });

  testWidgets('stores the credentials once the phone approves', (tester) async {
    final container = await pump(tester, servers: [server]);
    await tester.pump(const Duration(milliseconds: 100));

    await tester.pump(const Duration(seconds: 2));
    expect(store.value, isNull);

    await tester.pump(const Duration(seconds: 2));
    await tester.pump(const Duration(milliseconds: 100));

    expect(store.value?.username, 'owner');
    expect(store.value?.host, '192.168.1.10');
    expect(
      container.read(serverSessionProvider).valueOrNull?.deviceId,
      sampleCredentials().deviceId,
    );
  });

  testWidgets('asks for an address when no server is found', (tester) async {
    await pump(tester);
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Serveradresse'), findsOneWidget);
    expect(find.byType(QrImageView), findsNothing);
  });
}
