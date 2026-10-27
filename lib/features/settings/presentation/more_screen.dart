import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/models/collection_status.dart';
import '../../collection/application/collection_filter_controller.dart';
import '../../collections/application/collections_providers.dart';
import '../../server/application/server_providers.dart';
import '../../settings/application/settings_providers.dart';
import '../../sync/application/sync_providers.dart';

class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final missingCount = ref.watch(totalMissingCountProvider);

    final server = ref.watch(serverSessionProvider).valueOrNull;
    final storage = ref.watch(collectionStorageProvider);
    final conflicts = ref.watch(syncConflictsProvider).valueOrNull?.length ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Mehr')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: Icon(
                conflicts > 0 ? Icons.sync_problem : Icons.storage_outlined,
                color: conflicts > 0 ? AppColors.amber : null,
              ),
              title: const Text('Daten & Synchronisation'),
              subtitle: Text(
                conflicts > 0
                    ? '$conflicts Widersprüche warten auf dich'
                    : '${storage.label} · Export & Sicherung',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/sync'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: Icon(
                Icons.dns_outlined,
                color: server == null ? AppColors.neutralGray : AppColors.sage,
              ),
              title: const Text('Movie Shelf Server'),
              subtitle: Text(
                server == null
                    ? 'Nicht verbunden'
                    : '${server.serverName} · ${server.username}',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/server'),
            ),
          ),
          const SizedBox(height: 12),
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
              leading: const Icon(Icons.translate),
              title: const Text('Sprache & Untertitel'),
              subtitle: const Text(
                'Welche Tonspur und Untertitel der Player wählt',
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/settings/language'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.subscriptions_outlined),
              title: const Text('Streamingdienste'),
              subtitle: const Text('Deine Abos für „Wo kann ich das schauen?“'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 14),
              onTap: () => context.push('/settings/streaming'),
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
