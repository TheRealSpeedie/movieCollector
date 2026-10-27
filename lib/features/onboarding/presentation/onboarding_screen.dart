import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/database/media_format.dart';
import '../../../core/providers/core_providers.dart';
import '../../server/application/server_providers.dart';
import '../../settings/application/settings_providers.dart';
import '../../settings/data/settings_repository.dart';
import '../../sync/application/storage_migration.dart';
import '../application/onboarding_gate.dart';

/// First run: value first, infrastructure last, every step skippable.
/// Welcome → where the collection lives → preferences → optional server →
/// first item.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _pages = PageController();
  var _page = 0;
  var _checking = true;
  var _storage = CollectionStorage.local;
  late UserPreferences _preferences;

  @override
  void initState() {
    super.initState();
    _preferences = ref.read(userPreferencesProvider);
    _skipForExistingInstall();
  }

  /// Installs from before onboarding existed already have a collection.
  /// Devices that synced with a home server keep doing so.
  Future<void> _skipForExistingInstall() async {
    final db = ref.read(appDatabaseProvider);
    final hasMovies = await (db.select(db.movies)..limit(1)).get();
    final hasSeries = await (db.select(db.tvSeriesTable)..limit(1)).get();
    final server = await ref.read(serverSessionProvider.future);
    final settings = ref.read(settingsRepositoryProvider);
    if (hasMovies.isEmpty && hasSeries.isEmpty && server == null) {
      if (mounted) setState(() => _checking = false);
      return;
    }
    if (server != null && !settings.hasStorageChoice) {
      await ref
          .read(collectionStorageProvider.notifier)
          .set(CollectionStorage.selfHosted);
    }
    await _finish('/home');
  }

  Future<void> _finish(String location) async {
    await ref.read(onboardingDoneProvider.notifier).complete();
    onboardingGate.value = true;
    if (mounted) context.go(location);
  }

  void _next() => _pages.nextPage(
    duration: const Duration(milliseconds: 250),
    curve: Curves.easeOut,
  );

  Future<void> _savePreferences() async {
    await ref.read(userPreferencesProvider.notifier).save(_preferences);
    _next();
  }

  Future<void> _start(String location) async {
    if (_storage == CollectionStorage.selfHosted &&
        ref.read(serverClientProvider) != null) {
      try {
        await ref
            .read(storageMigrationProvider)
            .migrate(CollectionStorage.selfHosted);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('$e')));
        }
      }
    }
    await _finish(location);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final pages = [
      _welcome(),
      _storagePage(),
      _preferencesPage(),
      _serverPage(),
      _firstItemPage(),
    ];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
              child: LinearProgressIndicator(
                value: (_page + 1) / pages.length,
                backgroundColor: AppColors.divider,
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pages,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (page) => setState(() => _page = page),
                children: pages,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _step({
    required String title,
    required String text,
    required List<Widget> children,
    required Widget primary,
    Widget? secondary,
  }) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(text, style: const TextStyle(color: AppColors.neutralGray)),
        const SizedBox(height: 24),
        ...children,
        const SizedBox(height: 24),
        primary,
        if (secondary != null) ...[const SizedBox(height: 8), secondary],
      ],
    );
  }

  Widget _welcome() => _step(
    title: 'Deine Filme. Alles an einem Ort.',
    text:
        '${AppConstants.appName} verbindet deine Discs, deine digitale '
        'Bibliothek und was du sehen möchtest – ohne Konto, wenn du willst.',
    children: const [
      _Point(
        Icons.qr_code_scanner,
        'Discs scannen und sofort wissen, ob du sie schon hast',
      ),
      _Point(
        Icons.collections_bookmark_outlined,
        'Lücken in Reihen und Staffeln finden',
      ),
      _Point(
        Icons.dns_outlined,
        'Optional: eigener Server für deine digitalen Filme',
      ),
    ],
    primary: FilledButton(onPressed: _next, child: const Text('Los geht\'s')),
  );

  Widget _storagePage() {
    Widget option(
      CollectionStorage value,
      String text, {
      bool enabled = true,
    }) => Card(
      child: ListTile(
        enabled: enabled,
        leading: Icon(
          _storage == value
              ? Icons.radio_button_checked
              : Icons.radio_button_off,
        ),
        title: Text(value.label),
        subtitle: Text(text),
        onTap: () => setState(() => _storage = value),
      ),
    );
    return _step(
      title: 'Wo soll deine Sammlung liegen?',
      text:
          'Du kannst das später jederzeit ändern. Beim Umzug geht nichts verloren.',
      children: [
        option(
          CollectionStorage.local,
          'Kein Konto nötig. Deine Daten bleiben hier. Sicherungen machst du selbst.',
        ),
        option(
          CollectionStorage.cloud,
          'Bald verfügbar: automatischer Abgleich zwischen deinen Geräten.',
          enabled: false,
        ),
        option(
          CollectionStorage.selfHosted,
          'Für Fortgeschrittene: Abgleich über deinen eigenen Movie Shelf '
          'Server, ganz ohne Hersteller-Konto.',
        ),
      ],
      primary: FilledButton(onPressed: _next, child: const Text('Weiter')),
    );
  }

  Widget _preferencesPage() {
    const regions = {
      'DE': 'Deutschland',
      'AT': 'Österreich',
      'CH': 'Schweiz',
      'US': 'USA',
      'GB': 'Großbritannien',
    };
    const languages = {
      'de': 'Deutsch',
      'en': 'Englisch',
      'fr': 'Französisch',
      'es': 'Spanisch',
      'it': 'Italienisch',
      'ja': 'Japanisch',
    };
    return _step(
      title: 'Deine Vorlieben',
      text:
          'Damit Movie Shelf die passende Tonspur, Untertitel und Angebote in deinem Land findet.',
      children: [
        DropdownButtonFormField<String>(
          initialValue: _preferences.region,
          decoration: const InputDecoration(labelText: 'Land'),
          items: [
            for (final e in regions.entries)
              DropdownMenuItem(value: e.key, child: Text(e.value)),
          ],
          onChanged: (v) =>
              setState(() => _preferences = _preferences.copyWith(region: v)),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String>(
          initialValue: _preferences.audioLanguage,
          decoration: const InputDecoration(labelText: 'Bevorzugte Tonspur'),
          items: [
            for (final e in languages.entries)
              DropdownMenuItem(value: e.key, child: Text(e.value)),
          ],
          onChanged: (v) => setState(
            () => _preferences = _preferences.copyWith(audioLanguage: v),
          ),
        ),
        const SizedBox(height: 12),
        DropdownButtonFormField<String?>(
          initialValue: _preferences.subtitleLanguage,
          decoration: const InputDecoration(labelText: 'Untertitel'),
          items: [
            const DropdownMenuItem(value: null, child: Text('Keine')),
            for (final e in languages.entries)
              DropdownMenuItem(value: e.key, child: Text(e.value)),
          ],
          onChanged: (v) => setState(
            () => _preferences = _preferences.copyWith(
              subtitleLanguage: v,
              clearSubtitles: v == null,
            ),
          ),
        ),
        const SizedBox(height: 16),
        const Text('Bevorzugte Formate'),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          children: [
            for (final format in [
              MediaFormat.uhd4k,
              MediaFormat.bluray,
              MediaFormat.dvd,
            ])
              FilterChip(
                label: Text(format.label),
                selected: _preferences.preferredFormats.contains(format.name),
                onSelected: (on) => setState(() {
                  final list = [..._preferences.preferredFormats];
                  on ? list.add(format.name) : list.remove(format.name);
                  _preferences = _preferences.copyWith(preferredFormats: list);
                }),
              ),
          ],
        ),
      ],
      primary: FilledButton(
        onPressed: _savePreferences,
        child: const Text('Weiter'),
      ),
      secondary: TextButton(
        onPressed: _next,
        child: const Text('Überspringen'),
      ),
    );
  }

  Widget _serverPage() {
    final connected = ref.watch(serverClientProvider) != null;
    return _step(
      title: 'Movie Shelf Server',
      text: _storage == CollectionStorage.selfHosted
          ? 'Verbinde deinen Server, um deine Sammlung darüber abzugleichen. '
                'Er findet sich im WLAN von selbst oder per QR-Code aus dem Dashboard.'
          : 'Hast du einen Server für deine digitalen Filme? Dann kannst du sie '
                'hier abspielen. Deine Sammlung bleibt trotzdem auf diesem Gerät.',
      children: [
        if (connected) const _Point(Icons.check_circle, 'Server verbunden'),
      ],
      primary: connected
          ? FilledButton(onPressed: _next, child: const Text('Weiter'))
          : FilledButton.icon(
              onPressed: () => context.push('/server/connect'),
              icon: const Icon(Icons.dns_outlined),
              label: const Text('Server verbinden'),
            ),
      secondary: TextButton(
        onPressed: () {
          if (_storage == CollectionStorage.selfHosted && !connected) {
            setState(() => _storage = CollectionStorage.local);
          }
          _next();
        },
        child: Text(connected ? 'Weiter' : 'Später'),
      ),
    );
  }

  Widget _firstItemPage() => _step(
    title: 'Womit möchtest du anfangen?',
    text: 'Alles lässt sich auch später über die Tabs erreichen.',
    children: [
      _Choice(
        Icons.qr_code_scanner,
        'Erste Disc scannen',
        () => _start('/scanner'),
      ),
      _Choice(
        Icons.upload_file_outlined,
        'Liste importieren',
        () => _start('/import'),
      ),
      _Choice(
        Icons.search,
        'Film suchen und hinzufügen',
        () => _start('/search'),
      ),
    ],
    primary: OutlinedButton(
      onPressed: () => _start('/home'),
      child: const Text('Erst einmal umsehen'),
    ),
  );
}

class _Point extends StatelessWidget {
  const _Point(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: Icon(icon, color: AppColors.dustyRose),
    title: Text(text),
  );
}

class _Choice extends StatelessWidget {
  const _Choice(this.icon, this.text, this.onTap);

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Card(
    child: ListTile(
      leading: Icon(icon, color: AppColors.dustyRose),
      title: Text(text),
      trailing: const Icon(Icons.arrow_forward_ios, size: 14),
      onTap: onTap,
    ),
  );
}
