import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../server/application/server_providers.dart';
import 'tv_focusable.dart';

/// Connection, profile and disconnect. Language preferences come from the
/// phone and are stored on the server for each profile.
class TvSettingsScreen extends ConsumerWidget {
  const TvSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final credentials = ref.watch(serverSessionProvider).valueOrNull;
    if (credentials == null) return const SizedBox.shrink();
    Widget line(String label, String value) => Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 220,
            child: Text(
              label,
              style: const TextStyle(color: AppColors.neutralGray),
            ),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 18))),
        ],
      ),
    );

    return TvPage(
      child: ListView(
        children: [
          Text(
            'Einstellungen',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 24),
          line('Server', credentials.serverName),
          line('Adresse', credentials.baseUrl),
          line(
            'Verbindung',
            credentials.secure
                ? 'Verschlüsselt (HTTPS, Zertifikat geprüft)'
                : 'Unverschlüsselt (HTTP)',
          ),
          line('Profil', credentials.username),
          const SizedBox(height: 8),
          const Text(
            'Tonspur und Untertitel richtest du in der Movie-Shelf-App auf '
            'dem Handy ein (Mehr → Sprache & Untertitel). Der Fernseher '
            'übernimmt sie für dein Profil.',
            style: TextStyle(color: AppColors.neutralGray),
          ),
          const SizedBox(height: 32),
          Align(
            alignment: Alignment.centerLeft,
            child: TvButton(
              label: 'Vom Server trennen',
              icon: Icons.link_off,
              autofocus: true,
              onSelect: () => showDialog<void>(
                context: context,
                builder: (dialogContext) => AlertDialog(
                  title: const Text('Vom Server trennen?'),
                  content: const Text(
                    'Der Fernseher muss danach neu gekoppelt werden.',
                  ),
                  actions: [
                    TvButton(
                      label: 'Abbrechen',
                      autofocus: true,
                      onSelect: () => Navigator.of(dialogContext).pop(),
                    ),
                    TvButton(
                      label: 'Trennen',
                      primary: true,
                      onSelect: () {
                        Navigator.of(dialogContext).pop();
                        ref.read(serverSessionProvider.notifier).disconnect();
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
