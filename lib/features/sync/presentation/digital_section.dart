import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../playback/domain/play_request.dart';
import '../../server/application/server_providers.dart';
import '../../server/domain/server_models.dart';
import '../application/sync_providers.dart';

/// "Auf deinem Server": every version of the film on the home server with
/// picture, audio languages and subtitles, playable from the movie page.
class DigitalSection extends ConsumerWidget {
  const DigitalSection({super.key, required this.tmdbId});

  final int tmdbId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(serverClientProvider) == null) {
      return const SizedBox.shrink();
    }
    if (!ref.watch(serverMoviesProvider).hasValue) {
      return const SizedBox.shrink();
    }
    final title = ref.watch(serverMovieByTmdbIdProvider(tmdbId));
    final detail = title == null
        ? null
        : ref.watch(serverTitleProvider(title.id)).valueOrNull;

    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Auf deinem Server',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (title == null)
            const Text(
              'Keine Datei in deiner Server-Bibliothek.',
              style: TextStyle(color: AppColors.neutralGray),
            )
          else if (detail == null)
            const LinearProgressIndicator()
          else ...[
            for (final file in detail.files)
              Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.play_circle_outline,
                    color: AppColors.sage,
                  ),
                  title: Text(_picture(file)),
                  subtitle: Text(_languages(file)),
                  isThreeLine: true,
                  onTap: () => context.push(
                    '/play',
                    extra: PlayRequest(
                      fileId: file.id,
                      titleId: title.id,
                      title: title.name,
                      startSeconds:
                          detail.progress.canResume &&
                              detail.progress.fileId == file.id
                          ? detail.progress.positionSeconds
                          : 0,
                    ),
                  ),
                ),
              ),
            Text(
              detail.progress.watched
                  ? 'Auf dem Server als gesehen markiert'
                  : detail.progress.canResume
                  ? 'Weiterschauen ab ${(detail.progress.positionSeconds / 60).round()} Min.'
                  : 'Noch nicht gesehen',
              style: const TextStyle(color: AppColors.neutralGray),
            ),
            TextButton(
              onPressed: () => context.push('/server/title/${title.id}'),
              child: const Text('Alles zum Film auf dem Server'),
            ),
          ],
        ],
      ),
    );
  }

  static String _picture(MediaFileInfo file) => [
    if (file.quality.isNotEmpty) file.quality,
    if (file.hdr) 'HDR',
    if (file.videoCodec != null) file.videoCodec!.toUpperCase(),
    '${(file.sizeBytes / 1e9).toStringAsFixed(1)} GB',
  ].join(' · ');

  static String _languages(MediaFileInfo file) {
    final audio = {
      for (final t in file.audioTracks) t.language ?? '?',
    }.join(', ');
    final subtitles = {
      for (final t in file.subtitleTracks) t.language ?? '?',
      for (final t in file.externalSubtitles) t.language ?? '?',
    }.join(', ');
    return [
      'Ton: ${audio.isEmpty ? 'unbekannt' : audio}',
      'Untertitel: ${subtitles.isEmpty ? 'keine' : subtitles}',
    ].join('\n');
  }
}
