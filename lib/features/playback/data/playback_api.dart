import '../../server/data/server_client.dart';
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

class PlaybackApi {
  PlaybackApi(this._client);

  final ServerClient _client;

  Future<PlaybackSession> start({
    required int fileId,
    required double startSeconds,
    int? audioStream,
    int? requestedHeight,
    Map<String, Object?> profile = phoneProfile,
  }) async => PlaybackSession.fromJson(
    await _client.post(
          '/api/playback/start',
          body: {
            'fileId': fileId,
            'startSeconds': startSeconds,
            'audioStream': audioStream,
            'profile': {...profile, 'requestedHeight': requestedHeight},
          },
        )
        as Map<String, dynamic>,
  );

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
