import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';
import '../../../core/config/config_providers.dart';
import '../../../core/health/health_providers.dart';
import '../../../core/health/service_health.dart';
import '../../../core/providers/core_providers.dart';
import '../../../shared/widgets/connection_badge.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/settings_group.dart';

/// Filminfos: whether movie information from TMDB works, where the key
/// comes from, and, only when needed, a place for an own key.
class MetadataSettingsScreen extends ConsumerStatefulWidget {
  const MetadataSettingsScreen({super.key});

  @override
  ConsumerState<MetadataSettingsScreen> createState() =>
      _MetadataSettingsScreenState();
}

class _MetadataSettingsScreenState
    extends ConsumerState<MetadataSettingsScreen> {
  final _token = TextEditingController();
  bool _checking = false;
  bool _saving = false;
  bool _showOwnKey = false;

  @override
  void initState() {
    super.initState();
    // Check once on arrival when nobody has asked TMDB yet.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(serviceHealthProvider(ExternalService.tmdb))
          is HealthUnknown) {
        _check(quiet: true);
      }
    });
  }

  @override
  void dispose() {
    _token.dispose();
    super.dispose();
  }

  Future<void> _check({bool quiet = false}) async {
    if (!ref.read(tmdbConfiguredProvider)) return;
    setState(() => _checking = true);
    Object? failure;
    try {
      await ref.read(tmdbApiClientProvider).checkCredentials();
    } catch (error) {
      failure = error;
    }
    if (!mounted) return;
    setState(() => _checking = false);
    if (!quiet) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            failure == null
                ? 'Filminfos funktionieren.'
                : classifyError(failure).title,
          ),
        ),
      );
    }
  }

  Future<void> _saveOwnKey(String? token) async {
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await ref.read(tmdbTokenStoreProvider).write(token);
      ref.read(tmdbUserTokenProvider.notifier).state = token?.trim();
      _token.clear();
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Der Schlüssel konnte nicht gespeichert werden.'),
        ),
      );
      if (mounted) setState(() => _saving = false);
      return;
    }
    if (!mounted) return;
    setState(() => _saving = false);
    if (token != null && token.trim().isNotEmpty) await _check();
  }

  @override
  Widget build(BuildContext context) {
    final health = ref.watch(serviceHealthProvider(ExternalService.tmdb));
    final source = ref.watch(tmdbKeySourceProvider);
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final needsOwnKey =
        source == TmdbKeySource.none || health is HealthInvalidCredentials;

    return Scaffold(
      appBar: AppBar(title: const Text('Filminfos')),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              0,
              AppSpacing.l,
              AppSpacing.m,
            ),
            child: Text(
              'Titel, Poster, Beschreibungen und Reihen kommen von TMDB, '
              'einer freien Filmdatenbank. Deine Sammlung selbst bleibt '
              'auf deinen Geräten und funktioniert auch ohne.',
              style: text.bodyLarge?.copyWith(color: colors.textSecondary),
            ),
          ),
          SettingsGroup(
            title: 'Status',
            children: [
              ListTile(
                leading: Icon(
                  Icons.movie_outlined,
                  color: colors.textSecondary,
                ),
                title: const Text('TMDB'),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: _checking
                        ? const ConnectionBadge(
                            tone: ConnectionTone.busy,
                            label: 'Wird geprüft …',
                          )
                        : _badge(health),
                  ),
                ),
                trailing: source == TmdbKeySource.none
                    ? null
                    : TextButton(
                        onPressed: _checking ? null : () => _check(),
                        child: const Text('Prüfen'),
                      ),
              ),
              SettingsTile.info(
                icon: Icons.key_outlined,
                title: 'Schlüssel',
                value: switch (source) {
                  TmdbKeySource.build => 'In der App enthalten',
                  TmdbKeySource.user => 'Eigener Schlüssel',
                  TmdbKeySource.none => 'Keiner',
                },
              ),
            ],
          ),
          if (needsOwnKey || _showOwnKey || source == TmdbKeySource.user)
            _ownKey(context, source)
          else
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: Align(
                alignment: AlignmentDirectional.centerStart,
                child: TextButton(
                  onPressed: () => setState(() => _showOwnKey = true),
                  child: const Text('Eigenen Schlüssel verwenden'),
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.l),
            child: Text(
              'Speednema nutzt die TMDB-API, wird aber nicht von TMDB '
              'unterstützt oder zertifiziert.',
              style: text.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ownKey(BuildContext context, TmdbKeySource source) {
    return SettingsGroup(
      title: 'Eigener Schlüssel',
      footer:
          'Nur nötig, wenn diese Version keinen Schlüssel enthält oder er '
          'nicht mehr funktioniert. Den kostenlosen „API-Lesezugriffstoken“ '
          'findest du bei themoviedb.org unter Einstellungen › API.',
      children: [
        Padding(
          padding: const EdgeInsets.all(AppSpacing.l),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: _token,
                obscureText: true,
                autocorrect: false,
                enableSuggestions: false,
                decoration: const InputDecoration(
                  labelText: 'API-Lesezugriffstoken',
                ),
                onSubmitted: (value) => _saveOwnKey(value),
              ),
              const SizedBox(height: AppSpacing.m),
              Wrap(
                spacing: AppSpacing.s,
                runSpacing: AppSpacing.s,
                children: [
                  FilledButton(
                    onPressed: _saving ? null : () => _saveOwnKey(_token.text),
                    child: const Text('Speichern'),
                  ),
                  if (source == TmdbKeySource.user)
                    OutlinedButton(
                      onPressed: _saving ? null : () => _saveOwnKey(null),
                      child: const Text('Eigenen Schlüssel entfernen'),
                    ),
                  TextButton(
                    onPressed: () => launchUrl(
                      Uri.parse('https://www.themoviedb.org/settings/api'),
                      mode: LaunchMode.externalApplication,
                    ),
                    child: const Text('Token bei TMDB holen'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _badge(ServiceHealth health) => ConnectionBadge(
    tone: switch (health) {
      HealthOk() => ConnectionTone.ok,
      HealthInvalidCredentials() ||
      HealthRateLimited() => ConnectionTone.attention,
      HealthOffline() || HealthUnavailable() => ConnectionTone.offline,
      HealthUnknown() || HealthNotConfigured() => ConnectionTone.none,
    },
    label: health.summary,
  );
}
