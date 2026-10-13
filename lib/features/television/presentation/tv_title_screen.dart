import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../playback/domain/play_request.dart';
import '../../server/application/server_providers.dart';
import '../../server/domain/server_models.dart';
import '../../server/presentation/server_image.dart';
import 'tv_focusable.dart';

class TvTitleScreen extends ConsumerWidget {
  const TvTitleScreen({super.key, required this.titleId});

  final int titleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(serverTitleProvider(titleId));
    return TvPage(
      child: detail.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(serverTitleProvider(titleId)),
        ),
        data: (data) => _Body(detail: data),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.detail});

  final TitleDetail detail;

  ServerTitle get title => detail.title;

  void _refresh(WidgetRef ref) {
    ref.invalidate(serverTitleProvider(title.id));
    ref.invalidate(serverHomeProvider);
    if (title.isSeries) ref.invalidate(serverEpisodesProvider(title.id));
  }

  Future<void> _play(
    BuildContext context,
    WidgetRef ref,
    PlayRequest request,
  ) async {
    await context.push('/play', extra: request);
    _refresh(ref);
  }

  Future<void> _update(WidgetRef ref, Future<void> Function() action) async {
    await action();
    _refresh(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(libraryRepositoryProvider)!;
    final file = detail.preferredFile;
    final resume = detail.progress;
    final next = detail.next;
    final episodes = title.isSeries
        ? ref.watch(serverEpisodesProvider(title.id)).valueOrNull
        : null;
    final nextEpisode = next == null
        ? null
        : episodes?.where((e) => e.id == next.episodeId).firstOrNull;
    final nextFile = nextEpisode?.files.firstOrNull;
    final theme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 260,
          child: ServerImage(path: title.posterUrl, borderRadius: 16),
        ),
        const SizedBox(width: 40),
        Expanded(
          child: ListView(
            children: [
              Text(title.name, style: theme.headlineMedium),
              const SizedBox(height: 4),
              Text(
                [
                  if (title.year != null) '${title.year}',
                  if (title.runtimeMinutes != null)
                    '${title.runtimeMinutes} Min.',
                  if (title.rating != null && title.rating! > 0)
                    '★ ${title.rating!.toStringAsFixed(1)}',
                  if (title.isSeries) 'Serie',
                  ...title.genres.take(3),
                ].join(' · '),
                style: const TextStyle(color: AppColors.neutralGray),
              ),
              const SizedBox(height: 16),
              Wrap(
                spacing: 16,
                runSpacing: 12,
                children: [
                  if (!title.isSeries && file != null) ...[
                    TvButton(
                      label: resume.canResume
                          ? 'Fortsetzen ab ${formatClock(resume.positionSeconds)}'
                          : 'Abspielen',
                      icon: Icons.play_arrow,
                      primary: true,
                      autofocus: true,
                      onSelect: () => _play(
                        context,
                        ref,
                        PlayRequest(
                          fileId: resume.canResume && resume.fileId != null
                              ? resume.fileId!
                              : file.id,
                          titleId: title.id,
                          title: title.name,
                          startSeconds: resume.canResume
                              ? resume.positionSeconds
                              : 0,
                        ),
                      ),
                    ),
                    if (resume.canResume)
                      TvButton(
                        label: 'Von vorne',
                        icon: Icons.replay,
                        onSelect: () => _play(
                          context,
                          ref,
                          PlayRequest(
                            fileId: file.id,
                            titleId: title.id,
                            title: title.name,
                          ),
                        ),
                      ),
                  ],
                  if (title.isSeries && next != null && nextFile != null)
                    TvButton(
                      label:
                          '${next.positionSeconds > 5 ? 'Fortsetzen' : 'Weiter'}: S${next.season} E${next.number}',
                      icon: Icons.play_arrow,
                      primary: true,
                      autofocus: true,
                      onSelect: () => _play(
                        context,
                        ref,
                        PlayRequest(
                          fileId: nextFile.id,
                          titleId: title.id,
                          episodeId: next.episodeId,
                          title: title.name,
                          subtitle:
                              'S${next.season} E${next.number} · ${next.name}',
                          startSeconds: next.positionSeconds > 5
                              ? next.positionSeconds
                              : 0,
                        ),
                      ),
                    ),
                  TvButton(
                    label: 'Favorit',
                    icon: title.favorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    onSelect: () => _update(
                      ref,
                      () => repository.setFavorite(title.id, !title.favorite),
                    ),
                  ),
                  TvButton(
                    label: title.watched ? 'Gesehen' : 'Als gesehen markieren',
                    icon: title.watched
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    onSelect: () => _update(
                      ref,
                      () => repository.setWatched(
                        watched: !title.watched,
                        titleId: title.id,
                      ),
                    ),
                  ),
                ],
              ),
              if (detail.overview.isNotEmpty) ...[
                const SizedBox(height: 20),
                Text(detail.overview, maxLines: 6),
              ],
              if (title.isSeries) ...[
                const SizedBox(height: 24),
                _Episodes(titleId: title.id, titleName: title.name),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Episodes extends ConsumerStatefulWidget {
  const _Episodes({required this.titleId, required this.titleName});

  final int titleId;
  final String titleName;

  @override
  ConsumerState<_Episodes> createState() => _EpisodesState();
}

class _EpisodesState extends ConsumerState<_Episodes> {
  int? _season;

  @override
  Widget build(BuildContext context) {
    final episodes = ref.watch(serverEpisodesProvider(widget.titleId));
    return episodes.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(serverEpisodesProvider(widget.titleId)),
      ),
      data: (all) {
        final seasons = {for (final e in all) e.season}.toList()..sort();
        final season = seasons.contains(_season) ? _season! : seasons.first;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                for (final s in seasons)
                  TvButton(
                    label: s == 0 ? 'Specials' : 'Staffel $s',
                    primary: s == season,
                    onSelect: () => setState(() => _season = s),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            for (final episode in all.where((e) => e.season == season))
              _EpisodeTile(
                episode: episode,
                titleId: widget.titleId,
                titleName: widget.titleName,
              ),
          ],
        );
      },
    );
  }
}

class _EpisodeTile extends ConsumerWidget {
  const _EpisodeTile({
    required this.episode,
    required this.titleId,
    required this.titleName,
  });

  final ServerEpisode episode;
  final int titleId;
  final String titleName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = episode.progress;
    final file = episode.files.firstOrNull;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TvFocusable(
        onSelect: file == null
            ? null
            : () async {
                await context.push(
                  '/play',
                  extra: PlayRequest(
                    fileId: progress.canResume && progress.fileId != null
                        ? progress.fileId!
                        : file.id,
                    titleId: titleId,
                    episodeId: episode.id,
                    title: titleName,
                    subtitle:
                        'S${episode.season} E${episode.number} · ${episode.name}',
                    startSeconds: progress.canResume
                        ? progress.positionSeconds
                        : 0,
                  ),
                );
                ref.invalidate(serverEpisodesProvider(titleId));
                ref.invalidate(serverTitleProvider(titleId));
                ref.invalidate(serverHomeProvider);
              },
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 140,
                child: ServerImage(
                  path: episode.stillUrl,
                  aspectRatio: 16 / 9,
                  borderRadius: 10,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${episode.number}. ${episode.name}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      file == null
                          ? 'Nicht verfügbar'
                          : [
                              if (episode.runtimeMinutes != null)
                                '${episode.runtimeMinutes} Min.',
                              if (progress.watched) 'Gesehen',
                            ].join(' · '),
                      style: TextStyle(
                        color: file == null
                            ? AppColors.amber
                            : AppColors.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),
              if (progress.watched)
                const Icon(Icons.check_circle, color: AppColors.sage),
            ],
          ),
        ),
      ),
    );
  }
}
