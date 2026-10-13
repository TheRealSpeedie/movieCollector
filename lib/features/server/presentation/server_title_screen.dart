import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../playback/domain/play_request.dart';
import '../../remote/presentation/remote_screen.dart';
import '../application/server_providers.dart';
import '../domain/server_models.dart';
import 'server_image.dart';
import 'title_card.dart';

class ServerTitleScreen extends ConsumerWidget {
  const ServerTitleScreen({super.key, required this.titleId});

  final int titleId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final detail = ref.watch(serverTitleProvider(titleId));
    return Scaffold(
      body: detail.when(
        loading: () => const LoadingView(),
        error: (error, _) => SafeArea(
          child: Stack(
            children: [
              ErrorView(
                error: error,
                onRetry: () => ref.invalidate(serverTitleProvider(titleId)),
              ),
              const BackButton(),
            ],
          ),
        ),
        data: (data) => _TitleBody(detail: data),
      ),
    );
  }
}

class _TitleBody extends ConsumerWidget {
  const _TitleBody({required this.detail});

  final TitleDetail detail;

  ServerTitle get title => detail.title;

  void _refresh(WidgetRef ref) {
    ref.invalidate(serverTitleProvider(title.id));
    ref.invalidate(serverHomeProvider);
    if (title.isSeries) ref.invalidate(serverEpisodesProvider(title.id));
  }

