import 'package:flutter/material.dart';
import 'package:speednema/shared/models/collection_status.dart';
import 'package:speednema/shared/widgets/connection_badge.dart';
import 'package:speednema/shared/widgets/inline_notice.dart';
import 'package:speednema/shared/widgets/media_card.dart';
import 'package:speednema/shared/widgets/section_header.dart';
import 'package:speednema/shared/widgets/settings_group.dart';
import 'package:speednema/shared/widgets/shelf_row.dart';
import 'package:speednema/shared/widgets/status_chip.dart';
import 'package:speednema/shared/widgets/status_view.dart';

/// Every shared component in realistic states, for goldens and
/// accessibility checks. Posters use the placeholder (no network in tests).
class ComponentGallery extends StatelessWidget {
  const ComponentGallery({super.key});

  static const films = [
    ('Arrival', '2016', CollectionStatus.owned, MediaBadge.playable()),
    ('Blade Runner 2049', '2017', CollectionStatus.wishlist, null),
    (
      'Der Herr der Ringe: Die Gefährten',
      '2001',
      CollectionStatus.open,
      MediaBadge.text('2/3'),
    ),
    ('Dune', '2021', CollectionStatus.owned, null),
  ];

  @override
  Widget build(BuildContext context) {
    void noop() {}
    return Scaffold(
      appBar: AppBar(title: const Text('Komponenten')),
      body: ListView(
        children: [
          ShelfRow(
            title: 'Zuletzt hinzugefügt',
            onAction: noop,
            itemCount: films.length,
            itemBuilder: (context, i) => MediaCard(
              title: films[i].$1,
              subtitle: films[i].$2,
              status: films[i].$3,
              badge: films[i].$4,
              onTap: noop,
            ),
          ),
          const SizedBox(height: 16),
          const SectionHeader(title: 'Liste'),
          for (final f in films.take(2))
            MediaRow(title: f.$1, subtitle: f.$2, status: f.$3, onTap: noop),
          const Padding(
            padding: EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                StatusChip(status: CollectionStatus.owned),
                StatusChip(status: CollectionStatus.wishlist),
                StatusChip(status: CollectionStatus.open),
                StatusChip(status: CollectionStatus.owned, compact: true),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: InlineNotice(
              kind: StatusKind.serviceUnavailable,
              title: 'Server nicht erreichbar',
              message: 'Deine Sammlung ist weiter verfügbar.',
              action: StatusAction('Erneut versuchen', noop),
              onDismiss: noop,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                ConnectionBadge(tone: ConnectionTone.ok, label: 'Verbunden'),
                ConnectionBadge(
                  tone: ConnectionTone.attention,
                  label: 'Neu anmelden',
                ),
                ConnectionBadge(tone: ConnectionTone.offline, label: 'Offline'),
                ConnectionBadge(
                  tone: ConnectionTone.none,
                  label: 'Nicht eingerichtet',
                ),
              ],
            ),
          ),
          StatusView.compact(
            kind: StatusKind.notConfigured,
            title: 'Filminfos sind nicht eingerichtet',
            message: 'Deine Sammlung funktioniert auch ohne.',
            primary: StatusAction('Einrichten', noop),
          ),
          SettingsGroup(
            title: 'Medien',
            footer:
                'Speednema nutzt TMDB für Titel, Poster und Beschreibungen.',
            children: [
              SettingsTile.navigation(
                icon: Icons.movie_outlined,
                title: 'Filminfos',
                value: 'Eingerichtet',
                onTap: noop,
              ),
              SettingsTile.toggle(
                icon: Icons.subtitles_outlined,
                title: 'Untertitel für Hörgeschädigte',
                toggle: true,
                onToggle: (_) {},
              ),
              const SettingsTile.info(
                icon: Icons.info_outline,
                title: 'Version',
                value: '1.0.0',
              ),
              SettingsTile.destructive(
                icon: Icons.logout,
                title: 'Haushalt verlassen',
                onTap: noop,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilledButton(onPressed: noop, child: const Text('Speichern')),
                OutlinedButton(onPressed: noop, child: const Text('Abbrechen')),
                TextButton(onPressed: noop, child: const Text('Mehr')),
              ],
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(16),
            child: TextField(
              decoration: InputDecoration(hintText: 'Titel suchen'),
            ),
          ),
        ],
      ),
    );
  }
}
