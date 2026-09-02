import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/matching/media_title_parser.dart';

void main() {
  const parser = MediaTitleParser();

  test('parses a single German season', () {
    final result = parser.parse('Supernatural Staffel 4');
    expect(result.kind, MediaKindHint.singleTvSeason);
    expect(result.seasonNumbers, [4]);
    expect(result.cleanedTitle, 'Supernatural');
  });

  test('parses a single English season', () {
    final result = parser.parse('Supernatural Season 4');
    expect(result.kind, MediaKindHint.singleTvSeason);
    expect(result.seasonNumbers, [4]);
  });

  test('complete fourth season is a single season, not the series', () {
    final result = parser.parse('Supernatural – The Complete Fourth Season');
    expect(result.kind, MediaKindHint.singleTvSeason);
    expect(result.seasonNumbers, [4]);
  });

  test('German complete season ordinal stays a single season', () {
    final result = parser.parse('Supernatural Die komplette vierte Staffel');
    expect(result.kind, MediaKindHint.singleTvSeason);
    expect(result.seasonNumbers, [4]);
  });

  test('complete series keywords map to the whole series', () {
    for (final title in [
      'Supernatural Complete Series',
      'Supernatural Komplettbox',
      'Breaking Bad komplette Serie',
    ]) {
      final result = parser.parse(title);
      expect(result.kind, MediaKindHint.completeTvSeries, reason: title);
      expect(result.seasonNumbers, isEmpty);
    }
  });

  test('parses a season range', () {
    final result = parser.parse('Supernatural Staffel 1-5');
    expect(result.kind, MediaKindHint.multiSeasonTvBox);
    expect(result.seasonNumbers, [1, 2, 3, 4, 5]);
  });

  test('parses German bis ranges and English en-dash ranges', () {
    expect(parser.parse('Supernatural Staffeln 1 bis 5').seasonNumbers, [
      1,
      2,
      3,
      4,
      5,
    ]);
    expect(parser.parse('Supernatural Seasons 1–5').seasonNumbers, [
      1,
      2,
      3,
      4,
      5,
    ]);
  });

  test('parses comma-separated and ampersand season lists', () {
    expect(parser.parse('Dexter Staffel 1, 2 und 3').seasonNumbers, [1, 2, 3]);
    expect(parser.parse('Game of Thrones Staffel 1 & 2').seasonNumbers, [1, 2]);
    expect(parser.parse('Game of Thrones Staffel 1, 2, 3').seasonNumbers, [
      1,
      2,
      3,
    ]);
  });

  test('recognizes movie collector-box keywords', () {
    expect(
      parser.parse("Sharknado Collector's Box").kind,
      MediaKindHint.movieBoxSet,
    );
    expect(
      parser.parse('Harry Potter 8-Film Collection').kind,
      MediaKindHint.movieBoxSet,
    );
    expect(
      parser.parse('Fast & Furious 1-10 Collection').kind,
      MediaKindHint.movieBoxSet,
    );
  });
}
