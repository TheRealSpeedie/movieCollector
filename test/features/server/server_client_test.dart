import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/features/server/data/server_client.dart';
import 'package:movie_shelf/features/server/data/server_discovery.dart';

import 'support/fakes.dart';

void main() {
  late MemoryStore store;
  late int revoked;
  late DateTime clock;

  setUp(() {
    store = MemoryStore(sampleCredentials());
    revoked = 0;
    clock = DateTime(2026, 10, 12, 20);
  });

  ServerClient build(Dio dio, {FakeDiscovery? discovery}) => ServerClient(
    credentials: store.value!,
    store: store,
    discovery: discovery ?? FakeDiscovery(),
    onRevoked: () => revoked++,
    dio: dio,
    now: () => clock,
  );

  test(
    'refreshes once, sends the bearer token and stores the rotated refresh token',
    () async {
      var refreshes = 0;
      final dio = fakeDio((o) {
        if (o.path.endsWith('/api/auth/refresh')) {
          refreshes++;
          expect(o.data, {
            'deviceId': '11111111-2222-3333-4444-555555555555',
            'refreshToken': 'refresh-1',
          });
          return jsonBody({
            'accessToken': 'access-1',
            'expiresIn': 600,
            'refreshToken': 'refresh-2',
          });
        }
        expect(o.headers['Authorization'], 'Bearer access-1');
        return jsonBody({'ok': true});
      });
      final client = build(dio);

      await client.get('/api/home');
      await client.get('/api/home');

      expect(refreshes, 1);
      expect(store.value!.refreshToken, 'refresh-2');
    },
  );

  test('refreshes again after the access token expires', () async {
    var refreshes = 0;
    final dio = fakeDio((o) {
      if (o.path.endsWith('/api/auth/refresh')) {
        refreshes++;
        return jsonBody({
          'accessToken': 'access-$refreshes',
          'expiresIn': 600,
          'refreshToken': 'refresh-${refreshes + 1}',
        });
      }
      return jsonBody({'token': o.headers['Authorization']});
    });
    final client = build(dio);

    await client.get('/x');
    clock = clock.add(const Duration(minutes: 11));
    final second = await client.get('/x') as Map;

    expect(refreshes, 2);
    expect(second['token'], 'Bearer access-2');
  });

  test('retries once with a fresh token after a 401', () async {
    var refreshes = 0;
    var calls = 0;
    final dio = fakeDio((o) {
      if (o.path.endsWith('/api/auth/refresh')) {
        refreshes++;
        return jsonBody({
          'accessToken': 'access-$refreshes',
          'expiresIn': 600,
          'refreshToken': 'refresh-${refreshes + 1}',
        });
      }
      calls++;
      return calls == 1
          ? jsonBody({'error': 'expired'}, 401)
          : jsonBody({'ok': true});
    });

    final result = await build(dio).get('/api/home') as Map;

    expect(result['ok'], true);
    expect(refreshes, 2);
    expect(calls, 2);
  });

  test(
    'clears credentials and reports revocation when the refresh is refused',
    () async {
      final dio = fakeDio((o) => jsonBody({'error': 'no'}, 401));
      final client = build(dio);

      await expectLater(
        client.get('/api/home'),
        throwsA(isA<ServerRevokedException>()),
      );

      expect(store.value, isNull);
      expect(revoked, 1);
    },
  );

  test('reports the server error message for rejected requests', () async {
    final dio = fakeDio((o) {
      if (o.path.endsWith('/api/auth/refresh')) {
        return jsonBody({
          'accessToken': 'a',
          'expiresIn': 600,
          'refreshToken': 'r',
        });
      }
      return jsonBody({'error': 'This file is not available.'}, 404);
    });

    await expectLater(
      build(dio).get('/api/files/9'),
      throwsA(
        isA<ServerRejectedException>()
            .having((e) => e.statusCode, 'status', 404)
            .having((e) => e.message, 'message', 'This file is not available.'),
      ),
    );
  });

  test('reports an unreachable server when nothing can be found', () async {
    final discovery = FakeDiscovery();
    final client = build(fakeDio(unreachable), discovery: discovery);

    await expectLater(
      client.get('/api/home'),
      throwsA(isA<ServerUnreachableException>()),
    );

    expect(discovery.calls, 1);
    expect(store.value, isNotNull);
    expect(revoked, 0);
  });

  test(
    'follows the server to a new address after verifying its identity',
    () async {
      final discovery = FakeDiscovery([
        const DiscoveredServer(
          name: 'Wohnzimmer',
          host: '192.168.1.99',
          port: 8096,
          serverId: 'server-1',
          fingerprint: '',
          tls: false,
        ),
      ]);
      final hosts = <String>[];
      final dio = fakeDio((o) async {
        hosts.add(o.uri.host);
        if (o.uri.host == '192.168.1.10') return unreachable(o);
        if (o.path.endsWith('/api/server/identity')) {
          return jsonBody(
            await identityResponse(o.queryParameters['nonce'] as String),
          );
        }
        if (o.path.endsWith('/api/auth/refresh')) {
          return jsonBody({
            'accessToken': 'a',
            'expiresIn': 600,
            'refreshToken': 'r',
          });
        }
        return jsonBody({'ok': true});
      });

      final result =
          await build(dio, discovery: discovery).get('/api/home') as Map;

      expect(result['ok'], true);
      expect(store.value!.host, '192.168.1.99');
      expect(hosts.last, '192.168.1.99');
    },
  );

  test(
    'refuses an address whose identity does not match the pinned fingerprint',
    () async {
      final discovery = FakeDiscovery([
        const DiscoveredServer(
          name: 'Fremder',
          host: '192.168.1.50',
          port: 8096,
          serverId: 'server-1',
          fingerprint: '',
          tls: false,
        ),
      ]);
      final dio = fakeDio((o) async {
        if (o.uri.host == '192.168.1.10') return unreachable(o);
        if (o.path.endsWith('/api/server/identity')) {
          return jsonBody({
            ...await identityResponse(o.queryParameters['nonce'] as String),
            'signature': (await identityResponse('other'))['signature'],
          });
        }
        return jsonBody({});
      });

      await expectLater(
        build(dio, discovery: discovery).get('/api/home'),
        throwsA(isA<ServerUnreachableException>()),
      );

      expect(store.value!.host, '192.168.1.10');
    },
  );
}
