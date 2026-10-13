class PlaybackSession {
  const PlaybackSession({
    required this.id,
    required this.mode,
    required this.reason,
    required this.quality,
    required this.url,
    required this.offsetSeconds,
    required this.durationSeconds,
  });

  factory PlaybackSession.fromJson(Map<String, dynamic> json) =>
      PlaybackSession(
        id: json['sessionId'] as String,
        mode: json['mode'] as String,
        reason: json['reason'] as String,
        quality: json['quality'] as String,
        url: json['url'] as String,
        offsetSeconds: (json['offsetSeconds'] as num).toDouble(),
        durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0,
      );

  final String id;
  final String mode;
  final String reason;
  final String quality;
  final String url;
  final double offsetSeconds;
  final double durationSeconds;

  bool get isDirect => mode == 'DirectPlay';

  String get modeLabel => switch (mode) {
    'DirectPlay' => 'Original',
    'Remux' => 'Umgepackt',
    _ => 'Umgewandelt ($quality)',
  };

  double absolutePosition(Duration playerPosition) =>
      offsetSeconds + playerPosition.inMilliseconds / 1000;

  bool needsRestartToReach(double target, Duration generated) {
    if (isDirect) return false;
    final relative = target - offsetSeconds;
    return relative < 0 || relative > generated.inMilliseconds / 1000 - 4;
  }

  Duration relativeSeek(double target) => Duration(
    milliseconds: ((target - offsetSeconds) * 1000).round().clamp(0, 1 << 40),
  );
}
