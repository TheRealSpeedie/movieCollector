import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/features/playback/data/playback_api.dart';
import 'package:movie_shelf/features/server/application/server_providers.dart';
import 'package:movie_shelf/features/server/data/library_repository.dart';
import 'package:movie_shelf/features/server/data/pairing_link.dart';
import 'package:movie_shelf/features/server/data/server_client.dart';
import 'package:movie_shelf/features/server/data/server_credentials.dart';
import '../features/server/support/fakes.dart';
import 'support.dart';

void main() {
  late Admin admin;
  late ServerCredentials credentials;
  late ServerClient client;
  late LibraryRepository library;
  late PlaybackApi playback;
  late int movieId;
  late int movieFileId;
  late int seriesId;

  setUpAll(() async {
    if (skipReason != null) return;
    admin = await Admin.login();
    credentials = await pair(await admin.newLink(), name: 'Main phone');
    client = clientFor(credentials);
    library = LibraryRepository(client);
    playback = PlaybackApi(client);
    final page = await library.titles(const TitleQuery());
    movieId = page.items.firstWhere((t) => !t.isSeries).id;
    seriesId = page.items.firstWhere((t) => t.isSeries).id;
    movieFileId = (await library.title(movieId)).files.first.id;
  });

  group('pairing', () {
    test('delivers working credentials after a sealed login', () async {
      final me = await client.get('/api/auth/me') as Map;
      expect((me['user'] as Map)['username'], 'owner');
      expect(me['deviceId'], credentials.deviceId);
      expect(credentials.serverName, 'Integration');
      expect(credentials.host, '127.0.0.1');
    }, skip: skipReason);

    test('a pairing link works once', () async {
      final link = await admin.newLink();
      await pair(link);
      await expectLater(pair(link), throwsA(isA<PairingFailedException>()));
    }, skip: skipReason);

    test('a wrong password leaves the link usable', () async {
      final link = await admin.newLink();
      await expectLater(
        pair(link, password: 'not the password'),
        throwsA(
          isA<PairingFailedException>().having(
            (e) => e.message,
            'message',
            'Benutzername oder Passwort ist falsch.',
          ),
        ),
      );
      final credentials = await pair(link);
      expect(credentials.username, 'owner');
    }, skip: skipReason);

    test('the dashboard can approve a device that sent no password', () async {
      final link = await admin.newLink();
      final pending = pair(link, username: null, name: 'Approved phone');
      for (var i = 0; i < 50; i++) {
        final waiting = await admin.send('GET', '/api/pairing/pending') as List;
        if (waiting.isNotEmpty) {
          expect((waiting.first as Map)['deviceName'], 'Approved phone');
          await admin.send(
            'POST',
            '/api/pairing/sessions/${(waiting.first as Map)['sessionId']}/approve',
            {},
          );
          break;
        }
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      final approved = await pending;
      expect(approved.username, 'owner');
    }, skip: skipReason);

    test('the dashboard can deny a device', () async {
      final link = await admin.newLink();
      final pending = pair(link, username: null, name: 'Denied phone');
      final expectation = expectLater(
        pending,
        throwsA(
          isA<PairingFailedException>().having(
            (e) => e.message,
            'message',
            contains('abgelehnt'),
          ),
        ),
      );
      for (var i = 0; i < 50; i++) {
        final waiting = await admin.send('GET', '/api/pairing/pending') as List;
        if (waiting.isNotEmpty) {
          await admin.send(
            'POST',
            '/api/pairing/sessions/${(waiting.first as Map)['sessionId']}/deny',
            {},
          );
          break;
        }
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      await expectation;
    }, skip: skipReason);

    test('a server with another identity is refused', () async {
      final forged = PairingLink.parse(
        (await admin.newLinkText()).replaceAll(
          RegExp(r'fp=[0-9a-f]+'),
          'fp=${'0' * 64}',
        ),
      );
      await expectLater(
        pair(forged),
        throwsA(
          isA<PairingFailedException>().having(
            (e) => e.message,
            'message',
            contains('bestätigt'),
          ),
        ),
      );
    }, skip: skipReason);
  });

  group('library', () {
    test('lists movies and series from real metadata', () async {
      final page = await library.titles(const TitleQuery());
      expect(page.total, greaterThanOrEqualTo(2));
      final names = page.items.map((t) => t.name).toList();
      expect(names, contains('Interstellar'));
      expect(names, contains('The Last of Us'));
      expect(page.items.firstWhere((t) => !t.isSeries).year, 2014);
    }, skip: skipReason);

    test('searches and filters', () async {
      expect(
        (await library.titles(
          const TitleQuery(search: 'interstel'),
        )).items.map((t) => t.name),
        ['Interstellar'],
      );
      expect(
        (await library.titles(const TitleQuery(kind: 'Series'))).items.length,
        1,
      );
      expect(
        (await library.titles(const TitleQuery(search: 'zzzzzz'))).items,
        isEmpty,
      );
    }, skip: skipReason);

    test('shows details, versions and episodes', () async {
      final movie = await library.title(movieId);
      expect(movie.overview, isNotEmpty);
      expect(movie.files, hasLength(1));
      expect(movie.files.first.height, 360);
      expect(movie.files.first.audioTracks, isNotEmpty);
      expect(movie.preferredFile!.id, movieFileId);

      final episodes = await library.episodes(seriesId);
      expect(episodes.map((e) => e.number), [1, 2]);
      expect(episodes.every((e) => e.files.isNotEmpty), isTrue);
      expect((await library.title(seriesId)).next!.number, 1);
    }, skip: skipReason);

    test('serves artwork to the signed-in device only', () async {
      final poster = (await library.title(movieId)).title.posterUrl!;
      expect((await fetchBytes(client, poster)).length, greaterThan(1000));
      await expectLater(
        Dio().get<List<int>>(
          client.url(poster),
          options: Options(responseType: ResponseType.bytes),
        ),
        throwsA(isA<DioException>()),
      );
    }, skip: skipReason);
  });

  group('playback', () {
    test('plays the original file with range requests', () async {
      final session = await playback.start(
        fileId: movieFileId,
        startSeconds: 0,
      );
      expect(session.mode, 'DirectPlay');
      expect(session.isDirect, isTrue);
      final head = await Dio().get<List<int>>(
        client.url(session.url),
        options: Options(
          responseType: ResponseType.bytes,
          headers: {...await client.authHeaders(), 'Range': 'bytes=0-99'},
        ),
      );
      expect(head.statusCode, 206);
      expect(head.data, hasLength(100));
      await playback.stop(session.id, position: 1, duration: 40);
    }, skip: skipReason);

    test('converts to HLS at a lower quality', () async {
      final session = await playback.start(
        fileId: movieFileId,
        startSeconds: 0,
        requestedHeight: 240,
      );
      expect(session.mode, 'Transcode');
      expect(session.quality, '240p');
      expect(session.url, endsWith('/index.m3u8'));

      var playlist = '';
      for (var i = 0; i < 100 && !playlist.contains('#EXT-X-ENDLIST'); i++) {
        playlist = await fetchText(client, session.url);
        await Future<void>.delayed(const Duration(milliseconds: 200));
      }
      expect(playlist, contains('#EXT-X-ENDLIST'));
      final folder = session.url.substring(0, session.url.lastIndexOf('/') + 1);
      expect((await fetchBytes(client, '${folder}init.mp4')), isNotEmpty);
      expect((await fetchBytes(client, '${folder}seg00000.m4s')), isNotEmpty);

      await playback.stop(session.id, position: 0, duration: 40);
      await expectLater(
        fetchBytes(client, session.url),
        throwsA(isA<DioException>()),
      );
    }, skip: skipReason);

    test('starting later in a conversion reports the offset', () async {
      final session = await playback.start(
        fileId: movieFileId,
        startSeconds: 20,
        requestedHeight: 240,
      );
      expect(session.offsetSeconds, 20);
      expect(session.absolutePosition(const Duration(seconds: 5)), 25);
      expect(
        session.needsRestartToReach(10, const Duration(seconds: 30)),
        isTrue,
      );
      expect(
        session.needsRestartToReach(30, const Duration(seconds: 30)),
        isFalse,
      );
      await playback.stop(session.id, position: 20, duration: 40);
    }, skip: skipReason);

    test(
      'saves progress, offers resume and marks the end as watched',
      () async {
        final session = await playback.start(
          fileId: movieFileId,
          startSeconds: 0,
        );
        await playback.progress(
          session.id,
          position: 15,
          duration: 40,
          paused: false,
        );

        final detail = await library.title(movieId);
        expect(detail.progress.positionSeconds, 15);
        expect(detail.progress.canResume, isTrue);
        final home = await library.home();
        expect(home.resume.map((r) => r.titleId), contains(movieId));
        expect(
          home.resume.firstWhere((r) => r.titleId == movieId).positionSeconds,
          15,
        );

        await playback.stop(session.id, position: 38, duration: 40);
        final finished = await library.title(movieId);
        expect(finished.progress.watched, isTrue);
        expect(finished.progress.canResume, isFalse);
        expect(
          (await library.home()).resume.map((r) => r.titleId),
          isNot(contains(movieId)),
        );

        await library.setWatched(watched: false, titleId: movieId);
        expect((await library.title(movieId)).progress.watched, isFalse);
      },
      skip: skipReason,
    );

    test('a finished session cannot receive more progress', () async {
      final session = await playback.start(
        fileId: movieFileId,
        startSeconds: 0,
      );
      await playback.stop(session.id, position: 2, duration: 40);
      await expectLater(
        playback.progress(session.id, position: 3, duration: 40, paused: false),
        throwsA(
          isA<ServerRejectedException>().having(
            (e) => e.statusCode,
            'status',
            409,
          ),
        ),
      );
    }, skip: skipReason);

    test('advances the next episode after one is watched', () async {
      final episodes = await library.episodes(seriesId);
      await library.setWatched(watched: true, episodeId: episodes.first.id);
      expect((await library.title(seriesId)).next!.number, 2);
      await library.setWatched(watched: false, episodeId: episodes.first.id);
      expect((await library.title(seriesId)).next!.number, 1);
    }, skip: skipReason);

    test('reports a missing file in plain language', () async {
      await expectLater(
        playback.start(fileId: 999999, startSeconds: 0),
        throwsA(
          isA<ServerRejectedException>().having(
            (e) => e.statusCode,
            'status',
            404,
          ),
        ),
      );
    }, skip: skipReason);
  });

  group('device lifecycle', () {
    test('a revoked device is signed out on its next request', () async {
      final phone = await pair(await admin.newLink(), name: 'Revoked phone');
      final store = MemoryStore(phone);
      var revoked = 0;
      final revokedClient = clientFor(
        phone,
        store: store,
        onRevoked: () => revoked++,
      );
      await revokedClient.get('/api/home');

      await admin.send('DELETE', '/api/devices/${phone.deviceId}');

      await expectLater(
        revokedClient.get('/api/home'),
        throwsA(isA<ServerRevokedException>()),
      );
      expect(store.value, isNull);
      expect(revoked, 1);
    }, skip: skipReason);

    test('disconnecting removes the device from the server', () async {
      final phone = await pair(await admin.newLink(), name: 'Leaving phone');
      final store = MemoryStore();
      final container = ProviderContainer(
        overrides: [
          credentialStoreProvider.overrideWithValue(store),
          serverDiscoveryProvider.overrideWithValue(FakeDiscovery()),
        ],
      );
      addTearDown(container.dispose);

      await container.read(serverSessionProvider.future);
      await container.read(serverSessionProvider.notifier).connect(phone);
      expect(container.read(serverClientProvider), isNotNull);
      expect(store.value!.deviceId, phone.deviceId);

      await container.read(serverSessionProvider.notifier).disconnect();

      expect(store.value, isNull);
      expect(container.read(serverClientProvider), isNull);
      final devices = await admin.send('GET', '/api/devices') as List;
      expect(
        devices.map((d) => (d as Map)['id']),
        isNot(contains(phone.deviceId)),
      );
    }, skip: skipReason);

    test(
      'stores the rotated refresh token so the device keeps working',
      () async {
        final phone = await pair(await admin.newLink(), name: 'Rotating phone');
        final store = MemoryStore(phone);
        final first = clientFor(phone, store: store);
        await first.get('/api/home');
        expect(store.value!.refreshToken, isNot(phone.refreshToken));

        final second = clientFor(store.value!, store: store);
        expect(await second.get('/api/auth/me'), isA<Map>());
      },
      skip: skipReason,
    );
  });
}
