import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/models/collection_with_entries.dart';
import '../../../shared/widgets/poster_image.dart';
import '../application/collections_providers.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(allCollectionsProvider);
    final missingCount = ref.watch(totalMissingCountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Reihen')),
      body: collectionsAsync.when(
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(error: error),
        data: (collections) {
          if (collections.isEmpty) {
            return const EmptyState(
              icon: Icons.collections_bookmark_outlined,
              title: 'Noch keine Reihen erkannt',
              message:
                  'Sobald du einen Film aus einer Filmreihe speicherst, erscheint sie hier.',
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if ((missingCount.valueOrNull ?? 0) > 0)
                Card(
                  color: AppColors.dustyRose.withValues(alpha: 0.12),
                  child: ListTile(
                    onTap: () => context.push('/missing'),
                    leading: const Icon(
                      Icons.playlist_add_check_circle_outlined,
                      color: AppColors.dustyRose,
                    ),
                    title: Text(
                      'Dir fehlen ${missingCount.valueOrNull} Filme aus deinen Reihen.',
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                  ),
                ),
              const SizedBox(height: 12),
              for (final collection in collections)
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Card(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          context.push('/collections/${collection.id}'),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 64,
                              child: PosterImage(
                                posterPath: collection.posterPath,
                                borderRadius: 10,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    collection.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(6),
                                    child: LinearProgressIndicator(
                                      value: collection.progress,
                                      minHeight: 7,
                                      backgroundColor: AppColors.divider,
                                      color: AppColors.sage,
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    '${collection.ownedCount} / ${collection.totalCount} gekauft · ${collection.missingCount} fehlen',
                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.neutralGray,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
