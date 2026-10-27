import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/collection_with_entries.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../collection/application/collection_filter_controller.dart';
import '../../collections/application/collections_providers.dart';
import '../../movies/application/movie_providers.dart';
import '../application/gap_providers.dart';

/// Entdecken: "What should I watch?", collection gaps, franchises and the
/// wishlist.
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missing = ref.watch(totalMissingCountProvider).valueOrNull ?? 0;
    final collections = ref.watch(allCollectionsProvider).valueOrNull ?? [];
    final seasonGaps = ref.watch(seasonGapsProvider).valueOrNull ?? [];
    final wishlist =
        ref
            .watch(collectionCountsProvider)
            .valueOrNull?[CollectionStatus.wishlist] ??
        0;

    return Scaffold(
      appBar: AppBar(title: const Text('Entdecken')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.auto_awesome_outlined,
                color: AppColors.amber,
              ),
              title: const Text('Was soll ich schauen?'),
              subtitle: const Text(
                'Vorschläge aus Regal, Server und deinen Abos, mit Begründung.',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/discover/watch'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.playlist_add_check_circle_outlined),
              title: const Text('Fehlende Filme'),
              subtitle: Text(
                missing == 0
                    ? 'Deine Reihen sind vollständig'
                    : '$missing Filme fehlen in deinen Reihen',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/missing'),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.favorite_border,
                color: AppColors.dustyRose,
              ),
              title: const Text('Wunschliste'),
              subtitle: Text('$wishlist Titel'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                ref
                    .read(collectionFilterControllerProvider.notifier)
                    .setStatusFilter(CollectionStatus.wishlist);
                context.go('/collection');
              },
            ),
          ),
          if (seasonGaps.isNotEmpty) ...[
            const SizedBox(height: 20),
            Text(
              'Fehlende Staffeln',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final gap in seasonGaps)
              Card(
                child: ListTile(
                  leading: SizedBox(
                    width: 40,
                    child: PosterImage(posterPath: gap.entry.series.posterPath),
                  ),
                  title: Text(gap.entry.series.name),
                  subtitle: Text(gap.message),
                  onTap: () => context.push('/series/${gap.entry.series.id}'),
                ),
              ),
          ],
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Reihen',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/collections'),
                child: const Text('Alle'),
              ),
            ],
          ),
          if (collections.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: Text(
                'Sobald ein Film zu einer Reihe gehört, siehst du hier, welche Teile dir fehlen.',
              ),
            ),
          for (final collection in collections.take(5))
            Card(
              child: ListTile(
                leading: SizedBox(
                  width: 40,
                  child: PosterImage(posterPath: collection.posterPath),
                ),
                title: Text(collection.name),
                subtitle: Text(
                  '${collection.ownedCount} von ${collection.totalCount} gekauft',
                ),
                onTap: () => context.push('/collections/${collection.id}'),
              ),
            ),
        ],
      ),
    );
  }
}
