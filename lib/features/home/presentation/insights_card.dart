import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../discover/domain/watch_suggestions.dart';
import '../../watch/application/watch_providers.dart';

/// Quiet observations about the collection. Shows nothing when there is
/// nothing useful to say.
class InsightsCard extends ConsumerWidget {
  const InsightsCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(wishlistOfferWatcherProvider);
    final insights = ref.watch(collectionInsightsProvider).valueOrNull;
    if (insights == null || insights.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Card(
        child: Column(
          children: [
            for (final hit in insights.wishlistInSubscription.take(3))
              ListTile(
                leading: const Icon(Icons.favorite, color: AppColors.dustyRose),
                title: Text('${hit.candidate.title} ist in deinem Abo'),
                subtitle: Text(
                  'Von deiner Wunschliste, jetzt bei ${hit.provider}',
                ),
                onTap: hit.candidate.movieId == null
                    ? null
                    : () => context.push('/movie/${hit.candidate.movieId}'),
              ),
            if (insights.unwatchedOnShelf > 0)
              ListTile(
                leading: const Icon(Icons.album_outlined),
                title: Text(
                  '${insights.unwatchedOnShelf} Filme im Regal noch nicht gesehen',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push(
                  '/discover/watch?sources=${SuggestionSource.shelf.name}',
                ),
              ),
            if (insights.unwatchedOnServer > 0)
              ListTile(
                leading: const Icon(Icons.dns_outlined),
                title: Text(
                  '${insights.unwatchedOnServer} Filme auf deinem Server noch nicht gesehen',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push(
                  '/discover/watch?sources=${SuggestionSource.server.name}',
                ),
              ),
          ],
        ),
      ),
    );
  }
}
