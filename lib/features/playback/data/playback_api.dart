import '../../server/data/server_client.dart';
import '../../server/domain/server_models.dart';
import '../domain/playback_session.dart';

const phoneProfile = {
  'containers': ['mp4', 'm4v', 'mov', 'mkv', 'webm', 'ts', 'm2ts', 'avi'],
  'videoCodecs': ['h264', 'hevc', 'vp8', 'vp9', 'av1', 'mpeg4', 'mpeg2video'],
  'audioCodecs': [
    'aac',
    'ac3',
    'eac3',
    'dts',
    'mp3',
    'opus',
    'vorbis',
    'flac',
    'truehd',
  ],
  'maxHeight': 2160,
  'supportsHls': true,
};

class SubtitleOffer {
  const SubtitleOffer({
    required this.providerFileId,
    required this.language,
    required this.release,
    required this.downloads,
    required this.hearingImpaired,
    required this.forced,
    required this.hashMatch,
  });

  factory SubtitleOffer.fromJson(Map<String, dynamic> json) => SubtitleOffer(
    providerFileId: json['providerFileId'] as String,
    language: json['language'] as String,
    release: json['release'] as String? ?? '',
    downloads: json['downloads'] as int? ?? 0,
    hearingImpaired: json['hearingImpaired'] as bool? ?? false,
    forced: json['forced'] as bool? ?? false,
    hashMatch: json['hashMatch'] as bool? ?? false,
  );

  final String providerFileId;
  final String language;
  final String release;
  final int downloads;
  final bool hearingImpaired;
  final bool forced;

  /// Timed for exactly this file.
  final bool hashMatch;
}

class PlaybackApi {
  PlaybackApi(this._client);

  final ServerClient _client;

  Future<PlaybackSession> start({
    required int fileId,
    required double startSeconds,
    int? audioStream,
    int? requestedHeight,
    Map<String, Object?>? preferences,
    Map<String, Object?> profile = phoneProfile,
  }) async => PlaybackSession.fromJson(
    await _client.post(
          '/api/playback/start',
          body: {
            'fileId': fileId,
            'startSeconds': startSeconds,
            'audioStream': audioStream,
            'profile': {...profile, 'requestedHeight': requestedHeight},
            'preferences': ?preferences,
          },
        )
        as Map<String, dynamic>,
  );

  Future<List<SubtitleOffer>> searchSubtitles(
    int fileId,
    String language,
  ) async => [
    for (final o
        in await _client.get(
              '/api/files/$fileId/subtitles/search',
              query: {'language': language},
            )
            as List)
      SubtitleOffer.fromJson(o as Map<String, dynamic>),
  ];

  Future<ExternalSubtitle> downloadSubtitle(
    int fileId,
    SubtitleOffer offer,
  ) async => ExternalSubtitle.fromJson(
    await _client.post(
          '/api/files/$fileId/subtitles/download',
          body: {
            'providerFileId': offer.providerFileId,
            'language': offer.language,
            'hearingImpaired': offer.hearingImpaired,
            'forced': offer.forced,
          },
        )
        as Map<String, dynamic>,
  );

  Future<void> reportSubtitle(int fileId, int subtitleId) =>
      _client.delete('/api/files/$fileId/external-subtitles/$subtitleId');

  Future<void> progress(
    String sessionId, {
    required double position,
    required double duration,
    required bool paused,
  }) => _client.post(
    '/api/playback/$sessionId/progress',
    body: {
      'positionSeconds': position,
      'durationSeconds': duration > 0 ? duration : null,
      'paused': paused,
    },
  );

  Future<void> stop(
    String sessionId, {
    required double position,
    required double duration,
  }) => _client.post(
    '/api/playback/$sessionId/stop',
    body: {
      'positionSeconds': position,
      'durationSeconds': duration > 0 ? duration : null,
    },
  );
}
