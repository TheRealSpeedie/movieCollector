import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/features/playback/domain/playback_session.dart';
import 'package:movie_shelf/features/server/data/pairing_link.dart';

void main() {
  group('PairingLink', () {
    const valid =
        'movieshelf://pair?v=1&m=mobile&sid=abc&s=AAECAw&h=192.168.1.20&p=8096&tls=0&fp=ff00&id=srv&n=Wohnzimmer';

    test('reads every field', () {
      final link = PairingLink.parse(valid);

      expect(link.sessionId, 'abc');
      expect(link.secret, [0, 1, 2, 3]);
      expect(link.baseUrl, 'http://192.168.1.20:8096');
      expect(link.fingerprint, 'ff00');
      expect(link.serverId, 'srv');
      expect(link.serverName, 'Wohnzimmer');
      expect(link.tls, isFalse);
    });

    test('uses https when the server announces tls', () {
      expect(
        PairingLink.parse(valid.replaceAll('tls=0', 'tls=1')).baseUrl,
        startsWith('https://'),
      );
    });

    test('recognises pairing links', () {
      expect(PairingLink.looksLikePairingLink(' $valid'), isTrue);
      expect(PairingLink.looksLikePairingLink('https://example.com'), isFalse);
    });

    test('rejects foreign and incomplete codes', () {
      expect(
        () => PairingLink.parse('https://example.com'),
        throwsA(isA<PairingFailedException>()),
      );
      expect(
        () => PairingLink.parse('movieshelf://pair?v=1&sid=abc'),
        throwsA(isA<PairingFailedException>()),
      );
    });
  });

  group('PlaybackSession', () {
    PlaybackSession session(String mode, double offset) => PlaybackSession(
      id: 's',
      mode: mode,
      reason: '',
      quality: '720p',
      url: '/x',
      offsetSeconds: offset,
      durationSeconds: 100,
    );

    test('direct play never restarts', () {
      expect(
        session(
          'DirectPlay',
          0,
        ).needsRestartToReach(90, const Duration(seconds: 1)),
        isFalse,
      );
    });

    test('a conversion restarts for targets outside the generated part', () {
      final hls = session('Transcode', 30);

      expect(hls.needsRestartToReach(20, const Duration(seconds: 60)), isTrue);
      expect(hls.needsRestartToReach(50, const Duration(seconds: 60)), isFalse);
      expect(hls.needsRestartToReach(88, const Duration(seconds: 60)), isTrue);
    });

    test('positions are relative to the session offset', () {
      final hls = session('Transcode', 30);

      expect(hls.absolutePosition(const Duration(seconds: 5)), 35);
      expect(hls.relativeSeek(50), const Duration(seconds: 20));
      expect(hls.relativeSeek(10), Duration.zero);
    });
  });
}
