import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/features/cloud/data/cloud_client.dart';
import 'package:movie_shelf/features/cloud/data/cloud_sync_provider.dart';

import '../server/support/fakes.dart';

class MemoryCloudStore implements CloudSessionStore {
  MemoryCloudStore([this.value]);

  CloudSession? value;

  @override
  Future<CloudSession?> load() async => value;

  @override
  Future<void> save(CloudSession session) async => value = session;

  @override
  Future<void> clear() async => value = null;
}

const _base = 'https://cloud.test';

const _session = CloudSession(
  email: 'anna@example.org',
  deviceId: 'device-1',
  refreshToken: 'refresh-1',
);

Map<String, Object?> _tokens(String refresh) => {
  'deviceId': 'device-1',
  'accessToken': 'access-$refresh',
  'refreshToken': refresh,
  'expiresIn': 900,
};

void main() {
  late MemoryCloudStore store;
  late int signedOut;

  setUp(() {
    store = MemoryCloudStore(_session);
    signedOut = 0;
  });

  CloudClient build(Dio dio, {CloudSession? session = _session}) => CloudClient(
    baseUrl: _base,
    store: store,
    session: session,
    onSignedOut: () => signedOut++,
    dio: dio,
  );

  test('signing in stores the session without the password', () async {
    store.value = null;
    final dio = fakeDio((o) {
      expect(o.uri.toString(), '$_base/api/sessions');
      expect(o.data, containsPair('email', 'Anna@Example.org'));
      return jsonBody(_tokens('refresh-1'));
    });
    final session = await build(
      dio,
      session: null,
    ).signIn(' Anna@Example.org ', 'geheim-geheim', 'Pixel');

    expect(session.email, 'anna@example.org');
    expect(store.value!.refreshToken, 'refresh-1');
    expect(store.value!.toJson().keys, isNot(contains('password')));
  });

  test(
    'refreshes once for parallel requests and stores the rotated token',
    () async {
      var refreshes = 0;
      final dio = fakeDio((o) {
        if (o.path.endsWith('/api/sessions/refresh')) {
          refreshes++;
          expect(o.data, {'deviceId': 'device-1', 'refreshToken': 'refresh-1'});
          return jsonBody(_tokens('refresh-2'));
        }
        expect(o.headers['Authorization'], 'Bearer access-refresh-2');
        return jsonBody({'ok': true});
      });
      final client = build(dio);

      await Future.wait([
        client.get('/api/account'),
        client.get('/api/devices'),
      ]);

      expect(refreshes, 1);
      expect(store.value!.refreshToken, 'refresh-2');
    },
  );

  test('a rejected refresh signs the device out', () async {
    final dio = fakeDio((o) => jsonBody({'error': 'revoked'}, 401));
    final client = build(dio);

    await expectLater(
      client.get('/api/account'),
      throwsA(isA<ServerRejectedException>()),
    );
    expect(signedOut, 1);
    expect(store.value, isNull);
    expect(client.session, isNull);
  });

  test('an expired subscription is reported, not a sign-out', () async {
    final dio = fakeDio((o) {
      if (o.path.endsWith('/refresh')) return jsonBody(_tokens('refresh-2'));
      return jsonBody({'error': 'Abo abgelaufen'}, 402);
    });
    final provider = CloudSyncProvider(build(dio));

    await expectLater(
      provider.push(const []),
      throwsA(isA<CloudSubscriptionException>()),
    );
    expect(signedOut, 0);
    expect(store.value, isNotNull);
  });

  test('no connection is reported as unreachable', () async {
    final client = build(fakeDio(unreachable));

    await expectLater(
      client.get('/api/account'),
      throwsA(isA<CloudUnreachableException>()),
    );
    expect(store.value, isNotNull);
  });

  test('signing out works offline and forgets the session', () async {
    final client = build(fakeDio(unreachable));

    await client.signOut();

    expect(store.value, isNull);
    expect(client.session, isNull);
  });

  test('the sync scope separates accounts', () {
    final a = CloudSyncProvider(build(fakeDio(unreachable)));
    final b = CloudSyncProvider(
      build(
        fakeDio(unreachable),
        session: const CloudSession(
          email: 'ben@example.org',
          deviceId: 'd',
          refreshToken: 'r',
        ),
      ),
    );
    expect(a.scope, isNot(b.scope));
    expect(a.scope, startsWith('cloud:$_base/'));
  });
}
