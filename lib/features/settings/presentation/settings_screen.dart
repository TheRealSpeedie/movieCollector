import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/tokens.g.dart';
import '../../../core/database/media_format.dart';
import '../../../core/health/health_providers.dart';
import '../../../core/health/service_health.dart';
import '../../../shared/widgets/settings_group.dart';
import '../application/settings_providers.dart';
import '../domain/regions.dart';

/// Einstellungen: only what people actually change, grouped by what it is
/// about. Places (server, cloud, household, data) live in Mehr.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final preferences = ref.watch(userPreferencesProvider);
    final tmdb = ref.watch(serviceHealthProvider(ExternalService.tmdb));

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
        children: [
          SettingsGroup(
            title: 'Allgemein',
            footer:
                'Das Land bestimmt, welche Streaming-Angebote angezeigt werden. '
                'Wer einen Film als gekauft markiert, ohne ein Format zu wählen, '
                'bekommt das bevorzugte Format.',
            children: [
              SettingsTile.navigation(
                icon: Icons.flag_outlined,
                title: 'Land',
                value: regionName(preferences.region),
                onTap: () => _pickRegion(context, ref),
              ),
              SettingsTile.navigation(
                icon: Icons.album_outlined,
                title: 'Bevorzugtes Format',
                value: _formatLabel(preferences.preferredFormats),
                onTap: () => _pickFormat(context, ref),
              ),
            ],
          ),
          SettingsGroup(
            title: 'Medien',
            children: [
              SettingsTile.navigation(
                icon: Icons.movie_outlined,
                title: 'Filminfos',
                value: tmdb.summary,
                onTap: () => context.push('/settings/metadata'),
              ),
              SettingsTile.navigation(
                icon: Icons.cleaning_services_outlined,
                title: 'Bild-Cache leeren',
                subtitle: 'Poster werden bei Bedarf neu geladen.',
                onTap: () async {
                  await DefaultCacheManager().emptyCache();
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Bild-Cache geleert.')),
                    );
                  }
                },
              ),
            ],
          ),
          SettingsGroup(
            title: 'Wiedergabe',
            children: [
              SettingsTile.navigation(
                icon: Icons.subtitles_outlined,
                title: 'Sprache & Untertitel',
                onTap: () => context.push('/settings/language'),
              ),
            ],
          ),
          SettingsGroup(
            title: 'Erweitert',
            children: [
              SettingsTile.navigation(
                icon: Icons.monitor_heart_outlined,
                title: 'Diagnose',
                subtitle: 'Zustand der Dienste, für die Fehlersuche',
                onTap: () => context.push('/settings/diagnostics'),
              ),
            ],
          ),
          SettingsGroup(
            title: 'Über',
            children: [
              FutureBuilder<PackageInfo>(
                future: PackageInfo.fromPlatform(),
                builder: (context, snapshot) => SettingsTile.info(
                  icon: Icons.info_outline,
                  title: 'Version',
                  value: snapshot.data == null
                      ? '…'
                      : '${snapshot.data!.version} (${snapshot.data!.buildNumber})',
                ),
              ),
              SettingsTile.navigation(
                icon: Icons.description_outlined,
                title: 'Lizenzen',
                onTap: () => showLicensePage(
                  context: context,
                  applicationName: 'Speednema',
                ),
              ),
              SettingsTile.navigation(
                icon: Icons.open_in_new,
                title: 'themoviedb.org',
                onTap: () => launchUrl(
                  Uri.parse('https://www.themoviedb.org'),
                  mode: LaunchMode.externalApplication,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xl,
              AppSpacing.s,
              AppSpacing.xl,
              AppSpacing.xl,
            ),
            child: Text(
              'Speednema nutzt die TMDB-API, wird aber nicht von TMDB '
              'unterstützt oder zertifiziert. Streaming-Angebote von '
              'JustWatch, Barcode-Daten von UPCitemdb.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  static Future<void> _pickRegion(BuildContext context, WidgetRef ref) async {
    final current = ref.read(userPreferencesProvider);
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (sheet) => SafeArea(
        child: RadioGroup<String>(
          groupValue: current.region,
          onChanged: (code) => Navigator.of(sheet).pop(code),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final MapEntry(key: code, value: name)
                  in supportedRegions.entries)
                RadioListTile<String>(value: code, title: Text(name)),
            ],
          ),
        ),
      ),
    );
    if (picked != null && picked != current.region) {
      await ref
          .read(userPreferencesProvider.notifier)
          .save(current.copyWith(region: picked));
    }
  }

  static const _formats = [
    MediaFormat.uhd4k,
    MediaFormat.bluray,
    MediaFormat.dvd,
  ];

  static String _formatLabel(List<String> names) =>
      _formats.where((f) => f.name == names.firstOrNull).firstOrNull?.label ??
      'Keins';

  static Future<void> _pickFormat(BuildContext context, WidgetRef ref) async {
    final current = ref.read(userPreferencesProvider);
    final picked = await showModalBottomSheet<String>(
      context: context,
      builder: (sheet) => SafeArea(
        child: RadioGroup<String>(
          groupValue: current.preferredFormats.firstOrNull ?? '',
          onChanged: (name) => Navigator.of(sheet).pop(name),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const RadioListTile<String>(value: '', title: Text('Keins')),
              for (final f in _formats)
                RadioListTile<String>(value: f.name, title: Text(f.label)),
            ],
          ),
        ),
      ),
    );
    if (picked == null) return;
    await ref
        .read(userPreferencesProvider.notifier)
        .save(
          current.copyWith(preferredFormats: picked.isEmpty ? [] : [picked]),
        );
  }
}
