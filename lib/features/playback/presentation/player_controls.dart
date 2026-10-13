import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart' as mk;

import '../../../app/theme/app_colors.dart';
import '../../server/domain/server_models.dart';

sealed class TrackChoice {
  const TrackChoice();
}

class EmbeddedAudio extends TrackChoice {
  const EmbeddedAudio(this.track);

  final mk.AudioTrack track;
}

class EmbeddedSubtitle extends TrackChoice {
  const EmbeddedSubtitle(this.track);

  final mk.SubtitleTrack track;
}

class ServerAudio extends TrackChoice {
  const ServerAudio(this.stream);

  final int stream;
}

class ServerSubtitle extends TrackChoice {
  const ServerSubtitle(this.stream);

  final int? stream;
}

class QualityChoice {
  const QualityChoice(this.height);

  final int? height;
}

class PlayerControls extends StatelessWidget {
  const PlayerControls({
    super.key,
    required this.title,
    required this.subtitle,
    required this.playing,
    required this.current,
    required this.total,
    required this.modeLabel,
    required this.onBack,
    required this.onPlayPause,
    required this.onSkip,
    required this.onTracks,
    required this.onQuality,
    required this.onDrag,
    required this.onDragEnd,
  });

  final String title;
  final String? subtitle;
  final bool playing;
  final double current;
  final double total;
  final String modeLabel;
  final VoidCallback onBack;
  final VoidCallback onPlayPause;
  final void Function(int seconds) onSkip;
  final VoidCallback onTracks;
  final VoidCallback onQuality;
  final ValueChanged<double> onDrag;
  final ValueChanged<double> onDragEnd;

