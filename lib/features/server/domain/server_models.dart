class WatchState {
  const WatchState({
    this.watched = false,
    this.positionSeconds = 0,
    this.durationSeconds = 0,
    this.fileId,
  });

  factory WatchState.fromJson(Map<String, dynamic>? json) => json == null
      ? const WatchState()
      : WatchState(
          watched: json['watched'] as bool? ?? false,
          positionSeconds: (json['positionSeconds'] as num?)?.toDouble() ?? 0,
          durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0,
          fileId: json['fileId'] as int?,
        );

  final bool watched;
  final double positionSeconds;
  final double durationSeconds;
  final int? fileId;

  bool get canResume => !watched && positionSeconds > 5;
}

class AudioTrack {
  const AudioTrack({
    required this.index,
    required this.language,
    required this.title,
    required this.codec,
    required this.channels,
  });

  factory AudioTrack.fromJson(Map<String, dynamic> json) => AudioTrack(
    index: json['index'] as int,
    language: json['language'] as String?,
    title: json['title'] as String?,
    codec: json['codec'] as String?,
    channels: json['channels'] as int?,
  );

  final int index;
  final String? language;
  final String? title;
  final String? codec;
  final int? channels;

  String get label {
    final name = title?.isNotEmpty == true ? title! : language ?? 'Audio';
    return [
      name,
      codec?.toUpperCase(),
      if (channels != null) '${channels}ch',
    ].whereType<String>().join(' · ');
  }
}

class SubtitleTrack {
  const SubtitleTrack({
    required this.index,
    required this.language,
    required this.title,
    required this.forced,
    required this.text,
  });

  factory SubtitleTrack.fromJson(Map<String, dynamic> json) => SubtitleTrack(
    index: json['index'] as int,
    language: json['language'] as String?,
    title: json['title'] as String?,
    forced: json['forced'] as bool? ?? false,
    text: json['text'] as bool? ?? false,
  );

  final int index;
  final String? language;
  final String? title;
  final bool forced;
  final bool text;

  String get label {
    final name = title?.isNotEmpty == true ? title! : language ?? 'Untertitel';
    return forced ? '$name (erzwungen)' : name;
  }
}

/// A subtitle file next to the video or downloaded from a provider.
class ExternalSubtitle {
  const ExternalSubtitle({
    required this.id,
    required this.language,
    required this.forced,
    required this.hearingImpaired,
    required this.source,
    required this.fileName,
  });

  factory ExternalSubtitle.fromJson(Map<String, dynamic> json) =>
      ExternalSubtitle(
        id: json['id'] as int,
        language: json['language'] as String?,
        forced: json['forced'] as bool? ?? false,
        hearingImpaired: json['hearingImpaired'] as bool? ?? false,
        source: json['source'] as String? ?? 'sidecar',
        fileName: json['fileName'] as String? ?? '',
      );

  final int id;
  final String? language;
  final bool forced;
  final bool hearingImpaired;
  final String source;
  final String fileName;

  bool get downloaded => source != 'sidecar';

  String get label => [
    language ?? 'Untertitel',
    if (forced) '(erzwungen)',
    if (hearingImpaired) '(für Hörgeschädigte)',
    downloaded ? '· heruntergeladen' : '· Datei',
  ].join(' ');
}

class MediaFileInfo {
  const MediaFileInfo({
    required this.id,
    required this.fileName,
    required this.quality,
    required this.container,
    required this.videoCodec,
    required this.audioCodec,
    required this.height,
    required this.hdr,
    required this.sizeBytes,
    required this.durationSeconds,
    required this.audioTracks,
    required this.subtitleTracks,
    this.externalSubtitles = const [],
  });

  factory MediaFileInfo.fromJson(Map<String, dynamic> json) => MediaFileInfo(
    id: json['id'] as int,
    fileName: json['fileName'] as String,
    quality: json['quality'] as String? ?? '',
    container: json['container'] as String? ?? '',
    videoCodec: json['videoCodec'] as String?,
    audioCodec: json['audioCodec'] as String?,
    height: json['height'] as int? ?? 0,
    hdr: json['hdr'] as bool? ?? false,
    sizeBytes: json['sizeBytes'] as int? ?? 0,
    durationSeconds: (json['durationSeconds'] as num?)?.toDouble() ?? 0,
    audioTracks: [
      for (final t in json['audioTracks'] as List? ?? [])
        AudioTrack.fromJson(t as Map<String, dynamic>),
    ],
    subtitleTracks: [
      for (final t in json['subtitleTracks'] as List? ?? [])
        SubtitleTrack.fromJson(t as Map<String, dynamic>),
    ],
    externalSubtitles: [
      for (final t in json['externalSubtitles'] as List? ?? [])
        ExternalSubtitle.fromJson(t as Map<String, dynamic>),
    ],
  );

