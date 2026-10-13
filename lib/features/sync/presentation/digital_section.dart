import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../server/application/server_providers.dart';
import '../application/sync_providers.dart';

class DigitalSection extends ConsumerWidget {
  const DigitalSection({super.key, required this.tmdbId});

  final int tmdbId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (ref.watch(serverClientProvider) == null) {
      return const SizedBox.shrink();
    }
    final loaded = ref.watch(serverMoviesProvider).hasValue;
    if (!loaded) return const SizedBox.shrink();
    final title = ref.watch(serverMovieByTmdbIdProvider(tmdbId));
    return Padding(
      padding: const EdgeInsets.only(top: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Digitale Version',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          if (title == null)
            const Text(
              'Nicht in deiner Server-Bibliothek.',
              style: TextStyle(color: AppColors.neutralGray),
            )
          else
            Card(
              child: ListTile(
                leading: const Icon(Icons.play_circle_outline),
                title: Text(
                  title.qualities.isEmpty
                      ? 'Auf dem Server'
                      : title.qualities.join(' · '),
                ),
                subtitle: Text(
                  title.watched ? 'Gesehen' : 'Noch nicht gesehen',
                ),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push('/server/title/${title.id}'),
              ),
            ),
        ],
      ),
    );
  }
}
