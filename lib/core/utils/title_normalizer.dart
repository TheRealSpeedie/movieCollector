class TitleNormalizer {
  TitleNormalizer._();

  static final RegExp _bracketedNoise = RegExp(
    r"[\[\(][^\]\)]*(dvd|blu-?ray|steelbook|edition|disc|uncut|kinofassung|remastered|4k|uhd|region)[^\]\)]*[\]\)]",
    caseSensitive: false,
  );

  static final RegExp _noiseWords = RegExp(
    r"\b(dvd|blu-?ray|blu ray|steelbook|special edition|limited edition|collector'?s edition|ultimate edition|"
    r"extended edition|extended cut|director'?s cut|kinofassung|deutsche fassung|uncut|"
    r"remastered|theatrical cut|4k|uhd|ultra hd|region\s?\d|\d+\s?discs?|disc\s?\d+)\b",
    caseSensitive: false,
  );

  static final RegExp _leadingBullets = RegExp(
    r"^\s*([-•*]|\[\s?[xX ]?\s?\]|\d+[.)]|\d+\s?[-–])\s*",
  );
  static final RegExp _punctuation = RegExp(r'[^\w\säöüÄÖÜß]');
  static final RegExp _whitespace = RegExp(r'\s+');
  static final RegExp _yearPattern = RegExp(r'(19|20)\d{2}');
  static final RegExp _companyTail = RegExp(
    r'(?:home\s+entertainment|home\s+video|home\s+media|pictures|studios|films|entertainment|video|gmbh|inc\.?|ltd\.?|ag|corp(?:oration)?)',
    caseSensitive: false,
  );
  static final RegExp _byPublisher = RegExp(
    r'(?:\s*[-–—|,]\s*|\s+)\b(?:by|von)\s+(?<name>.+?)\s*\.?\s*$',
    caseSensitive: false,
  );

  static String stripListArtifacts(String raw) {
    return raw.replaceFirst(_leadingBullets, '').trim();
  }

  static String normalize(String raw) {
    var value = stripListArtifacts(raw);
    value = _withoutDistributor(value).title;
    value = value.replaceAll(_bracketedNoise, ' ');
    value = value.replaceAll(_noiseWords, ' ');
    value = value.toLowerCase();
    value = value.replaceAll(_punctuation, ' ');
    value = value.replaceAll(_whitespace, ' ').trim();
    return value;
  }

  static int? extractYear(String raw) {
    final match = _yearPattern.firstMatch(raw);
    if (match == null) return null;
    return int.tryParse(match.group(0)!);
  }

  static double similarity(String a, String b) {
    final normA = normalize(a);
    final normB = normalize(b);
    if (normA.isEmpty || normB.isEmpty) return 0;
    if (normA == normB) return 1;
    final distance = _levenshtein(normA, normB);
    final maxLen = normA.length > normB.length ? normA.length : normB.length;
    if (maxLen == 0) return 1;
    var score = 1 - (distance / maxLen);
    final shorter = normA.length < normB.length ? normA.length : normB.length;
    final longer = normA.length > normB.length ? normA.length : normB.length;
    final contained =
        shorter >= 12 &&
        shorter / longer >= 0.5 &&
        (normA.contains(normB) || normB.contains(normA));
    if (contained) {
      final boosted = 0.85 + (0.15 * shorter / longer);
      if (boosted > score) score = boosted;
    }
    return score;
  }

  static int _levenshtein(String s, String t) {
    if (s == t) return 0;
    if (s.isEmpty) return t.length;
    if (t.isEmpty) return s.length;

    var previousRow = List<int>.generate(t.length + 1, (i) => i);
    var currentRow = List<int>.filled(t.length + 1, 0);

    for (var i = 0; i < s.length; i++) {
      currentRow[0] = i + 1;
      for (var j = 0; j < t.length; j++) {
        final cost = s[i] == t[j] ? 0 : 1;
        final deletion = previousRow[j + 1] + 1;
        final insertion = currentRow[j] + 1;
        final substitution = previousRow[j] + cost;
        currentRow[j + 1] = [
          deletion,
          insertion,
          substitution,
        ].reduce((a, b) => a < b ? a : b);
      }
      final swap = previousRow;
      previousRow = currentRow;
      currentRow = swap;
    }
    return previousRow[t.length];
  }

  static DescribedTitle describe(String raw, {String? publisher}) {
    final separated = _withoutDistributor(raw, knownPublisher: publisher);
    final year = extractYear(separated.title);
    final format = _formatOf(separated.title);
    final edition = _editionOf(separated.title);
    final region = _regionOf(separated.title);
    var value = stripListArtifacts(separated.title);
    value = value.replaceAll(_bracketedNoise, ' ');
    value = value.replaceAll(_noiseWords, ' ');
    value = value.replaceAll(_yearPattern, ' ');
    value = value.replaceAll(RegExp(r'\s+\+\s+'), ' ');
    value = value.replaceAll(_whitespace, ' ').trim();
    value = value.replaceAll(RegExp(r'^[-–—+|.,]+\s*'), '');
    value = value.replaceAll(RegExp(r'\s*[-–—+|.,]+$'), '').trim();
    final known = publisher?.trim();
    return DescribedTitle(
      searchTitle: value,
      physicalFormat: format,
      edition: edition,
      region: region,
      year: year,
      publisher: (known != null && known.isNotEmpty)
          ? known
          : separated.publisher,
    );
  }

  static _SeparatedTitle _withoutDistributor(
    String raw, {
    String? knownPublisher,
  }) {
    var value = raw.trim();
    final known = knownPublisher?.trim();
    if (known != null && known.isNotEmpty) {
      final escaped = RegExp.escape(known);
      final knownPattern = RegExp(
        '(?:\\s*[-–—|,]\\s*|\\s+)(?:(?:by|von)\\s+)?$escaped\\s*\\.?\\s*\$',
        caseSensitive: false,
      );
      if (knownPattern.hasMatch(value)) {
        value = value.replaceFirst(knownPattern, '').trim();
        return _SeparatedTitle(value, known);
      }
    }

    final match = _byPublisher.firstMatch(value);
    final name = match
        ?.namedGroup('name')
        ?.replaceFirst(RegExp(r'\.+$'), '')
        .trim();
    if (match == null || name == null || name.isEmpty) {
      return _SeparatedTitle(value, null);
    }
    if (!_companyTail.hasMatch(name)) return _SeparatedTitle(value, null);
    return _SeparatedTitle(
      value.replaceFirst(match.group(0)!, '').trim(),
      name,
    );
  }

  static String? _formatOf(String raw) {
    final value = raw.toLowerCase();
    if (value.contains('4k') ||
        value.contains('uhd') ||
        value.contains('ultra hd')) {
      return 'uhd_4k';
    }
    if (value.contains('blu-ray') ||
        value.contains('bluray') ||
        value.contains('blu ray')) {
      return 'blu_ray';
    }
    if (value.contains('dvd')) return 'dvd';
    return null;
  }

  static String? _editionOf(String raw) {
    final match = RegExp(
      r"\b(steelbook|collector'?s edition|special edition|limited edition|"
      r"extended edition|director'?s cut)\b",
      caseSensitive: false,
    ).firstMatch(raw);
    return match?.group(0);
  }

  static String? _regionOf(String raw) {
    final match = RegExp(
      r'\bregion\s*[abc0-9]+\b',
      caseSensitive: false,
    ).firstMatch(raw);
    return match?.group(0);
  }
}

class DescribedTitle {
  const DescribedTitle({
    required this.searchTitle,
    this.physicalFormat,
    this.edition,
    this.region,
    this.year,
    this.publisher,
  });

  final String searchTitle;
  final String? physicalFormat;
  final String? edition;
  final String? region;
  final int? year;
  final String? publisher;
}

class _SeparatedTitle {
  const _SeparatedTitle(this.title, this.publisher);

  final String title;
  final String? publisher;
}
