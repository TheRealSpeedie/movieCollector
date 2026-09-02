enum MediaKindHint {
  unknown,
  singleMovie,
  movieBoxSet,
  singleTvSeason,
  multiSeasonTvBox,
  completeTvSeries,
}

class MediaParseResult {
  const MediaParseResult({
    required this.cleanedTitle,
    required this.kind,
    this.seasonNumbers = const [],
    this.parsedYear,
  });

  final String cleanedTitle;
  final MediaKindHint kind;
  final List<int> seasonNumbers;
  final int? parsedYear;

  bool get isTv =>
      kind == MediaKindHint.singleTvSeason ||
      kind == MediaKindHint.multiSeasonTvBox ||
      kind == MediaKindHint.completeTvSeries;

  bool get isMovieBox => kind == MediaKindHint.movieBoxSet;
}

class MediaTitleParser {
  const MediaTitleParser();

  static const _ordinals = <String, int>{
    'first': 1,
    'second': 2,
    'third': 3,
    'fourth': 4,
    'fifth': 5,
    'sixth': 6,
    'seventh': 7,
    'eighth': 8,
    'ninth': 9,
    'tenth': 10,
    'eleventh': 11,
    'twelfth': 12,
    'erste': 1,
    'erster': 1,
    'ersten': 1,
    'zweite': 2,
    'zweiter': 2,
    'zweiten': 2,
    'dritte': 3,
    'dritter': 3,
    'dritten': 3,
    'vierte': 4,
    'vierter': 4,
    'vierten': 4,
    'fünfte': 5,
    'fuenfte': 5,
    'fünfter': 5,
    'fünften': 5,
    'sechste': 6,
    'sechster': 6,
    'sechsten': 6,
    'siebte': 7,
    'siebter': 7,
    'siebten': 7,
    'achte': 8,
    'achter': 8,
    'achten': 8,
    'neunte': 9,
    'neunter': 9,
    'neunten': 9,
    'zehnte': 10,
    'zehnter': 10,
    'zehnten': 10,
  };

  static final _yearPattern = RegExp(r'\((19|20)\d{2}\)|\b((?:19|20)\d{2})\b');

  static final _completeSeasonOrdinal = RegExp(
    r'(?:the\s+)?complete\s+(?<ord>[a-z]+|\d+(?:st|nd|rd|th)?)\s+season',
    caseSensitive: false,
  );
  static final _completeSeasonGerman = RegExp(
    r'(?:die\s+)?komplette\s+(?<ord>[a-zäöüß]+|\d+\.?)\s+staffel',
    caseSensitive: false,
  );
  static final _completeSeasonNumbered = RegExp(
    r'complete\s+season\s+(?<n>\d+)|komplette\s+staffel\s+(?<n2>\d+)',
    caseSensitive: false,
  );

  static final _completeSeries = RegExp(
    r'\b(complete\s+series|komplette\s+serie|komplettbox|gesamtbox|'
    r'complete\s+collection|komplette\s+collection|komplette\s+sammlung|'
    r'die\s+komplette\s+serie)\b',
    caseSensitive: false,
  );

  static final _seasonRange = RegExp(
    r'\b(?:staffeln?|seasons?)\s+(?<a>\d+)\s*(?:-|–|bis)\s*(?<b>\d+)\b',
    caseSensitive: false,
  );
  static final _seasonList = RegExp(
    r'\b(?:staffeln?|seasons?)\s+(?<list>\d+(?:\s*(?:,|&|und)\s*\d+)+)\b',
    caseSensitive: false,
  );
  static final _singleSeason = RegExp(
    r'\b(?:staffel|season)\s+(?<n>\d+)\b',
    caseSensitive: false,
  );

  static final _movieBox = RegExp(
    r"\b(collector'?s?\s+box|collectors?\s+box|sammlerbox|sammelbox|"
    r'box[\s-]?set|filmreihe|complete\s+collection|\d+[\s-]?film\s+collection|'
    r'\d+[\s-]?film[\s-]?collection)\b',
    caseSensitive: false,
  );
  static final _genericCollection = RegExp(
    r'\bcollection\b',
    caseSensitive: false,
  );

