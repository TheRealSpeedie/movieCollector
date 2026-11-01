import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/theme/tokens.g.dart';
import '../../../core/config/config_providers.dart';
import '../../../core/config/env.dart';
import '../../../core/health/health_providers.dart';
import '../../../core/health/service_health.dart';
import '../../../shared/widgets/connection_badge.dart';
import '../../../shared/widgets/settings_group.dart';
import '../../server/application/server_connection.dart';
import '../../server/application/server_providers.dart';
import '../../sync/application/sync_providers.dart';

/// Einstellungen > Diagnose: what every service is doing, in one place, for
/// troubleshooting. The everyday screens show this only when it matters.
class DiagnosticsScreen extends ConsumerWidget {
  const DiagnosticsScreen({super.key});

  static ConnectionTone _tone(ServiceHealth health) => switch (health) {
    HealthOk() => ConnectionTone.ok,
    HealthInvalidCredentials() ||
    HealthRateLimited() => ConnectionTone.attention,
    HealthOffline() || HealthUnavailable() => ConnectionTone.offline,
    HealthUnknown() || HealthNotConfigured() => ConnectionTone.none,
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final server = ref.watch(serverConnectionProvider);
    final credentials = ref.watch(serverSessionProvider).valueOrNull;
    final sync = syncSummary(
      ref.watch(syncControllerProvider),
      ref.watch(pendingChangesProvider).valueOrNull ?? 0,
    );

    Widget service(ExternalService s, String? note) {
      final health = ref.watch(serviceHealthProvider(s));
      return ListTile(
        title: Text(s.label),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: AppSpacing.xs),
            ConnectionBadge(tone: _tone(health), label: health.summary),
            if (note != null) Text(note),
          ],
        ),
      );
    }

    final report = StringBuffer();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Diagnose'),
        actions: [
          IconButton(
            tooltip: 'Bericht kopieren',
            icon: const Icon(Icons.copy_all_outlined),
            onPressed: () async {
              await Clipboard.setData(ClipboardData(text: report.toString()));
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Bericht kopiert.')),
                );
              }
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final tmdbSource = switch (ref.watch(tmdbKeySourceProvider)) {
            TmdbKeySource.user => 'eigener Schlüssel',
            TmdbKeySource.build => 'Schlüssel der App',
            TmdbKeySource.none => 'kein Schlüssel',
          };
          report
            ..writeln('Speednema Diagnose')
            ..writeln(
              'Server: ${server.label}'
              '${credentials == null ? '' : ' (${credentials.serverName}, ${credentials.baseUrl})'}',
            )
            ..writeln('Abgleich: $sync');
          for (final s in ExternalService.values) {
            report.writeln(
              '${s.label}: ${ref.watch(serviceHealthProvider(s)).summary}',
            );
          }
          return ListView(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
            children: [
              SettingsGroup(
                title: 'Speednema Server',
                children: [
                  ListTile(
                    title: Text(credentials?.serverName ?? 'Kein Server'),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: AppSpacing.xs),
                        ConnectionBadge(tone: server.tone, label: server.label),
                        if (credentials != null)
                          SelectableText(credentials.baseUrl),
                        Text('Abgleich: $sync'),
                      ],
                    ),
                  ),
                ],
              ),
              SettingsGroup(
                title: 'Dienste',
                footer:
                    'Der Zustand ergibt sich aus den letzten echten Anfragen.',
                children: [
                  service(ExternalService.tmdb, tmdbSource),
                  service(
                    ExternalService.upcItemDb,
                    Env.isUpcItemDbProConfigured
                        ? 'Bezahlter Plan'
                        : 'Kostenloser Plan mit Anfragelimit',
                  ),
                  if (Env.isUpcmdbConfigured)
                    service(ExternalService.upcmdb, null),
                ],
              ),
              SettingsGroup(
                title: 'App',
                children: [
                  FutureBuilder<PackageInfo>(
                    future: PackageInfo.fromPlatform(),
                    builder: (context, snapshot) {
                      final version = snapshot.data == null
                          ? '…'
                          : '${snapshot.data!.version} (${snapshot.data!.buildNumber})';
                      report.writeln('App: $version');
                      return SettingsTile.info(
                        icon: Icons.info_outline,
                        title: 'Version',
                        value: version,
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
