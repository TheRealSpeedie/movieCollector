import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../application/settings_providers.dart';
import '../data/settings_repository.dart';

const _languages = {
  'de': 'Deutsch',
  'en': 'Englisch',
  'fr': 'Französisch',
  'es': 'Spanisch',
  'it': 'Italienisch',
  'ja': 'Japanisch',
  'ko': 'Koreanisch',
};

/// Audio and subtitle preferences. The player picks tracks from them, and a
/// connected server keeps a copy so TVs play the same way.
class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final p = ref.watch(userPreferencesProvider);
    final controller = ref.read(userPreferencesProvider.notifier);

    DropdownMenuItem<String?> item(String? code, String label) =>
        DropdownMenuItem(value: code, child: Text(label));

    return Scaffold(
      appBar: AppBar(title: const Text('Sprache & Untertitel')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String?>(
            initialValue: p.audioLanguage,
            decoration: const InputDecoration(labelText: 'Bevorzugte Tonspur'),
            items: [for (final e in _languages.entries) item(e.key, e.value)],
            onChanged: (v) => controller.save(p.copyWith(audioLanguage: v)),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String?>(
            initialValue: p.secondaryAudioLanguage,
            decoration: const InputDecoration(
              labelText: 'Zweite Sprache, die du verstehst',
            ),
            items: [
              item(null, 'Keine'),
              for (final e in _languages.entries) item(e.key, e.value),
            ],
            onChanged: (v) => controller.save(
              p.copyWith(secondaryAudioLanguage: v, clearSecondary: v == null),
            ),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Originalton bevorzugen'),
            subtitle: const Text(
              'Spielt die Originalsprache, wenn die Datei sie hat, mit '
              'Untertiteln, falls du sie nicht verstehst.',
            ),
            value: p.preferOriginal,
            onChanged: (v) => controller.save(p.copyWith(preferOriginal: v)),
          ),
          const Divider(),
          DropdownButtonFormField<String?>(
            initialValue: p.subtitleLanguage,
            decoration: const InputDecoration(labelText: 'Untertitelsprache'),
            items: [
              item(null, 'Wie die bevorzugte Tonspur'),
              for (final e in _languages.entries) item(e.key, e.value),
            ],
            onChanged: (v) => controller.save(
              p.copyWith(subtitleLanguage: v, clearSubtitles: v == null),
            ),
          ),
          const SizedBox(height: 12),
          const Text('Untertitel zeigen'),
          const SizedBox(height: 8),
          SegmentedButton<SubtitleMode>(
            segments: [
              for (final mode in SubtitleMode.values)
                ButtonSegment(value: mode, label: Text(mode.label)),
            ],
            selected: {p.subtitleMode},
            onSelectionChanged: (s) =>
                controller.save(p.copyWith(subtitleMode: s.first)),
          ),
          const SizedBox(height: 4),
          const Text(
            '„Wenn nötig“ zeigt Untertitel, wenn der Ton in einer Sprache ist, '
            'die du nicht angegeben hast, und erzwungene Untertitel für '
            'fremdsprachige Stellen.',
            style: TextStyle(color: AppColors.neutralGray, fontSize: 12),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Untertitel für Hörgeschädigte bevorzugen'),
            value: p.hearingImpaired,
            onChanged: (v) => controller.save(p.copyWith(hearingImpaired: v)),
          ),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            title: const Text('Audiodeskription bevorzugen'),
            subtitle: const Text(
              'Tonspuren, die das Bild beschreiben, für blinde und '
              'sehbehinderte Menschen. Sonst werden sie nie von selbst gewählt.',
            ),
            value: p.audioDescription,
            onChanged: (v) => controller.save(p.copyWith(audioDescription: v)),
          ),
          const SizedBox(height: 8),
          const Text(
            'Im Player kannst du jederzeit eine andere Spur wählen, Untertitel '
            'suchen und verschieben.',
            style: TextStyle(color: AppColors.neutralGray),
          ),
        ],
      ),
    );
  }
}
