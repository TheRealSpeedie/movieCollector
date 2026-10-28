import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../settings/application/settings_providers.dart';
import '../../watch/application/watch_providers.dart';
import '../application/discovery_providers.dart';
import '../domain/discovery.dart';
import '../domain/query_parser.dart';
import '../domain/watch_suggestions.dart';

final suggestionFilterProvider = StateProvider<SuggestionFilter>(
  (ref) => const SuggestionFilter(),
);

/// "Was soll ich schauen?": filters over the collection, the home server and
/// the user's subscriptions, every suggestion with its reasons. A wish in
/// plain words is understood on the device; AI ordering is optional.
class WhatToWatchScreen extends ConsumerStatefulWidget {
  const WhatToWatchScreen({super.key, this.initialSources});

  final Set<SuggestionSource>? initialSources;

  @override
  ConsumerState<WhatToWatchScreen> createState() => _WhatToWatchScreenState();
}

class _WhatToWatchScreenState extends ConsumerState<WhatToWatchScreen> {
  var _checking = false;
  final _wish = TextEditingController();
  var _query = '';
  DiscoveryResult? _ai;
  var _asking = false;

  @override
  void dispose() {
    _wish.dispose();
    super.dispose();
  }

  /// Runs the wish through the rules and, when allowed, an AI ranker.
  Future<void> _submit() async {
    setState(() {
      _query = _wish.text.trim();
      _ai = null;
    });
    final ranker = await ref.read(discoveryRankerProvider.future);
    if (ranker == null || !mounted) return;
    setState(() => _asking = true);
    final result = await Discovery(ranker: ranker).run(
      query: _query,
      candidates: ref.read(watchCandidatesProvider).valueOrNull ?? const [],
      filter: ref.read(suggestionFilterProvider),
      subscriptions: ref.read(subscribedIdsProvider),
      language: 'de',
      preferredLanguage: ref.read(userPreferencesProvider).audioLanguage,
    );
    if (!mounted) return;
    setState(() {
      _asking = false;
      _ai = result;
    });
  }

