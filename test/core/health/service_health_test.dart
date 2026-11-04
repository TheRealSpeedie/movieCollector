import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/core/config/config_providers.dart';
import 'package:speednema/core/errors/app_exception.dart';
import 'package:speednema/core/health/health_providers.dart';
import 'package:speednema/core/health/service_health.dart';
import 'package:speednema/core/network/dio_client.dart';
import 'package:speednema/core/network/network_info.dart';
import 'package:speednema/core/providers/core_providers.dart';
import 'package:speednema/shared/widgets/error_view.dart';
import 'package:speednema/shared/widgets/status_view.dart';

import '../../features/server/support/fakes.dart';

class _Network implements NetworkInfo {
  _Network(this.online);

  final bool online;

  @override
  Future<bool> get isConnected async => online;
}

/// The regression matrix for movie information (section F of the plan):
/// each failure is told apart, reported to the health model, and described
/// with its own words and remedy.
void main() {
  late List<ServiceHealth> reported;
  late FakeAdapter adapter;

  DioClient client(
    Handler handler, {
    String key = 'token',
    bool online = true,
  }) {
    adapter = FakeAdapter(handler);
    return DioClient(
      dio: Dio()..httpClientAdapter = adapter,
      networkInfo: _Network(online),
      service: ExternalService.tmdb,
      credential: () => key,
      onHealth: reported.add,
    );
  }

  ResponseBody status(int code) => jsonBody({'status_message': 'x'}, code);

  setUp(() => reported = []);

  group('requests', () {
    test('a missing key fails before anything is sent', () async {
      final c = client((_) => jsonBody({}), key: '');
      await expectLater(
        c.get<dynamic>('/search/movie'),
        throwsA(isA<ServiceNotConfiguredException>()),
      );
      expect(adapter.requests, isEmpty);
      expect(reported.single, isA<HealthNotConfigured>());
    });

    test('a rejected key is not a missing key', () async {
      final c = client((_) => status(401));
      await expectLater(
        c.get<dynamic>('/search/movie'),
        throwsA(isA<ServiceCredentialsInvalidException>()),
      );
      expect(reported.single, isA<HealthInvalidCredentials>());
    });

    test('older handlers still catch both key problems', () async {
      await expectLater(
        client((_) => status(403)).get<dynamic>('/x'),
        throwsA(isA<InvalidApiConfigException>()),
      );
      await expectLater(
        client((_) => jsonBody({}), key: '').get<dynamic>('/x'),
        throwsA(isA<InvalidApiConfigException>()),
      );
    });

    test('no connection on the device is reported as offline', () async {
      final c = client((_) => jsonBody({}), online: false);
      await expectLater(
        c.get<dynamic>('/x'),
        throwsA(isA<NoInternetException>()),
      );
      expect(adapter.requests, isEmpty);
      expect(reported.single, isA<HealthOffline>());
    });

    test(
      'a failing connection is a network problem, not a key problem',
      () async {
        await expectLater(
          client(unreachable).get<dynamic>('/x'),
          throwsA(isA<NoInternetException>()),
        );
        expect(reported.single, isA<HealthOffline>());
      },
    );

    test('a server error marks the service unavailable', () async {
      await expectLater(
        client((_) => status(503)).get<dynamic>('/x'),
        throwsA(isA<ApiUnavailableException>()),
      );
      expect(reported.single, isA<HealthUnavailable>());
    });

    test('a not-found title says nothing about the service', () async {
      await expectLater(
        client((_) => status(404)).get<dynamic>('/movie/1'),
        throwsA(isA<MovieNotFoundException>()),
      );
      expect(reported, isEmpty);
    });

    test('success is reported', () async {
      await client((_) => jsonBody({'results': []})).get<dynamic>('/x');
      expect(reported.single, isA<HealthOk>());
    });
  });

  group('health model', () {
    ProviderContainer container({String? userToken}) {
      final c = ProviderContainer(
        overrides: [tmdbUserTokenProvider.overrideWith((ref) => userToken)],
      );
      addTearDown(c.dispose);
      return c;
    }

    test('an entered key makes TMDB configured and is used for requests', () {
      final c = container(userToken: '  own  ');
      expect(c.read(tmdbTokenProvider), 'own');
      expect(c.read(tmdbKeySourceProvider), TmdbKeySource.user);
      expect(
        c.read(serviceHealthProvider(ExternalService.tmdb)),
        isA<HealthUnknown>(),
      );
      expect(
        c.read(tmdbDioProvider).options.headers['Authorization'],
        'Bearer own',
      );
    });

    test(
      'without any key TMDB is not configured, and success cannot override it',
      () {
        final c = container();
        // The test build has no TMDB_ACCESS_TOKEN.
        expect(c.read(tmdbKeySourceProvider), TmdbKeySource.none);
        final health = c.read(
          serviceHealthProvider(ExternalService.tmdb).notifier,
        );
        health.report(HealthOk(DateTime.now()));
        expect(
          c.read(serviceHealthProvider(ExternalService.tmdb)),
          isA<HealthNotConfigured>(),
        );
      },
    );

    test('repeated successes do not notify listeners again', () {
      final c = container(userToken: 'own');
      var notifications = 0;
      c.listen(
        serviceHealthProvider(ExternalService.tmdb),
        (_, _) => notifications++,
      );
      final health = c.read(
        serviceHealthProvider(ExternalService.tmdb).notifier,
      );
      health.report(HealthOk(DateTime.now()));
      health.report(HealthOk(DateTime.now()));
      expect(notifications, 1);
      health.report(const HealthInvalidCredentials());
      expect(notifications, 2);
    });
  });

  group('what people are told', () {
    test('missing TMDB leads to setup, never to "Keine Treffer"', () {
      final s = classifyError(
        const ServiceNotConfiguredException(ExternalService.tmdb),
      );
      expect(s.kind, StatusKind.notConfigured);
      expect(s.title, 'Filminfos sind noch nicht eingerichtet');
      expect(s.remedy, Remedy.configureMetadata);
    });

    test('a rejected key also leads to setup, with its own words', () {
      final s = classifyError(
        const ServiceCredentialsInvalidException(ExternalService.tmdb),
      );
      expect(s.title, 'TMDB hat den Schlüssel abgelehnt');
      expect(s.remedy, Remedy.configureMetadata);
    });

    test('network trouble is retried and reassures about local data', () {
      final s = classifyError(const NoInternetException());
      expect(s.kind, StatusKind.noNetwork);
      expect(s.remedy, Remedy.retry);
    });

    test('a revoked device is asked to reconnect', () {
      final s = classifyError(const ServerRevokedException());
      expect(s.kind, StatusKind.authRequired);
      expect(s.remedy, Remedy.reconnectServer);
    });

    test(
      'server errors are shown in German, the English text only as details',
      () {
        final e = ServerRejectedException.fromResponse(403, {
          'error': 'The PIN is not correct.',
          'code': 'pin_incorrect',
        });
        expect(e.message, 'Die PIN stimmt nicht.');
        expect(describeError(e), 'Die PIN stimmt nicht.');
        final s = classifyError(e);
        expect(s.message, 'Die PIN stimmt nicht.');
        expect(s.technical, 'The PIN is not correct.');
      },
    );

    test('without a code the status decides the German words', () {
      final busy = ServerRejectedException.fromResponse(503, {
        'error': 'Something odd happened in English.',
      });
      expect(busy.message, isNot(contains('English')));
      expect(classifyError(busy).kind, StatusKind.serviceUnavailable);
      expect(
        ServerRejectedException.fromResponse(429, null).message,
        contains('Zu viele Versuche'),
      );
    });

    test('unknown errors stay generic, with the raw text in details', () {
      final s = classifyError(StateError('boom'));
      expect(s.kind, StatusKind.unexpected);
      expect(s.message, isNot(contains('boom')));
      expect(s.technical, contains('boom'));
    });
  });
}
