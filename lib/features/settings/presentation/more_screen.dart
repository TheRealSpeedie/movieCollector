import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';
import '../../../shared/widgets/connection_badge.dart';
import '../../../shared/widgets/settings_group.dart';
import '../../cloud/application/cloud_providers.dart';
import '../../collections/application/franchise_gaps.dart';
import '../../server/application/server_connection.dart';
import '../../server/application/server_providers.dart';
import '../../sync/application/sync_providers.dart';
import '../application/settings_providers.dart';
import '../data/settings_repository.dart';

/// Mehr: where the collection lives and what it connects to, the library
/// tools, and settings. Things to watch live in Home, Sammlung and
/// Entdecken, not here.
class MoreScreen extends ConsumerWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final connection = ref.watch(serverConnectionProvider);
    final server = ref.watch(serverSessionProvider).valueOrNull;
    final cloud = ref.watch(cloudAvailableProvider);
    final cloudSession = ref.watch(cloudAccountProvider).valueOrNull;
    final storage = ref.watch(collectionStorageProvider);
    final conflicts = ref.watch(syncConflictsProvider).valueOrNull?.length ?? 0;
    final gaps = ref.watch(franchiseGapsProvider);

    final dataSummary = conflicts > 0
        ? conflicts == 1
              ? '1 Widerspruch wartet auf dich'
              : '$conflicts Widersprüche warten auf dich'
        : storage == CollectionStorage.local
        ? '${storage.label} · Sicherung & Export'
        : '${storage.label} · ${syncSummary(ref.watch(syncControllerProvider), ref.watch(pendingChangesProvider).valueOrNull ?? 0)}';

    return Scaffold(
      appBar: AppBar(title: const Text('Mehr')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
        children: [
          SettingsGroup(
            title: 'Verbindungen',
            children: [
              ListTile(
                minTileHeight: 64,
                leading: Icon(Icons.dns_outlined, color: colors.textSecondary),
                title: Text(server?.serverName ?? 'Speednema Server'),
                // Without a server this is an explanation, not a status.
                subtitle: server == null
                    ? Text(
                        'Optional – für Streaming und Haushalt',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      )
                    : Padding(
                        padding: const EdgeInsets.only(top: AppSpacing.xs),
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: ConnectionBadge(
                            tone: connection.tone,
                            label: connection.label,
                          ),
                        ),
                      ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: colors.textSecondary,
                ),
                onTap: () => context.push('/server'),
              ),
              if (cloud)
                SettingsTile.navigation(
                  icon: Icons.cloud_outlined,
                  title: 'Speednema Cloud',
                  subtitle: cloudSession?.email ?? 'Nicht angemeldet',
                  onTap: () => context.push('/cloud'),
                ),
              SettingsTile.navigation(
                icon: Icons.group_outlined,
                title: 'Haushalt',
                subtitle: 'Eine Sammlung mit anderen teilen',
                onTap: () => context.push('/household'),
              ),
              SettingsTile.navigation(
                icon: conflicts > 0
                    ? Icons.sync_problem
                    : Icons.storage_outlined,
                title: 'Daten & Abgleich',
                subtitle: dataSummary,
                onTap: () => context.push('/sync'),
              ),
              SettingsTile.navigation(
                icon: Icons.live_tv_outlined,
                title: 'Streamingdienste',
                subtitle: 'Deine Abos für „Wo kann ich das schauen?“',
                onTap: () => context.push('/settings/streaming'),
              ),
            ],
          ),
          SettingsGroup(
            title: 'Bibliothek',
            children: [
              SettingsTile.navigation(
                icon: Icons.collections_bookmark_outlined,
                title: 'Reihen',
                subtitle: franchiseGapsSummary(gaps),
                onTap: () => context.push('/collections'),
              ),
              SettingsTile.navigation(
                icon: Icons.playlist_add,
                title: 'Liste importieren',
                subtitle: 'Aus Notizen, einer Text- oder CSV-Datei',
                onTap: () => context.push('/import'),
              ),
            ],
          ),
          SettingsGroup(
            children: [
              SettingsTile.navigation(
                icon: Icons.settings_outlined,
                title: 'Einstellungen',
                subtitle: 'Land, Filminfos, Sprache & Untertitel, Diagnose',
                onTap: () => context.push('/settings'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
