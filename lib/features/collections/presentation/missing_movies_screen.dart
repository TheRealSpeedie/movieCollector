import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/poster_image.dart';
import '../application/collections_providers.dart';

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
            return const EmptyState(
              icon: Icons.playlist_add_check_circle_outlined,
              title: 'Dir fehlt nichts',
              message:
                  'In deinen bekannten Reihen sind aktuell keine Filme offen.',
            );
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
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: AppColors.neutralGray,
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
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.neutralGray,
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
                              icon: const Icon(
                                Icons.favorite_border,
                                size: 18,
                                color: AppColors.dustyRose,
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