  final int id;
  final String fileName;
  final String quality;
  final String container;
  final String? videoCodec;
  final String? audioCodec;
  final int height;
  final bool hdr;
  final int sizeBytes;
  final double durationSeconds;
  final List<AudioTrack> audioTracks;
  final List<SubtitleTrack> subtitleTracks;
  final List<ExternalSubtitle> externalSubtitles;

  String get label => [
    if (quality.isNotEmpty) quality,
    if (hdr) 'HDR',
    videoCodec?.toUpperCase(),
    container.toUpperCase(),
    formatBytes(sizeBytes),
  ].whereType<String>().join(' · ');
}

String formatBytes(int bytes) {
  if (bytes <= 0) return '';
  const gigabyte = 1024 * 1024 * 1024;
  if (bytes >= gigabyte) return '${(bytes / gigabyte).toStringAsFixed(1)} GB';
  return '${(bytes / (1024 * 1024)).round()} MB';
}

String formatClock(double seconds) {
  final total = seconds.round();
  final h = total ~/ 3600;
  final m = (total % 3600) ~/ 60;
  final s = total % 60;
  final mm = m.toString().padLeft(2, '0');
  final ss = s.toString().padLeft(2, '0');
  return h > 0 ? '$h:$mm:$ss' : '$m:$ss';
}

class ServerTitle {
  const ServerTitle({
    required this.id,
    required this.isSeries,
    required this.tmdbId,
    required this.name,
    required this.year,
    required this.posterUrl,
    required this.runtimeMinutes,
    required this.genres,
    required this.rating,
    required this.qualities,
    required this.favorite,
    required this.watched,
    required this.fraction,
    required this.watchedEpisodes,
    required this.totalEpisodes,
  });

  factory ServerTitle.fromJson(Map<String, dynamic> json) {
    final progress = json['progress'] as Map<String, dynamic>?;
    return ServerTitle(
      id: json['id'] as int,
      isSeries: json['kind'] == 'Series',
      tmdbId: json['tmdbId'] as int?,
      name: json['name'] as String,
      year: json['year'] as int?,
      posterUrl: json['posterUrl'] as String?,
      runtimeMinutes: json['runtimeMinutes'] as int?,
      genres: List<String>.from(json['genres'] as List? ?? []),
      rating: (json['rating'] as num?)?.toDouble(),
      qualities: List<String>.from(json['qualities'] as List? ?? []),
      favorite: json['favorite'] as bool? ?? false,
      watched: progress?['watched'] as bool? ?? false,
      fraction: (progress?['fraction'] as num?)?.toDouble() ?? 0,
      watchedEpisodes: progress?['watchedEpisodes'] as int? ?? 0,
      totalEpisodes: progress?['totalEpisodes'] as int? ?? 0,
    );
  }

  final int id;
  final bool isSeries;
  final int? tmdbId;
  final String name;
  final int? year;
  final String? posterUrl;
  final int? runtimeMinutes;
  final List<String> genres;
  final double? rating;
  final List<String> qualities;
  final bool favorite;
  final bool watched;
  final double fraction;
  final int watchedEpisodes;
  final int totalEpisodes;
}

class TitlePage {
  const TitlePage({required this.total, required this.items});

  final int total;
  final List<ServerTitle> items;
}

class ResumeItem {
  const ResumeItem({
    required this.isNext,
    required this.titleId,
    required this.episodeId,
    required this.fileId,
    required this.name,
    required this.subtitle,
    required this.posterUrl,
    required this.backdropUrl,
    required this.positionSeconds,
    required this.durationSeconds,
  });

  factory ResumeItem.fromJson(Map<String, dynamic> json) => ResumeItem(
    isNext: json['kind'] == 'next',
    titleId: json['titleId'] as int,
    episodeId: json['episodeId'] as int?,
    fileId: json['fileId'] as int,
    name: json['name'] as String,
    subtitle: json['subtitle'] as String?,
    posterUrl: json['posterUrl'] as String?,
    backdropUrl: json['backdropUrl'] as String?,
    positionSeconds: (json['positionSeconds'] as num).toDouble(),
    durationSeconds: (json['durationSeconds'] as num).toDouble(),
  );

  final bool isNext;
  final int titleId;
  final int? episodeId;
  final int fileId;
  final String name;
  final String? subtitle;
  final String? posterUrl;
  final String? backdropUrl;
  final double positionSeconds;
  final double durationSeconds;

