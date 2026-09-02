import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/collection_with_entries.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../../shared/widgets/status_chip.dart';
import '../application/collections_providers.dart';

class CollectionDetailScreen extends ConsumerWidget {
  const CollectionDetailScreen({super.key, required this.collectionId});

  final int collectionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionAsync = ref.watch(collectionByIdProvider(collectionId));

    return Scaffold(
      appBar: AppBar(title: const Text('Reihe')),
      body: collectionAsync.when(
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(error: error),
        data: (collection) {
          if (collection == null) {
            return const Center(
              child: Text('Diese Reihe wurde nicht gefunden.'),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                collection.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              if (collection.overview != null &&
                  collection.overview!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  collection.overview!,
                  style: const TextStyle(color: AppColors.neutralGray),
                ),
              ],
              const SizedBox(height: 16),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: collection.progress,
                  minHeight: 8,
                  backgroundColor: AppColors.divider,
                  color: AppColors.sage,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '${collection.ownedCount} / ${collection.totalCount} gekauft',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 20),
              for (final entry in collection.entries)
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: _CollectionEntryTile(entry: entry),
                ),
            ],
          );
        },
      ),
    );
  }
}

class _CollectionEntryTile extends ConsumerWidget {
  const _CollectionEntryTile({required this.entry});

  final CollectionEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final localMovie = entry.localMovie;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: localMovie != null
            ? () => context.push('/movie/${localMovie.id}')
            : null,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              SizedBox(
                width: 48,
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
                      style: const TextStyle(fontWeight: FontWeight.w600),
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
              if (localMovie != null)
                StatusChip(status: localMovie.status, compact: true)
              else
                Row(
                  children: [
                    const MissingChip(),
                    IconButton(
                      icon: const Icon(
                        Icons.favorite_border,
                        color: AppColors.dustyRose,
                      ),
                      tooltip: 'Zur Wunschliste',
                      onPressed: () => _addToWishlist(context, ref),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addToWishlist(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref
          .read(movieRepositoryProvider)
          .addFromTmdb(entry.tmdbMovieId, status: CollectionStatus.wishlist);
      messenger.showSnackBar(
        const SnackBar(content: Text('Zur Wunschliste hinzugefügt.')),
      );
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Das hat leider nicht geklappt.')),
      );
    }
  }
}