  Future<void> _run(
    BuildContext context,
    WidgetRef ref,
    Future<void> Function() action,
  ) async {
    try {
      await action();
      _refresh(ref);
    } on Object catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(describeError(e))));
      }
    }
  }

  Future<void> _play(
    BuildContext context,
    WidgetRef ref,
    PlayRequest request,
  ) async {
    await context.push('/play', extra: request);
    _refresh(ref);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final repository = ref.read(libraryRepositoryProvider)!;
    final file = detail.preferredFile;
    final resume = detail.progress;
    final next = detail.next;

    return CustomScrollView(
      slivers: [
        SliverAppBar(
          pinned: true,
          expandedHeight: 220,
          backgroundColor: AppColors.background,
          actions: [
            IconButton(
              tooltip: 'Auf dem Fernseher öffnen',
              icon: const Icon(Icons.tv),
              onPressed: () => openOnTelevision(context, ref, title.id),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: ServerImage(
              path: detail.backdropUrl ?? title.posterUrl,
              aspectRatio: 16 / 9,
              borderRadius: 0,
            ),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.all(16),
          sliver: SliverList.list(
            children: [
              Text(
                title.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 4),
              Text(
                [
                  if (title.year != null) '${title.year}',
                  if (title.runtimeMinutes != null)
                    '${title.runtimeMinutes} Min.',
                  if (title.rating != null && title.rating! > 0)
                    '★ ${title.rating!.toStringAsFixed(1)}',
                  if (title.isSeries) 'Serie',
                ].join(' · '),
                style: const TextStyle(color: AppColors.neutralGray),
              ),
              if (detail.tagline.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  detail.tagline,
                  style: const TextStyle(
                    fontStyle: FontStyle.italic,
                    color: AppColors.neutralGray,
                  ),
                ),
              ],
              const SizedBox(height: 16),
              if (!title.isSeries && file != null) ...[
                SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    icon: const Icon(Icons.play_arrow),
                    label: Text(
                      resume.canResume
                          ? 'Fortsetzen ab ${formatClock(resume.positionSeconds)}'
                          : 'Abspielen',
                    ),
                    onPressed: () => _play(
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
                ),
                if (resume.canResume) ...[
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => _play(
                        context,
                        ref,
                        PlayRequest(
                          fileId: file.id,
                          titleId: title.id,
                          title: title.name,
                        ),
                      ),
                      child: const Text('Von vorne'),
                    ),
                  ),
                ],
              ],
              if (title.isSeries && next != null)
                _NextEpisodeButton(
                  titleId: title.id,
                  titleName: title.name,
                  next: next,
                  onPlay: (request) => _play(context, ref, request),
                ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _ToggleChip(
                    icon: title.favorite
                        ? Icons.favorite
                        : Icons.favorite_border,
                    label: 'Favorit',
                    active: title.favorite,
                    onTap: () => _run(
                      context,
                      ref,
                      () => repository.setFavorite(title.id, !title.favorite),
                    ),
                  ),
                  const SizedBox(width: 8),
                  _ToggleChip(
                    icon: title.watched
                        ? Icons.check_circle
                        : Icons.check_circle_outline,
                    label: title.watched ? 'Gesehen' : 'Als gesehen markieren',
                    active: title.watched,
                    onTap: () => _run(
                      context,
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
                Text(detail.overview),
              ],
              if (title.genres.isNotEmpty) ...[
                const SizedBox(height: 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final genre in title.genres) Chip(label: Text(genre)),
                  ],
                ),
              ],
              if (detail.cast.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(
                  'Besetzung',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  detail.cast.take(8).join(', '),
                  style: const TextStyle(color: AppColors.neutralGray),
                ),
              ],
              if (!title.isSeries && detail.files.length > 1) ...[
                const SizedBox(height: 20),
                Text(
                  'Versionen',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                for (final version in detail.files)
                  RadioListTile<int>(
                    contentPadding: EdgeInsets.zero,
                    value: version.id,
                    groupValue: file?.id,
                    title: Text(version.label),
                    subtitle: Text(
                      version.fileName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onChanged: (_) => _run(
                      context,
                      ref,
                      () => repository.chooseVersion(title.id, version.id),
                    ),
                  ),
              ],
              if (title.isSeries) ...[
                const SizedBox(height: 20),
                _Episodes(titleId: title.id, titleName: title.name),
              ],
              if (detail.related.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  'Aus derselben Reihe',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: detail.related.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => SizedBox(
                      width: 120,
                      child: TitleCard(title: detail.related[index]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  const _ToggleChip({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(
        icon,
        size: 18,
        color: active ? AppColors.dustyRose : AppColors.neutralGray,
      ),
      label: Text(label),
      onPressed: onTap,
    );
  }
}

class _NextEpisodeButton extends ConsumerWidget {
  const _NextEpisodeButton({
    required this.titleId,
    required this.titleName,
    required this.next,
    required this.onPlay,
  });

  final int titleId;
  final String titleName;
  final NextEpisode next;
  final void Function(PlayRequest request) onPlay;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final episodes = ref.watch(serverEpisodesProvider(titleId)).valueOrNull;
    final episode = episodes?.where((e) => e.id == next.episodeId).firstOrNull;
    final file = episode?.files.firstOrNull;
    final resumes = next.positionSeconds > 5;
    return SizedBox(
      width: double.infinity,
      child: FilledButton.icon(
        icon: const Icon(Icons.play_arrow),
        label: Text(
          '${resumes ? 'Fortsetzen' : 'Weiter'}: S${next.season} E${next.number}',
        ),
        onPressed: file == null
            ? null
            : () => onPlay(
                PlayRequest(
                  fileId: file.id,
                  titleId: titleId,
                  episodeId: next.episodeId,
                  title: titleName,
                  subtitle: 'S${next.season} E${next.number} · ${next.name}',
                  startSeconds: resumes ? next.positionSeconds : 0,
                ),
              ),
      ),
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
      loading: () =>
          const Padding(padding: EdgeInsets.all(24), child: LoadingView()),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(serverEpisodesProvider(widget.titleId)),
      ),
      data: (all) {
        final seasons = {for (final e in all) e.season}.toList()..sort();
        final season = seasons.contains(_season) ? _season! : seasons.first;
        final shown = all.where((e) => e.season == season).toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final s in seasons)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text(s == 0 ? 'Specials' : 'Staffel $s'),
                        selected: s == season,
                        onSelected: (_) => setState(() => _season = s),
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            for (final episode in shown)
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
    final fraction = progress.durationSeconds > 0
        ? progress.positionSeconds / progress.durationSeconds
        : 0.0;
    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: file == null
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
              },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 112,
                child: ServerImage(
                  path: episode.stillUrl,
                  aspectRatio: 16 / 9,
                  borderRadius: 10,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${episode.number}. ${episode.name}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (episode.runtimeMinutes != null)
                      Text(
                        '${episode.runtimeMinutes} Min.',
                        style: const TextStyle(
                          color: AppColors.neutralGray,
                          fontSize: 12,
                        ),
                      ),
                    if (file == null)
                      const Text(
                        'Nicht verfügbar',
                        style: TextStyle(color: AppColors.amber, fontSize: 12),
                      ),
                    if (!progress.watched && fraction > 0) ...[
                      const SizedBox(height: 6),
                      LinearProgressIndicator(
                        value: fraction.clamp(0, 1).toDouble(),
                        minHeight: 4,
                        backgroundColor: AppColors.divider,
                        color: AppColors.dustyRose,
                      ),
                    ],
                  ],
                ),
              ),
              IconButton(
                tooltip: progress.watched
                    ? 'Als ungesehen markieren'
                    : 'Als gesehen markieren',
                icon: Icon(
                  progress.watched
                      ? Icons.check_circle
                      : Icons.check_circle_outline,
                  color: progress.watched
                      ? AppColors.sage
                      : AppColors.neutralGray,
                ),
                onPressed: () async {
                  await ref
                      .read(libraryRepositoryProvider)!
                      .setWatched(
                        watched: !progress.watched,
                        episodeId: episode.id,
                      );
                  ref.invalidate(serverEpisodesProvider(titleId));
                  ref.invalidate(serverTitleProvider(titleId));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
