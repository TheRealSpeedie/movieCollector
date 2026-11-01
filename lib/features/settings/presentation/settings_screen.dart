import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../core/config/env.dart';
import '../../../core/health/health_providers.dart';
import '../../../core/health/service_health.dart';
import '../../../core/constants/api_constants.dart';
import '../../movies/application/movie_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moviesAsync = ref.watch(allMoviesProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Einstellungen')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionTitle('Metadaten'),
          const Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(Icons.language),
                  title: Text('Sprache'),
                  trailing: Text(ApiConstants.tmdbLanguage),
                ),
                Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.flag_outlined),
                  title: Text('Region'),
                  trailing: Text(ApiConstants.tmdbRegion),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle('Datenbank'),
          Card(
            child: ListTile(
              leading: const Icon(Icons.storage_outlined),
              title: const Text('Filme in der Sammlung'),
              trailing: Text('${moviesAsync.valueOrNull?.length ?? 0}'),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cleaning_services_outlined),
              title: const Text('Bild-Cache leeren'),
              onTap: () async {
                await DefaultCacheManager().emptyCache();
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Bild-Cache geleert.')),
                  );
                }
              },
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle('API-Status'),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    Icons.movie_outlined,
                    color: context.colors.textSecondary,
                  ),
                  title: const Text('Filminfos (TMDB)'),
                  subtitle: Text(
                    ref
                        .watch(serviceHealthProvider(ExternalService.tmdb))
                        .summary,
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/settings/metadata'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(
                    Icons.qr_code_outlined,
                    color: context.colors.textSecondary,
                  ),
                  title: const Text('UPCitemdb'),
                  subtitle: Text(
                    Env.isUpcItemDbProConfigured
                        ? 'Bezahlter Plan konfiguriert'
                        : 'Kostenloser Explorer-Plan (Rate-Limit)',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _SectionTitle('Über'),
          Card(
            child: Column(
              children: [
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data == null
                        ? '…'
                        : '${snapshot.data!.version} (${snapshot.data!.buildNumber})';
                    return ListTile(
                      leading: const Icon(Icons.info_outline),
                      title: const Text('App-Version'),
                      trailing: Text(version),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.open_in_new),
                  title: const Text('themoviedb.org'),
                  onTap: () =>
                      launchUrl(Uri.parse('https://www.themoviedb.org')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Dieses Produkt verwendet die TMDB API, wird jedoch nicht von TMDB unterstützt oder zertifiziert.\n'
              'Barcode-Daten werden über UPCitemdb bereitgestellt.',
              style: TextStyle(
                color: context.colors.textSecondary,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }
}
