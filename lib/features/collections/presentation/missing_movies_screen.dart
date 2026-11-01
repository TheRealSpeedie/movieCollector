import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/poster_image.dart';
import '../application/collections_providers.dart';
import '../application/franchise_gaps.dart';

class MissingMoviesScreen extends ConsumerWidget {
  const MissingMoviesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(missingMoviesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fehlende Filme')),
      body: groupsAsync.when(
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(error: error),
        data: (groups) {
          if (groups.isEmpty) {
            return _NothingMissing(gaps: ref.watch(franchiseGapsProvider));
          }
          final total = groups.fold<int>(
            0,
            (sum, g) => sum + g.missingEntries.length,
          );
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Dir fehlen $total Filme aus deinen Reihen.',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              for (final group in groups) ...[
                GestureDetector(
                  onTap: () =>
                      context.push('/collections/${group.collection.id}'),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          group.collection.name,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: context.colors.textSecondary,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                for (final entry in group.missingEntries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 42,
                              child: PosterImage(
                                posterPath: entry.posterPath,
                                borderRadius: 8,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    entry.title,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  if (entry.releaseDate != null)
                                    Text(
                                      '${entry.releaseDate!.year}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: context.colors.textSecondary,
                                      ),
                                    ),
                                ],
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () async {
                                final messenger = ScaffoldMessenger.of(context);
                                try {
                                  await ref
                                      .read(movieRepositoryProvider)
                                      .addFromTmdb(
                                        entry.tmdbMovieId,
                                        status: CollectionStatus.wishlist,
                                      );
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Zur Wunschliste hinzugefügt.',
                                      ),
                                    ),
                                  );
                                } catch (_) {
                                  messenger.showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Das hat leider nicht geklappt.',
                                      ),
                                    ),
                                  );
                                }
                              },
                              icon: Icon(
                                Icons.favorite_border,
                                size: 18,
                                color: context.colors.accent,
                              ),
                              label: const Text('Wunschliste'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: 16),
              ],
            ],
          );
        },
      ),
    );
  }
}

/// Why the list is empty. "Nothing missing" only when series are known.
class _NothingMissing extends StatelessWidget {
  const _NothingMissing({required this.gaps});

  final FranchiseGaps gaps;

  @override
  Widget build(BuildContext context) {
    return switch (gaps) {
      FranchiseGapsComplete(:final seriesCount) => EmptyState(
        icon: Icons.playlist_add_check_circle_outlined,
        title: 'Dir fehlt nichts',
        message: seriesCount == 1
            ? 'Deine Reihe ist vollständig.'
            : 'Alle $seriesCount Reihen in deinem Regal sind vollständig.',
      ),
      FranchiseGapsNoMovies() => EmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'Noch keine Filme im Regal',
        message:
            'Sobald du Filme hinzufügst, zeigt Speednema hier, welche Teile '
            'ihrer Reihen dir fehlen.',
        action: FilledButton(
          onPressed: () => context.push('/search'),
          child: const Text('Film hinzufügen'),
        ),
      ),
      FranchiseGapsNotConfigured() => const EmptyState(
        icon: Icons.cloud_off_outlined,
        title: 'Filminfos sind nicht eingerichtet',
        message:
            'Ohne Filminfos von TMDB erkennt Speednema nicht, welche Filme zu '
            'einer Reihe gehören. Deine Sammlung funktioniert trotzdem.',
      ),
      _ => const EmptyState(
        icon: Icons.playlist_add_check_circle_outlined,
        title: 'Noch keine Reihen erkannt',
        message:
            'Sobald ein Film zu einer Reihe gehört, siehst du hier, welche '
            'Teile dir fehlen.',
      ),
    };
  }
}
