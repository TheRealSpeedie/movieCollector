class PlayRequest {
  const PlayRequest({
    required this.fileId,
    required this.titleId,
    required this.title,
    this.episodeId,
    this.subtitle,
    this.startSeconds = 0,
  });

  final int fileId;
  final int titleId;
  final int? episodeId;
  final String title;
  final String? subtitle;
  final double startSeconds;
}
