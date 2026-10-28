import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/media_format.dart';
import 'package:movie_shelf/features/discover/domain/discovery.dart';
import 'package:movie_shelf/features/discover/domain/query_parser.dart';
import 'package:movie_shelf/features/discover/domain/watch_suggestions.dart';

class FakeRanker implements DiscoveryRanker {
  FakeRanker(this.answer);

  final List<RankedPick> Function(List<Suggestion>) answer;
  List<Suggestion>? seen;

  @override
  String get label => 'Test-KI';

  @override
  Future<List<RankedPick>> rank(
    String? query,
    List<Suggestion> candidates,
    String language,
  ) async {
    seen = candidates;
    return answer(candidates);
  }
}

WatchCandidate film(
  String title, {
  int? year,
  int? runtime,
  List<String> genres = const [],
  bool watched = false,
}) => WatchCandidate(
  title: title,
  tmdbId: title.hashCode,
  movieId: title.length,
  year: year,
  runtime: runtime,
  genres: genres,
  watched: watched,
  ownedFormats: const [MediaFormat.bluray],
);

void main() {
  final films = [
    film('Hot Shots!', year: 1991, runtime: 84, genres: ['Komödie']),
    film('Heat', year: 1995, runtime: 170, genres: ['Krimi']),
    film('Arrival', year: 2016, runtime: 116, genres: ['Science Fiction']),
    film(
      'Groundhog Day',
      year: 1993,
      runtime: 101,
      genres: ['Comedy'],
      watched: true,
    ),
  ];

  Future<DiscoveryResult> run(String query, {DiscoveryRanker? ranker}) =>
      Discovery(ranker: ranker).run(
        query: query,
        candidates: films,
        filter: const SuggestionFilter(),
        subscriptions: const {},
        language: 'de',
      );

  test('a wish in plain words becomes filters', () {
    final parsed = const QueryParser().parse(
      'Etwas Lustiges unter 2 Stunden aus den 90ern',
    );
    expect(parsed.genres, containsAll(['komödie', 'comedy']));
    expect(parsed.maxRuntime, 120);
    expect((parsed.fromYear, parsed.toYear), (1990, 1999));

    final english = const QueryParser().parse(
      'a short sci-fi I can watch again',
    );
    expect(english.maxRuntime, 100);
    expect(english.genres, contains('science fiction'));
    expect(english.includeWatched, isTrue);
    expect(const QueryParser().parse('irgendwas').isEmpty, isTrue);
  });

  test('without AI the rules answer, offline', () async {
    final result = await run('lustig aus den 90ern');
    expect(result.engine, 'Regeln');
    expect(result.suggestions.map((s) => s.candidate.title), ['Hot Shots!']);

    final again = await run('lustig, gern nochmal');
    expect(again.suggestions, hasLength(2));
  });

  test('an AI only reorders what the rules found and explains it', () async {
    final ranker = FakeRanker(
      (c) => [
        const RankedPick(1, 'Ruhig und klug'),
        const RankedPick(7, 'erfunden'),
      ],
    );
    final result = await run('', ranker: ranker);

    expect(
      ranker.seen!.map((s) => s.candidate.title),
      isNot(contains('Groundhog Day')),
    );
    expect(result.engine, 'Test-KI');
    expect(result.suggestions.single.reasons.first, 'Ruhig und klug');
  });

  test('when the AI fails, the own suggestions stay', () async {
    final result = await run(
      '',
      ranker: FakeRanker((_) => throw Exception('offline')),
    );
    expect(result.engine, 'Regeln');
    expect(result.notice, contains('nicht erreichbar'));
    expect(result.suggestions, hasLength(3));
  });

  test('only the shortlist leaves the device, without library ids', () {
    final local = Discovery.localSuggestions(
      parsed: const ParsedQuery(),
      candidates: films,
      filter: const SuggestionFilter(),
      subscriptions: const {},
    );
    final payload = RemoteDiscoveryRanker.payload('etwas Kluges', local, 'de');
    final first = (payload['candidates'] as List).first as Map;

    expect(first['id'], 'c0');
    expect(
      first.keys,
      isNot(containsAll(['tmdbId', 'movieId', 'serverTitleId', 'posterPath'])),
    );
    for (final key in [
      'tmdbId',
      'movieId',
      'serverTitleId',
      'posterPath',
      'rating',
      'offers',
    ]) {
      expect(first.containsKey(key), isFalse, reason: key);
    }
    expect(first['availability'], ['owned']);
  });
}
