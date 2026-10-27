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
import '../application/tv_providers.dart';
import 'tv_focusable.dart';

class TvHomeScreen extends ConsumerWidget {
  const TvHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(serverHomeProvider);
    final serverName = ref.watch(serverSessionProvider).valueOrNull?.serverName;
    return TvPage(
      child: home.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(serverHomeProvider),
        ),
        data: (data) => ListView(
          children: [
            _Header(serverName: serverName ?? 'Movie Shelf'),
            if (data.resume.isNotEmpty)
              _Row(
                title: 'Weiter schauen',
                height: 190,
                children: [
                  for (final (i, item) in data.resume.indexed)
                    TvResumeTile(item: item, autofocus: i == 0),
                ],
              ),
            if (data.recent.isNotEmpty)
              _Row(
                title: 'Zuletzt hinzugefügt',
                height: 300,
                children: [
                  for (final (i, title) in data.recent.indexed)
                    TvPosterTile(
                      title: title,
                      autofocus: i == 0 && data.resume.isEmpty,
                    ),
                ],
              ),
            const _TitleRow(title: 'Filme', kind: 'Movie'),
            const _TitleRow(title: 'Serien', kind: 'Series'),
          ],
        ),
      ),
    );
  }
}

class _Header extends ConsumerWidget {
  const _Header({required this.serverName});

  final String serverName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          const Icon(Icons.movie_outlined, color: AppColors.dustyRose),
          const SizedBox(width: 12),
          Text(serverName, style: Theme.of(context).textTheme.titleLarge),
          const Spacer(),
          TvButton(
            label: 'Trennen',
            icon: Icons.link_off,
            onSelect: () => _confirm(context, ref),
          ),
        ],
      ),
    );
  }

  Future<void> _confirm(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verbindung trennen?'),
        content: const Text(
          'Der Fernseher wird beim Server abgemeldet und muss neu gekoppelt werden.',
        ),
        actions: [
          TextButton(
            autofocus: true,
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Trennen'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(serverSessionProvider.notifier).disconnect();
    }
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.title,
    required this.height,
    required this.children,
  });

  final String title;
  final double height;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 12),
          SizedBox(
            height: height,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              itemCount: children.length,
              separatorBuilder: (_, _) => const SizedBox(width: 16),
              itemBuilder: (_, index) => children[index],
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleRow extends ConsumerWidget {
  const _TitleRow({required this.title, required this.kind});

  final String title;
  final String kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titles = ref.watch(tvTitlesProvider(kind));
    return titles.when(
      loading: () => const SizedBox(height: 120, child: LoadingView()),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(tvTitlesProvider(kind)),
      ),
      data: (items) => items.isEmpty
          ? const SizedBox.shrink()
          : _Row(
              title: title,
              height: 300,
              children: [for (final item in items) TvPosterTile(title: item)],
            ),
    );
  }
}

class TvPosterTile extends StatelessWidget {
  const TvPosterTile({super.key, required this.title, this.autofocus = false});

  final ServerTitle title;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    final progress = title.isSeries
        ? (title.totalEpisodes == 0
              ? 0.0
              : title.watchedEpisodes / title.totalEpisodes)
        : title.fraction;
    return SizedBox(
      width: 160,
      child: TvFocusable(
        autofocus: autofocus,
        onSelect: () => context.push('/title/${title.id}'),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  ServerImage(path: title.posterUrl),
                  if (title.watched)
                    const Positioned(
                      top: 6,
                      right: 6,
                      child: CircleAvatar(
                        radius: 12,
                        backgroundColor: AppColors.sage,
                        child: Icon(
                          Icons.check,
                          size: 16,
                          color: AppColors.background,
                        ),
                      ),
                    ),
                  if (!title.watched && progress > 0)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: LinearProgressIndicator(
                        value: progress.clamp(0, 1).toDouble(),
                        minHeight: 5,
                        backgroundColor: Colors.black54,
                        color: AppColors.dustyRose,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            Text(
              [
                if (title.year != null) '${title.year}',
                if (title.isSeries) 'Serie',
              ].join(' · '),
              style: const TextStyle(color: AppColors.neutralGray),
            ),
          ],
        ),
      ),
    );
  }
}

class TvResumeTile extends StatelessWidget {
  const TvResumeTile({super.key, required this.item, required this.autofocus});

  final ResumeItem item;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: TvFocusable(
        autofocus: autofocus,
        onSelect: () => context.push(
          '/play',
          extra: PlayRequest(
            fileId: item.fileId,
            titleId: item.titleId,
            episodeId: item.episodeId,
            title: item.name,
            subtitle: item.subtitle,
            startSeconds: item.positionSeconds,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            ServerImage(
              path: item.backdropUrl ?? item.posterUrl,
              aspectRatio: 16 / 9,
              borderRadius: 11,
            ),
            Container(color: Colors.black38),
            const Center(
              child: Icon(
                Icons.play_circle_outline,
                size: 48,
                color: Colors.white,
              ),
            ),
            Positioned(
              left: 12,
              right: 12,
              bottom: 12,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    item.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    item.isNext
                        ? 'Als Nächstes: ${item.subtitle ?? ''}'
                        : item.subtitle ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            if (!item.isNext)
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: LinearProgressIndicator(
                  value: item.fraction.toDouble(),
                  minHeight: 5,
                  backgroundColor: Colors.black54,
                  color: AppColors.dustyRose,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