  double get fraction =>
      durationSeconds > 0 ? (positionSeconds / durationSeconds).clamp(0, 1) : 0;
}

class HomeData {
  const HomeData({required this.resume, required this.recent});

  factory HomeData.fromJson(Map<String, dynamic> json) => HomeData(
    resume: [
      for (final item in json['continueWatching'] as List)
        ResumeItem.fromJson(item as Map<String, dynamic>),
    ],
    recent: [
      for (final item in json['recentlyAdded'] as List)
        ServerTitle.fromJson(item as Map<String, dynamic>),
    ],
  );

  final List<ResumeItem> resume;
  final List<ServerTitle> recent;
}

class SeasonSummary {
  const SeasonSummary({
    required this.season,
    required this.episodes,
    required this.watched,
  });

  final int season;
  final int episodes;
  final int watched;
}

class NextEpisode {
  const NextEpisode({
    required this.episodeId,
    required this.season,
    required this.number,
    required this.name,
    required this.positionSeconds,
  });

  final int episodeId;
  final int season;
  final int number;
  final String name;
  final double positionSeconds;
}

class TitleDetail {
  const TitleDetail({
    required this.title,
    required this.originalName,
    required this.overview,
    required this.tagline,
    required this.backdropUrl,
    required this.cast,
    required this.related,
    required this.files,
    required this.preferredFileId,
    required this.progress,
    required this.seasons,
    required this.next,
  });

  factory TitleDetail.fromJson(Map<String, dynamic> json) {
    final movie = json['movie'] as Map<String, dynamic>?;
    final series = json['series'] as Map<String, dynamic>?;
    final next = series?['next'] as Map<String, dynamic>?;
    return TitleDetail(
      title: ServerTitle.fromJson(json),
      originalName: json['originalName'] as String?,
      overview: json['overview'] as String? ?? '',
      tagline: json['tagline'] as String? ?? '',
      backdropUrl: json['backdropUrl'] as String?,
      cast: [
        for (final c in json['cast'] as List? ?? [])
          (c as Map<String, dynamic>)['name'] as String,
      ],
      related: [
        for (final t in json['collectionTitles'] as List? ?? [])
          ServerTitle.fromJson(t as Map<String, dynamic>),
      ],
      files: [
        for (final f in movie?['files'] as List? ?? [])
          MediaFileInfo.fromJson(f as Map<String, dynamic>),
      ],
      preferredFileId: movie?['preferredFileId'] as int?,
      progress: WatchState.fromJson(
        movie?['progress'] as Map<String, dynamic>?,
      ),
      seasons: [
        for (final s in series?['seasons'] as List? ?? [])
          SeasonSummary(
            season: (s as Map<String, dynamic>)['season'] as int,
            episodes: s['episodes'] as int,
            watched: s['watched'] as int,
          ),
      ],
      next: next == null
          ? null
          : NextEpisode(
              episodeId: next['episodeId'] as int,
              season: next['season'] as int,
              number: next['number'] as int,
              name: next['name'] as String,
              positionSeconds: (next['positionSeconds'] as num).toDouble(),
            ),
    );
  }

  final ServerTitle title;
  final String? originalName;
  final String overview;
  final String tagline;
  final String? backdropUrl;
  final List<String> cast;
  final List<ServerTitle> related;
  final List<MediaFileInfo> files;
  final int? preferredFileId;
  final WatchState progress;
  final List<SeasonSummary> seasons;
  final NextEpisode? next;

  MediaFileInfo? get preferredFile =>
      files.where((f) => f.id == preferredFileId).firstOrNull ??
      files.firstOrNull;
}

class ServerEpisode {
  const ServerEpisode({
    required this.id,
    required this.season,
    required this.number,
    required this.name,
    required this.overview,
    required this.stillUrl,
    required this.runtimeMinutes,
    required this.files,
    required this.progress,
  });

  factory ServerEpisode.fromJson(Map<String, dynamic> json) => ServerEpisode(
    id: json['id'] as int,
    season: json['season'] as int,
    number: json['number'] as int,
    name: json['name'] as String,
    overview: json['overview'] as String? ?? '',
    stillUrl: json['stillUrl'] as String?,
    runtimeMinutes: json['runtimeMinutes'] as int?,
    files: [
      for (final f in json['files'] as List? ?? [])
        MediaFileInfo.fromJson(f as Map<String, dynamic>),
    ],
    progress: WatchState.fromJson(json['progress'] as Map<String, dynamic>?),
  );

  final int id;
  final int season;
  final int number;
  final String name;
  final String overview;
  final String? stillUrl;
  final int? runtimeMinutes;
  final List<MediaFileInfo> files;
  final WatchState progress;
}
