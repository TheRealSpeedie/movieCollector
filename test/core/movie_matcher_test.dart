import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/matching/movie_matcher.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';

void main() {
  const matcher = MovieMatcher();

  final candidates = [
    const TmdbSearchResult(id: 1, title: 'Der Pate'),
    const TmdbSearchResult(id: 2, title: 'Der Pate 2'),
    const TmdbSearchResult(id: 3, title: 'Ein völlig anderer Film'),
  ];

  test('ranks the closest title match highest', () {
    final ranked = matcher.rank('Der Pate DVD', candidates);
    expect(ranked.first.result.id, 1);
    expect(ranked.first.confidence, greaterThan(ranked.last.confidence));
  });

  test('bestMatch returns null for an empty candidate list', () {
    expect(matcher.bestMatch('Irgendein Titel', const []), isNull);
  });

  test('boosts confidence when the release year matches', () {
    final withYear = [
      TmdbSearchResult(id: 10, title: 'Dune', releaseDate: DateTime(2021)),
      TmdbSearchResult(id: 11, title: 'Dune', releaseDate: DateTime(1984)),
    ];
    final ranked = matcher.rank('Dune', withYear, year: 2021);
    expect(ranked.first.result.id, 10);
  });
}