  /// Asks once, saying exactly what would be sent.
  Future<void> _toggleAi(bool on) async {
    if (!on) {
      await ref.read(aiConsentProvider.notifier).set(false);
      setState(() => _ai = null);
      return;
    }
    final ranker = ref.read(remoteRankerProvider).valueOrNull;
    final agreed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KI-Vorschläge einschalten?'),
        content: Text(
          'Movie Shelf findet Vorschläge immer selbst. Mit KI werden sie '
          'zusätzlich sortiert und erklärt (${ranker?.label ?? 'KI-Dienst'}).\n\n'
          'Gesendet wird nur, wenn du etwas suchst: dein Wunsch und bis zu 40 '
          'Filme, die schon passen, mit Titel, Jahr, Genres, Länge, ob du sie '
          'gesehen hast und wo sie verfügbar sind.\n\n'
          'Nie gesendet: deine Sammlung, Exemplare, Haushalt, Konto oder '
          'Videodateien. Du kannst es jederzeit wieder ausschalten.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Nein danke'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Einschalten'),
          ),
        ],
      ),
    );
    if (agreed == true) await ref.read(aiConsentProvider.notifier).set(true);
  }

  @override
  void initState() {
    super.initState();
    final sources = widget.initialSources;
    if (sources != null) {
      Future.microtask(
        () => ref.read(suggestionFilterProvider.notifier).state = ref
            .read(suggestionFilterProvider)
            .copyWith(sources: sources),
      );
    }
  }

  Future<void> _checkOffers() async {
    setState(() => _checking = true);
    final fetched = await ref.read(offerRefresherProvider).refresh();
    if (!mounted) return;
    setState(() => _checking = false);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          fetched == 0
              ? 'Alle Angebote sind aktuell.'
              : 'Angebote für $fetched Filme geprüft.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filter = ref.watch(suggestionFilterProvider);
    final candidates = ref.watch(watchCandidatesProvider);
    final subscriptions = ref.watch(subscribedIdsProvider);
    final preferences = ref.watch(userPreferencesProvider);
    void update(SuggestionFilter f) =>
        ref.read(suggestionFilterProvider.notifier).state = f;

    final all = candidates.valueOrNull ?? const [];
    final genres = {for (final c in all) ...c.genres}.toList()..sort();
    final parsed = _query.isEmpty
        ? const ParsedQuery()
        : const QueryParser().parse(_query);
    final ai = _ai;
    final suggestions =
        ai?.suggestions ??
        Discovery.localSuggestions(
          parsed: parsed,
          candidates: all,
          filter: filter,
          subscriptions: subscriptions,
          preferredLanguage: preferences.audioLanguage,
        );
    final remote = ref.watch(remoteRankerProvider).valueOrNull;
    final consent = ref.watch(aiConsentProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Was soll ich schauen?'),
        actions: [
          IconButton(
            tooltip: 'Streaming-Angebote prüfen',
            onPressed: _checking ? null : _checkOffers,
            icon: _checking
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.travel_explore),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          TextField(
            controller: _wish,
            textInputAction: TextInputAction.search,
            onSubmitted: (_) => _submit(),
            decoration: InputDecoration(
              labelText: 'Worauf hast du Lust?',
              hintText: 'z. B. etwas Lustiges unter 2 Stunden',
              suffixIcon: IconButton(
                tooltip: 'Vorschläge finden',
                icon: const Icon(Icons.search),
                onPressed: _submit,
              ),
            ),
          ),
          if (parsed.understood.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                'Verstanden: ${parsed.understood.join(' · ')}',
                style: const TextStyle(color: AppColors.neutralGray),
              ),
            ),
          if (remote != null)
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('KI-Vorschläge'),
              subtitle: Text(
                consent
                    ? 'An: ${remote.label}. Nur beim Suchen wird etwas gesendet.'
                    : 'Aus. Vorschläge kommen nur von diesem Gerät.',
              ),
              value: consent,
              onChanged: _toggleAi,
            ),
          if (_asking) const LinearProgressIndicator(),
          if (ai?.notice != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                ai!.notice!,
                style: const TextStyle(color: AppColors.amber),
              ),
            ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (final source in SuggestionSource.values)
                FilterChip(
                  label: Text(source.label),
                  selected: filter.sources.contains(source),
                  onSelected: (on) {
                    final next = {...filter.sources};
                    on ? next.add(source) : next.remove(source);
                    if (next.isNotEmpty) update(filter.copyWith(sources: next));
                  },
                ),
              FilterChip(
                label: const Text('Nur ungesehen'),
                selected: filter.unwatchedOnly,
                onSelected: (on) => update(filter.copyWith(unwatchedOnly: on)),
              ),
              FilterChip(
                label: Text(
                  'Original ${languageNames[preferences.audioLanguage] ?? preferences.audioLanguage}',
                ),
                selected: filter.language != null,
                onSelected: (on) => update(
                  on
                      ? filter.copyWith(language: preferences.audioLanguage)
                      : filter.copyWith(clearLanguage: true),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String?>(
                  initialValue: filter.genre,
                  decoration: const InputDecoration(labelText: 'Genre'),
                  items: [
                    const DropdownMenuItem(value: null, child: Text('Alle')),
                    for (final g in genres)
                      DropdownMenuItem(value: g, child: Text(g)),
                  ],
                  onChanged: (g) => update(
                    g == null
                        ? filter.copyWith(clearGenre: true)
                        : filter.copyWith(genre: g),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<int?>(
                  initialValue: filter.maxRuntime,
                  decoration: const InputDecoration(labelText: 'Länge'),
                  items: const [
                    DropdownMenuItem(value: null, child: Text('Egal')),
                    DropdownMenuItem(value: 90, child: Text('bis 90 Min.')),
                    DropdownMenuItem(value: 100, child: Text('bis 100 Min.')),
                    DropdownMenuItem(value: 120, child: Text('bis 2 Std.')),
                    DropdownMenuItem(value: 150, child: Text('bis 2½ Std.')),
                  ],
                  onChanged: (m) => update(
                    m == null
                        ? filter.copyWith(clearRuntime: true)
                        : filter.copyWith(maxRuntime: m),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (candidates.isLoading && all.isEmpty)
            const Center(child: CircularProgressIndicator())
          else if (suggestions.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                subscriptions.isEmpty &&
                        filter.sources.contains(SuggestionSource.subscription)
                    ? 'Nichts passt. Tipp: Gib unter Mehr → Streamingdienste '
                          'deine Abos an und prüfe die Angebote oben rechts.'
                    : 'Nichts passt zu diesen Filtern.',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.neutralGray),
              ),
            )
          else
            Text(
              ai != null && ai.engine != 'Regeln'
                  ? '${suggestions.length} Vorschläge, ausgewählt von ${ai.engine}'
                  : '${suggestions.length} Vorschläge',
              style: const TextStyle(color: AppColors.neutralGray),
            ),
          for (final s in suggestions.take(60))
            Card(
              child: ListTile(
                leading: SizedBox(
                  width: 44,
                  child: s.candidate.posterPath != null
                      ? PosterImage(posterPath: s.candidate.posterPath)
                      : const Icon(Icons.movie_outlined, size: 32),
                ),
                title: Text(
                  s.candidate.year == null
                      ? s.candidate.title
                      : '${s.candidate.title} (${s.candidate.year})',
                ),
                subtitle: Text(s.reasons.join(' · ')),
                isThreeLine: s.reasons.length > 2,
                onTap: () {
                  if (s.candidate.movieId != null) {
                    context.push('/movie/${s.candidate.movieId}');
                  } else if (s.candidate.serverTitleId != null) {
                    context.push('/server/title/${s.candidate.serverTitleId}');
                  }
                },
              ),
            ),
        ],
      ),
    );
  }
}