  @override
  Widget build(BuildContext context) {
    final max = total > 0 ? total : 1.0;
    return Container(
      color: Colors.black54,
      child: SafeArea(
        child: Column(
          children: [
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  tooltip: 'Zurück',
                  onPressed: onBack,
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      if (subtitle != null)
                        Text(
                          subtitle!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    modeLabel,
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  iconSize: 36,
                  color: Colors.white,
                  tooltip: '10 Sekunden zurück',
                  icon: const Icon(Icons.replay_10),
                  onPressed: () => onSkip(-10),
                ),
                const SizedBox(width: 24),
                IconButton.filled(
                  iconSize: 44,
                  tooltip: playing ? 'Pause' : 'Abspielen',
                  icon: Icon(playing ? Icons.pause : Icons.play_arrow),
                  onPressed: onPlayPause,
                ),
                const SizedBox(width: 24),
                IconButton(
                  iconSize: 36,
                  color: Colors.white,
                  tooltip: '10 Sekunden vor',
                  icon: const Icon(Icons.forward_10),
                  onPressed: () => onSkip(10),
                ),
              ],
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Text(
                    formatClock(current),
                    style: const TextStyle(color: Colors.white),
                  ),
                  Expanded(
                    child: Slider(
                      value: current.clamp(0, max).toDouble(),
                      max: max,
                      onChanged: onDrag,
                      onChangeEnd: onDragEnd,
                    ),
                  ),
                  Text(
                    formatClock(total),
                    style: const TextStyle(color: Colors.white),
                  ),
                  IconButton(
                    color: Colors.white,
                    tooltip: 'Ton und Untertitel',
                    icon: const Icon(Icons.subtitles_outlined),
                    onPressed: onTracks,
                  ),
                  IconButton(
                    color: Colors.white,
                    tooltip: 'Qualität',
                    icon: const Icon(Icons.tune),
                    onPressed: onQuality,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrackSheet extends StatelessWidget {
  const TrackSheet({
    super.key,
    required this.file,
    required this.direct,
    required this.audio,
    required this.subtitles,
    required this.selectedAudio,
    required this.selectedSubtitle,
    required this.audioStream,
  });

  final MediaFileInfo file;
  final bool direct;
  final List<mk.AudioTrack> audio;
  final List<mk.SubtitleTrack> subtitles;
  final mk.AudioTrack selectedAudio;
  final mk.SubtitleTrack selectedSubtitle;
  final int? audioStream;

  static String _embeddedLabel(String id, String? title, String? language) {
    final name = title?.isNotEmpty == true ? title! : language;
    return name == null || name.isEmpty ? 'Spur $id' : name;
  }

  @override
  Widget build(BuildContext context) {
    final defaultAudio =
        file.audioTracks.where((t) => t.index == audioStream).firstOrNull ??
        file.audioTracks.firstOrNull;
    final textSubtitles = file.subtitleTracks.where((t) => t.text).toList();
    final hiddenSubtitles = file.subtitleTracks.length - textSubtitles.length;

    return SafeArea(
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          const _SheetTitle('Ton'),
          if (direct && audio.isEmpty || !direct && file.audioTracks.isEmpty)
            const _SheetNote('Diese Datei hat nur eine Tonspur.'),
          if (direct)
            for (final track in audio)
              ListTile(
                leading: Icon(
                  track.id == selectedAudio.id
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.dustyRose,
                ),
                title: Text(
                  _embeddedLabel(track.id, track.title, track.language),
                ),
                onTap: () => Navigator.of(context).pop(EmbeddedAudio(track)),
              )
          else
            for (final track in file.audioTracks)
              ListTile(
                leading: Icon(
                  track.index == defaultAudio?.index
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.dustyRose,
                ),
                title: Text(track.label),
                onTap: () =>
                    Navigator.of(context).pop(ServerAudio(track.index)),
              ),
          const Divider(),
          const _SheetTitle('Untertitel'),
          ListTile(
            leading: Icon(
              direct
                  ? (selectedSubtitle.id == 'no'
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off)
                  : Icons.radio_button_off,
              color: AppColors.dustyRose,
            ),
            title: const Text('Aus'),
            onTap: () => Navigator.of(context).pop(
              direct
                  ? EmbeddedSubtitle(mk.SubtitleTrack.no())
                  : const ServerSubtitle(null),
            ),
          ),
          if (direct)
            for (final track in subtitles)
              ListTile(
                leading: Icon(
                  track.id == selectedSubtitle.id
                      ? Icons.radio_button_checked
                      : Icons.radio_button_off,
                  color: AppColors.dustyRose,
                ),
                title: Text(
                  _embeddedLabel(track.id, track.title, track.language),
                ),
                onTap: () => Navigator.of(context).pop(EmbeddedSubtitle(track)),
              )
          else ...[
            for (final track in textSubtitles)
              ListTile(
                leading: const Icon(
                  Icons.radio_button_off,
                  color: AppColors.dustyRose,
                ),
                title: Text(track.label),
                onTap: () =>
                    Navigator.of(context).pop(ServerSubtitle(track.index)),
              ),
            if (hiddenSubtitles > 0)
              const _SheetNote(
                'Bildbasierte Untertitel sind bei umgewandelter Wiedergabe nicht verfügbar.',
              ),
          ],
        ],
      ),
    );
  }
}

class QualitySheet extends StatelessWidget {
  const QualitySheet({
    super.key,
    required this.current,
    required this.sourceHeight,
    required this.description,
    required this.reason,
  });

  final int? current;
  final int sourceHeight;
  final String description;
  final String reason;

  @override
  Widget build(BuildContext context) {
    final steps = [
      for (final h in const [1080, 720, 480])
        if (sourceHeight == 0 || h < sourceHeight) h,
    ];
    return SafeArea(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _SheetTitle('Qualität'),
          _SheetNote('Aktuell: $description. $reason'),
          for (final height in [null, ...steps])
            ListTile(
              leading: Icon(
                height == current
                    ? Icons.radio_button_checked
                    : Icons.radio_button_off,
                color: AppColors.dustyRose,
              ),
              title: Text(height == null ? 'Original' : '${height}p'),
              subtitle: height == null
                  ? const Text(
                      'Beste Qualität, wenn das Gerät sie abspielen kann',
                    )
                  : const Text('Spart Datenrate im WLAN'),
              onTap: () => Navigator.of(context).pop(QualityChoice(height)),
            ),
        ],
      ),
    );
  }
}

class _SheetTitle extends StatelessWidget {
  const _SheetTitle(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
    child: Text(text, style: Theme.of(context).textTheme.titleMedium),
  );
}

class _SheetNote extends StatelessWidget {
  const _SheetNote(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
    child: Text(
      text,
      style: const TextStyle(color: AppColors.neutralGray, fontSize: 13),
    ),
  );
}
