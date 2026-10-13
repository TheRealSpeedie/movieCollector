class PlayerSnapshot {
  const PlayerSnapshot({
    this.titleId,
    this.episodeId,
    this.title,
    this.subtitle,
    this.positionSeconds = 0,
    this.durationSeconds = 0,
    this.playing = false,
    this.status = 'idle',
  });

  factory PlayerSnapshot.fromJson(Map<String, dynamic> json) => PlayerSnapshot(
    titleId: json['titleId'] as int?,
    episodeId: json['episodeId'] as int?,
    title: json['title'] as String?,
    subtitle: json['subtitle'] as String?,
    positionSeconds: (json['positionSeconds'] as num?)?.toDouble() ?? 0,
    durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0,
    playing: json['playing'] as bool? ?? false,
    status: json['status'] as String? ?? 'idle',
  );

  final int? titleId;
  final int? episodeId;
  final String? title;
  final String? subtitle;
  final double positionSeconds;
  final double durationSeconds;
  final bool playing;
  final String status;

  bool get active => status != 'idle';

  double get fraction => durationSeconds > 0
      ? (positionSeconds / durationSeconds).clamp(0, 1).toDouble()
      : 0;

  Map<String, dynamic> toJson() => {
    'titleId': titleId,
    'episodeId': episodeId,
    'title': title,
    'subtitle': subtitle,
    'positionSeconds': positionSeconds,
    'durationSeconds': durationSeconds,
    'playing': playing,
    'status': status,
  };
}

class RemotePlayer {
  const RemotePlayer({
    required this.deviceId,
    required this.name,
    required this.state,
  });

  factory RemotePlayer.fromJson(Map<String, dynamic> json) => RemotePlayer(
    deviceId: json['deviceId'] as String,
    name: json['name'] as String,
    state: json['state'] == null
        ? const PlayerSnapshot()
        : PlayerSnapshot.fromJson(json['state'] as Map<String, dynamic>),
  );

  final String deviceId;
  final String name;
  final PlayerSnapshot state;
}

class RemoteCommand {
  const RemoteCommand({
    required this.command,
    this.seconds,
    this.titleId,
    this.episodeId,
  });

  factory RemoteCommand.fromJson(Map<String, dynamic> json) => RemoteCommand(
    command: json['command'] as String,
    seconds: (json['seconds'] as num?)?.toDouble(),
    titleId: json['titleId'] as int?,
    episodeId: json['episodeId'] as int?,
  );

  final String command;
  final double? seconds;
  final int? titleId;
  final int? episodeId;
}
