import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';
import '../../../core/errors/user_facing_error.dart';
import '../../../core/providers/core_providers.dart';
import '../../cloud/application/cloud_providers.dart';
import '../../home/presentation/empty_shelf.dart';
import '../../server/application/server_providers.dart';
import '../../settings/application/settings_providers.dart';
import '../../settings/data/settings_repository.dart';
import '../../settings/domain/regions.dart';
import '../../sync/application/storage_migration.dart';
import '../application/onboarding_gate.dart';

enum _Step { welcome, storage, server, start }

/// First run, short and skippable: what Speednema is, where the collection
/// lives, the server only if that was the choice, and a first step that
/// leads straight into the real task. Languages and formats wait for
/// Einstellungen; the country comes from the device.
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  var _step = _Step.welcome;
  var _checking = true;
  var _storage = CollectionStorage.local;

  List<_Step> get _steps => [
    _Step.welcome,
    _Step.storage,
    if (_storage == CollectionStorage.selfHosted) _Step.server,
    _Step.start,
  ];

  @override
  void initState() {
    super.initState();
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
      await _regionFromDevice();
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

  /// Settings can tell what the device knows: the country decides which
  /// streaming offers are shown. Changeable in Einstellungen.
  Future<void> _regionFromDevice() async {
    final country = WidgetsBinding
        .instance
        .platformDispatcher
        .locale
        .countryCode
        ?.toUpperCase();
    if (country == null || !supportedRegions.containsKey(country)) return;
    final preferences = ref.read(userPreferencesProvider);
    if (preferences.region == country) return;
    await ref
        .read(userPreferencesProvider.notifier)
        .save(preferences.copyWith(region: country));
  }

  Future<void> _finish(String location) async {
    await ref.read(onboardingDoneProvider.notifier).complete();
    onboardingGate.value = true;
    if (mounted) context.go(location);
  }

  void _go(int delta) {
    final steps = _steps;
    final index = (steps.indexOf(_step) + delta).clamp(0, steps.length - 1);
    setState(() => _step = steps[index]);
  }

  Future<void> _start(String location) async {
    final ready = switch (_storage) {
      CollectionStorage.selfHosted => ref.read(serverClientProvider) != null,
      CollectionStorage.cloud => ref.read(cloudSyncProvider) != null,
      CollectionStorage.local => false,
    };
    if (ready) {
      try {
        await ref.read(storageMigrationProvider).migrate(_storage);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(describeError(e))));
        }
      }
    }
    await _finish(location);
  }

  /// Cloud needs an account first; the move itself happens in [_start].
  Future<void> _chooseCloud() async {
    if (ref.read(cloudAccountProvider).valueOrNull == null) {
      await context.push<bool>('/cloud');
      if (!mounted || ref.read(cloudAccountProvider).valueOrNull == null) {
        return;
      }
    }
    setState(() => _storage = CollectionStorage.cloud);
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    final steps = _steps;
    final index = steps.indexOf(_step);
    final page = switch (_step) {
      _Step.welcome => _welcome(),
      _Step.storage => _storagePage(),
      _Step.server => _serverPage(),
      _Step.start => _startPage(),
    };
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: index == 0
            ? null
            : IconButton(
                tooltip: 'Zurück',
                icon: const Icon(Icons.arrow_back),
                onPressed: () => _go(-1),
              ),
        title: Semantics(
          label: 'Schritt ${index + 1} von ${steps.length}',
          excludeSemantics: true,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < steps.length; i++)
                Container(
                  width: i == index ? 20 : 8,
                  height: 8,
                  margin: const EdgeInsets.only(right: AppSpacing.xs),
                  decoration: BoxDecoration(
                    color: i == index
                        ? context.colors.accent
                        : context.colors.hairline,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
            ],
          ),
        ),
        actions: [
          if (_step != _Step.start)
            TextButton(
              onPressed: () => _finish('/home'),
              child: const Text('Überspringen'),
            ),
        ],
      ),
      body: SafeArea(
        child: AnimatedSwitcher(
          duration: MediaQuery.disableAnimationsOf(context)
              ? Duration.zero
              : AppMotion.page,
          child: KeyedSubtree(key: ValueKey(_step), child: page),
        ),
      ),
    );
  }

  Widget _layout({
    Widget? hero,
    required String title,
    required String text,
    List<Widget> children = const [],
    required Widget primary,
    Widget? secondary,
  }) {
    final textTheme = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hero != null) ...[
                Center(child: hero),
                const SizedBox(height: AppSpacing.xl),
              ],
              Semantics(
                header: true,
                child: Text(title, style: textTheme.headlineSmall),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                text,
                style: textTheme.bodyLarge?.copyWith(
                  color: context.colors.textSecondary,
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              ...children,
              if (children.isNotEmpty) const SizedBox(height: AppSpacing.xl),
              SizedBox(width: double.infinity, child: primary),
              if (secondary != null) ...[
                const SizedBox(height: AppSpacing.s),
                SizedBox(width: double.infinity, child: secondary),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _welcome() => _layout(
    hero: const EmptyShelf(width: 200),
    title: 'Deine Filme. Alles an einem Ort.',
    text:
        'Speednema verbindet deine Discs, deine digitale Bibliothek und was '
        'du sehen möchtest – ohne Konto, wenn du willst.',
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
        'Optional: eigener Server zum Streamen und Teilen',
      ),
    ],
    primary: FilledButton(
      onPressed: () => _go(1),
      child: const Text('Los geht\'s'),
    ),
  );

  Widget _storagePage() {
    final cloud = ref.watch(cloudAvailableProvider);
    return _layout(
      title: 'Wo soll deine Sammlung liegen?',
      text: 'Du kannst das später ändern. Beim Umzug geht nichts verloren.',
      children: [
        RadioGroup<CollectionStorage>(
          groupValue: _storage,
          onChanged: (value) => value == CollectionStorage.cloud
              ? _chooseCloud()
              : setState(() => _storage = value!),
          child: Column(
            children: [
              const _StorageOption(
                value: CollectionStorage.local,
                title: 'Nur auf diesem Gerät',
                text:
                    'Kein Konto nötig. Deine Daten bleiben hier; Sicherungen '
                    'machst du selbst.',
              ),
              const _StorageOption(
                value: CollectionStorage.selfHosted,
                title: 'Eigener Speednema Server',
                text:
                    'Für Streaming und den Haushalt. Abgleich über deinen '
                    'Server, ganz ohne Hersteller-Konto.',
              ),
              // Offered only where this version supports it.
              if (cloud)
                const _StorageOption(
                  value: CollectionStorage.cloud,
                  title: 'Speednema Cloud',
                  text:
                      'Abgleich zwischen deinen Geräten ohne eigenen Server. '
                      '30 Tage kostenlos.',
                ),
            ],
          ),
        ),
      ],
      primary: FilledButton(
        onPressed: () => _go(1),
        child: const Text('Weiter'),
      ),
    );
  }

  Widget _serverPage() {
    final connected = ref.watch(serverClientProvider) != null;
    return _layout(
      title: 'Deinen Server verbinden',
      text:
          'Speednema findet ihn im WLAN von selbst. Du kannst auch seine '
          'Adresse eingeben oder den QR-Code aus dem Dashboard scannen.',
      children: [
        if (connected) const _Point(Icons.check_circle, 'Server verbunden'),
      ],
      primary: connected
          ? FilledButton(onPressed: () => _go(1), child: const Text('Weiter'))
          : FilledButton.icon(
              onPressed: () => context.push('/server/connect'),
              icon: const Icon(Icons.dns_outlined),
              label: const Text('Server verbinden'),
            ),
      secondary: connected
          ? null
          : TextButton(
              onPressed: () {
                // Without a server the collection stays on the device.
                setState(() => _storage = CollectionStorage.local);
                _go(1);
              },
              child: const Text('Später'),
            ),
    );
  }

  Widget _startPage() => _layout(
    title: 'Womit möchtest du anfangen?',
    text: 'Alles lässt sich auch später über „+“ erreichen.',
    children: [
      _Choice(
        Icons.qr_code_scanner,
        'Erste Disc scannen',
        () => _start('/scanner'),
      ),
      _Choice(
        Icons.search,
        'Film suchen und hinzufügen',
        () => _start('/search'),
      ),
      _Choice(Icons.playlist_add, 'Liste importieren', () => _start('/import')),
    ],
    primary: OutlinedButton(
      onPressed: () => _start('/home'),
      child: const Text('Erst einmal umsehen'),
    ),
  );
}

class _StorageOption extends StatelessWidget {
  const _StorageOption({
    required this.value,
    required this.title,
    required this.text,
  });

  final CollectionStorage value;
  final String title;
  final String text;

  @override
  Widget build(BuildContext context) => RadioListTile<CollectionStorage>(
    value: value,
    contentPadding: EdgeInsets.zero,
    title: Text(title, style: Theme.of(context).textTheme.titleMedium),
    subtitle: Text(text),
  );
}

class _Point extends StatelessWidget {
  const _Point(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: context.colors.textSecondary),
        const SizedBox(width: AppSpacing.m),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    ),
  );
}

class _Choice extends StatelessWidget {
  const _Choice(this.icon, this.text, this.onTap);

  final IconData icon;
  final String text;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.zero,
    leading: CircleAvatar(
      backgroundColor: context.colors.tint(context.colors.accent),
      foregroundColor: context.colors.text,
      child: Icon(icon),
    ),
    title: Text(text, style: Theme.of(context).textTheme.titleMedium),
    trailing: const Icon(Icons.chevron_right),
    onTap: onTap,
  );
}
