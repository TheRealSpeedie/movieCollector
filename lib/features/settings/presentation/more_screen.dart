import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/models/collection_status.dart';
import '../../collection/application/collection_filter_controller.dart';
import '../../collections/application/collections_providers.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missingCount = ref.watch(totalMissingCountProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Mehr')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(
                Icons.favorite_border,
                color: AppColors.dustyRose,
              ),
              title: const Text('Wunschliste'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () {
                ref
                    .read(collectionFilterControllerProvider.notifier)
                    .setStatusFilter(CollectionStatus.wishlist);
                context.go('/collection');
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.playlist_add_check_circle_outlined),
              title: const Text('Fehlende Filme'),
              subtitle: Text(
                '${missingCount.valueOrNull ?? 0} Filme aus deinen Reihen fehlen dir',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/missing'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.upload_file_outlined),
              title: const Text('Filme importieren'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/import'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Einstellungen'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/settings'),
            ),
          ),
        ],
      ),
    );
  }
}
