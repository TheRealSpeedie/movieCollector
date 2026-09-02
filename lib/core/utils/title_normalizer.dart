class TitleNormalizer {
  TitleNormalizer._();

  static final RegExp _bracketedNoise = RegExp(
    r"[\[\(][^\]\)]*(dvd|blu-?ray|steelbook|edition|disc|uncut|kinofassung|remastered|4k|uhd|region)[^\]\)]*[\]\)]",
    caseSensitive: false,
  );

  static final RegExp _noiseWords = RegExp(
    r"\b(dvd|blu-?ray|blu ray|steelbook|special edition|collector'?s edition|ultimate edition|"
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

  static String stripListArtifacts(String raw) {
    return raw.replaceFirst(_leadingBullets, '').trim();
  }

  static String normalize(String raw) {
    var value = stripListArtifacts(raw);
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
    return 1 - (distance / maxLen);
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
}