  MediaParseResult parse(String raw) {
    final year = _extractYear(raw);
    var working = raw.trim();
    working = working.replaceAll(_yearPattern, ' ');
    working = working.replaceAll(RegExp(r'\s+'), ' ').trim();

    final completeSeason = _matchCompleteSeason(working);
    if (completeSeason != null) {
      return MediaParseResult(
        cleanedTitle: _stripNoise(working, completeSeason.matched),
        kind: MediaKindHint.singleTvSeason,
        seasonNumbers: [completeSeason.number],
        parsedYear: year,
      );
    }

    if (_completeSeries.hasMatch(working) &&
        !_looksLikeCompleteSeasonPhrase(working)) {
      return MediaParseResult(
        cleanedTitle: _stripNoise(
          working,
          _completeSeries.firstMatch(working)!.group(0)!,
        ),
        kind: MediaKindHint.completeTvSeries,
        parsedYear: year,
      );
    }

    final range = _seasonRange.firstMatch(working);
    if (range != null) {
      final a = int.parse(range.namedGroup('a')!);
      final b = int.parse(range.namedGroup('b')!);
      final from = a < b ? a : b;
      final to = a < b ? b : a;
      return MediaParseResult(
        cleanedTitle: _stripNoise(working, range.group(0)!),
        kind: MediaKindHint.multiSeasonTvBox,
        seasonNumbers: [for (var n = from; n <= to; n++) n],
        parsedYear: year,
      );
    }

    final list = _seasonList.firstMatch(working);
    if (list != null) {
      final numbers = RegExp(r'\d+')
          .allMatches(list.namedGroup('list')!)
          .map((m) => int.parse(m.group(0)!))
          .toList();
      return MediaParseResult(
        cleanedTitle: _stripNoise(working, list.group(0)!),
        kind: numbers.length == 1
            ? MediaKindHint.singleTvSeason
            : MediaKindHint.multiSeasonTvBox,
        seasonNumbers: numbers,
        parsedYear: year,
      );
    }

    final single = _singleSeason.firstMatch(working);
    if (single != null) {
      return MediaParseResult(
        cleanedTitle: _stripNoise(working, single.group(0)!),
        kind: MediaKindHint.singleTvSeason,
        seasonNumbers: [int.parse(single.namedGroup('n')!)],
        parsedYear: year,
      );
    }

    final box = _movieBox.firstMatch(working);
    if (box != null) {
      return MediaParseResult(
        cleanedTitle: _stripNoise(working, box.group(0)!),
        kind: MediaKindHint.movieBoxSet,
        parsedYear: year,
      );
    }

    if (_genericCollection.hasMatch(working) &&
        !_completeSeries.hasMatch(working)) {
      return MediaParseResult(
        cleanedTitle: _stripNoise(
          working,
          _genericCollection.firstMatch(working)!.group(0)!,
        ),
        kind: MediaKindHint.movieBoxSet,
        parsedYear: year,
      );
    }

    return MediaParseResult(
      cleanedTitle: working.trim().isEmpty ? raw.trim() : working.trim(),
      kind: MediaKindHint.unknown,
      parsedYear: year,
    );
  }

  bool _looksLikeCompleteSeasonPhrase(String input) {
    return _completeSeasonOrdinal.hasMatch(input) ||
        _completeSeasonGerman.hasMatch(input) ||
        _completeSeasonNumbered.hasMatch(input);
  }

  ({int number, String matched})? _matchCompleteSeason(String input) {
    final numbered = _completeSeasonNumbered.firstMatch(input);
    if (numbered != null) {
      final n = int.parse(
        numbered.namedGroup('n') ?? numbered.namedGroup('n2')!,
      );
      return (number: n, matched: numbered.group(0)!);
    }
    final en = _completeSeasonOrdinal.firstMatch(input);
    if (en != null) {
      final number = _ordinalToNumber(en.namedGroup('ord')!);
      if (number != null) return (number: number, matched: en.group(0)!);
    }
    final de = _completeSeasonGerman.firstMatch(input);
    if (de != null) {
      final number = _ordinalToNumber(de.namedGroup('ord')!);
      if (number != null) return (number: number, matched: de.group(0)!);
    }
    return null;
  }

  int? _ordinalToNumber(String raw) {
    final cleaned = raw.toLowerCase().replaceAll('.', '').trim();
    final digits = RegExp(r'\d+').firstMatch(cleaned);
    if (digits != null) return int.parse(digits.group(0)!);
    return _ordinals[cleaned];
  }

  int? _extractYear(String raw) {
    final match = _yearPattern.firstMatch(raw);
    if (match == null) return null;
    final token = match.group(0)!.replaceAll(RegExp(r'[^0-9]'), '');
    return int.tryParse(token);
  }

  String _stripNoise(String input, String matched) {
    var value = input.replaceAll(matched, ' ');
    value = value.replaceAll(RegExp(r'[-–—,:]+\s*$'), '');
    value = value.replaceAll(RegExp(r'\s+'), ' ').trim();
    value = value.replaceAll(RegExp(r'^[-–—,:]+\s*'), '');
    return value.trim();
  }
}
