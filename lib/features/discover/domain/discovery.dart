import 'query_parser.dart';
import 'watch_suggestions.dart';

/// One AI choice: which candidate and why.
class RankedPick {
  const RankedPick(this.index, this.reason);

  /// Position in the candidate list that was sent.
  final int index;
  final String reason;
}

/// Something that can order the device's own suggestions for a wish: a
/// model on the device or a service the person agreed to use.
abstract interface class DiscoveryRanker {
  /// Shown with the results, for example "KI über Movie Shelf Cloud".
  String get label;

  Future<List<RankedPick>> rank(
    String? query,
    List<Suggestion> candidates,
    String language,
  );
}

/// A language model running on the device. None is bundled, so basic
/// discovery never needs a large download; a build can provide one here.
abstract interface class OnDeviceModel implements DiscoveryRanker {
  Future<bool> isReady();
}

class DiscoveryResult {
  const DiscoveryResult({
    required this.suggestions,
    required this.engine,
    this.parsed = const ParsedQuery(),
    this.notice,
  });

  final List<Suggestion> suggestions;

  /// Who chose: "Regeln" or the ranker's label.
  final String engine;
  final ParsedQuery parsed;

  /// Why the AI was not used this time, for example no connection.
  final String? notice;
}

/// Finds something to watch. Always works offline with rules; a ranker, when
/// one is given, only reorders and explains what the rules already found, so
/// it never sees more than these candidates.
class Discovery {
  const Discovery({this.ranker, this.maxSent = 40});

  final DiscoveryRanker? ranker;
  final int maxSent;

  Future<DiscoveryResult> run({
    required String query,
    required List<WatchCandidate> candidates,
    required SuggestionFilter filter,
    required Set<int> subscriptions,
    required String language,
    String? preferredLanguage,
  }) async {
    final parsed = query.trim().isEmpty
        ? const ParsedQuery()
        : const QueryParser().parse(query);
    final local = localSuggestions(
      parsed: parsed,
      candidates: candidates,
      filter: filter,
      subscriptions: subscriptions,
      preferredLanguage: preferredLanguage,
    );
    final model = ranker;
    if (model == null || local.isEmpty) {
      return DiscoveryResult(
        suggestions: local,
        engine: 'Regeln',
        parsed: parsed,
      );
    }
    // Filters already say everything, or there is barely anything to
    // choose from: asking a model would only cost time and money.
    if (parsed.freeText.isEmpty || local.length < 3) {
      return DiscoveryResult(
        suggestions: local,
        engine: 'Regeln',
        parsed: parsed,
        notice: 'Dafür reichen deine Filter – ohne KI.',
      );
    }

    final sent = local.take(maxSent).toList();
    try {
      final picks = await model.rank(
        query.trim().isEmpty ? null : query.trim(),
        sent,
        language,
      );
      final chosen = <Suggestion>[];
      final seen = <int>{};
      for (final pick in picks) {
        if (pick.index < 0 ||
            pick.index >= sent.length ||
            !seen.add(pick.index)) {
          continue;
        }
        final s = sent[pick.index];
        chosen.add(
          Suggestion(
            candidate: s.candidate,
            sources: s.sources,
            reasons: [if (pick.reason.isNotEmpty) pick.reason, ...s.reasons],
          ),
        );
      }
      if (chosen.isEmpty) {
        return DiscoveryResult(
          suggestions: local,
          engine: 'Regeln',
          parsed: parsed,
          notice: 'Die KI hatte keinen Vorschlag; hier sind deine eigenen.',
        );
      }
      return DiscoveryResult(
        suggestions: chosen,
        engine: model.label,
        parsed: parsed,
      );
    } on Exception {
      return DiscoveryResult(
        suggestions: local,
        engine: 'Regeln',
        parsed: parsed,
        notice:
            'KI gerade nicht erreichbar – hier sind deine eigenen Vorschläge.',
      );
    }
  }

  /// The rules alone: filters from the wish, then the usual suggestions.
  static List<Suggestion> localSuggestions({
    required ParsedQuery parsed,
    required List<WatchCandidate> candidates,
    required SuggestionFilter filter,
    required Set<int> subscriptions,
    String? preferredLanguage,
  }) {
    final effective = SuggestionFilter(
      genre: filter.genre,
      maxRuntime: parsed.maxRuntime ?? filter.maxRuntime,
      sources: filter.sources,
      unwatchedOnly: filter.unwatchedOnly && !parsed.includeWatched,
      language: filter.language,
    );
    final matching = [
      for (final c in candidates)
        if ((parsed.genres.isEmpty ||
                c.genres.any((g) => parsed.genres.contains(g.toLowerCase()))) &&
            (parsed.fromYear == null ||
                (c.year != null && c.year! >= parsed.fromYear!)) &&
            (parsed.toYear == null ||
                (c.year != null && c.year! <= parsed.toYear!)))
          c,
    ];
    return suggest(
      matching,
      effective,
      subscriptions: subscriptions,
      preferredLanguage: preferredLanguage,
    );
  }
}

/// Asks the own server or Movie Shelf Cloud. Sends only the wish and, per
/// candidate, title, year, genres, length, whether it was watched and where
/// it is available, under a numbered id. No collection, household or
/// account data, no ids that identify the person's library.
class RemoteDiscoveryRanker implements DiscoveryRanker {
  RemoteDiscoveryRanker({required this.label, required this.post});

  @override
  final String label;
  final Future<dynamic> Function(String path, Object? body) post;

  static Map<String, Object?> payload(
    String? query,
    List<Suggestion> candidates,
    String language,
  ) => {
    'query': query,
    'language': language,
    'candidates': [
      for (var i = 0; i < candidates.length; i++)
        {
          'id': 'c$i',
          'title': candidates[i].candidate.title,
          'year': candidates[i].candidate.year,
          'genres': candidates[i].candidate.genres,
          'runtime': candidates[i].candidate.runtime,
          'watched': candidates[i].candidate.watched,
          'availability': [
            for (final s in candidates[i].sources)
              switch (s) {
                SuggestionSource.server => 'server',
                SuggestionSource.subscription => 'streaming',
                SuggestionSource.shelf => 'owned',
              },
          ],
        },
    ],
  };

  @override
  Future<List<RankedPick>> rank(
    String? query,
    List<Suggestion> candidates,
    String language,
  ) async {
    final answer =
        await post('/api/discover', payload(query, candidates, language))
            as Map<String, dynamic>;
    return [
      for (final p in answer['picks'] as List? ?? [])
        if (int.tryParse('${(p as Map)['id']}'.replaceFirst('c', ''))
            case final index?)
          RankedPick(index, p['reason'] as String? ?? ''),
    ];
  }
}
