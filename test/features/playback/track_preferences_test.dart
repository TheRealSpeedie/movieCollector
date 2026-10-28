import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/features/playback/domain/playback_session.dart';
import 'package:movie_shelf/features/server/domain/server_models.dart';
import 'package:movie_shelf/features/settings/data/settings_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  test(
    'language preferences survive a restart, including "no second language"',
    () async {
      SharedPreferences.setMockInitialValues({});
      final repository = SettingsRepository(
        await SharedPreferences.getInstance(),
      );
      expect(repository.getPreferences().secondaryAudioLanguage, 'en');

      await repository.setPreferences(
        const UserPreferences(
          audioLanguage: 'de',
          secondaryAudioLanguage: null,
          subtitleLanguage: 'de',
          subtitleMode: SubtitleMode.always,
          preferOriginal: true,
          hearingImpaired: true,
        ),
      );
      final stored = repository.getPreferences();
      expect(stored.secondaryAudioLanguage, isNull);
      expect(stored.subtitleMode, SubtitleMode.always);
      expect(stored.preferOriginal, isTrue);
      expect(stored.hearingImpaired, isTrue);
    },
  );

  test('preferences are sent in the server\'s shape', () {
    expect(const UserPreferences(audioLanguage: 'de').toServerJson(), {
      'audioLanguages': ['de', 'en'],
      'subtitleLanguage': 'de',
      'subtitleMode': 'Auto',
      'preferOriginal': false,
      'hearingImpaired': false,
      'audioDescription': false,
    });
    expect(
      const UserPreferences(
        audioLanguage: 'en',
        secondaryAudioLanguage: 'en',
      ).toServerJson()['audioLanguages'],
      ['en'],
    );
  });

  test('the server\'s track choice and subtitle files are read', () {
    final session = PlaybackSession.fromJson({
      'sessionId': 'a',
      'mode': 'DirectPlay',
      'reason': '',
      'quality': 'Original',
      'url': '/x',
      'offsetSeconds': 0,
      'tracks': {'audio': 's1', 'subtitle': 'x7', 'reason': 'Audio in de.'},
    });
    expect(session.audioKey, 's1');
    expect(session.subtitleKey, 'x7');

    final file = MediaFileInfo.fromJson({
      'id': 3,
      'fileName': 'Film.mkv',
      'externalSubtitles': [
        {
          'id': 7,
          'language': 'de',
          'forced': true,
          'hearingImpaired': false,
          'audioDescription': false,
          'source': 'opensubtitles',
          'fileName': 'Film.de.forced.srt',
        },
      ],
    });
    final subtitle = file.externalSubtitles.single;
    expect(subtitle.downloaded, isTrue);
    expect(subtitle.label, 'de (erzwungen) · heruntergeladen');
  });
}
