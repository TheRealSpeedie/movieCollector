/// What a free-text wish like "etwas Lustiges unter 2 Stunden aus den 90ern"
/// means for the filters. Keyword rules on the device, German and English,
/// no AI and no network.
class ParsedQuery {
  const ParsedQuery({
    this.genres = const {},
    this.maxRuntime,
    this.fromYear,
    this.toYear,
    this.includeWatched = false,
    this.understood = const [],
  });

  /// Genre names as TMDB uses them in German and English; any one matches.
  final Set<String> genres;
  final int? maxRuntime;
  final int? fromYear;
  final int? toYear;
  final bool includeWatched;

  /// What was recognised, to show the person.
  final List<String> understood;

  bool get isEmpty =>
      genres.isEmpty &&
      maxRuntime == null &&
      fromYear == null &&
      toYear == null &&
      !includeWatched;
}

class QueryParser {
  const QueryParser({DateTime? now}) : _now = now;

  final DateTime? _now;

  static const _genres = <String, (String, Set<String>)>{
    r'lustig|komödie|komoedie|witzig|zum lachen|funny|comedy|laugh': (
      'Komödie',
      {'komödie', 'comedy'},
    ),
    r'grusel|horror|scary|angst': ('Horror', {'horror'}),
    r'spannend|thriller|nervenkitzel|suspense': ('Thriller', {'thriller'}),
    r'action|explosion': ('Action', {'action'}),
    r'romant|liebe|love|romance': ('Liebesfilm', {'liebesfilm', 'romance'}),
    r'sci-?fi|science.?fiction|weltraum|space|zukunft': (
      'Science Fiction',
      {'science fiction'},
    ),
    r'familie|kinder|family|kids': ('Familie', {'familie', 'family'}),
    r'animation|zeichentrick|animiert|cartoon': ('Animation', {'animation'}),
    r'krimi|crime|verbrechen': ('Krimi', {'krimi', 'crime'}),
    r'doku|documentary': ('Dokumentarfilm', {'dokumentarfilm', 'documentary'}),
    r'fantasy|magie|magic': ('Fantasy', {'fantasy'}),
    r'abenteuer|adventure': ('Abenteuer', {'abenteuer', 'adventure'}),
    r'drama|traurig|sad|emotional': ('Drama', {'drama'}),
    r'krieg|war film': ('Kriegsfilm', {'kriegsfilm', 'war'}),
    r'western': ('Western', {'western'}),
    r'mystery|rätsel|raetsel': ('Mystery', {'mystery'}),
  };

  ParsedQuery parse(String text) {
    final q = ' ${text.toLowerCase()} ';
    final genres = <String>{};
    final understood = <String>[];
    for (final entry in _genres.entries) {
      if (RegExp(entry.key).hasMatch(q)) {
        genres.addAll(entry.value.$2);
        understood.add(entry.value.$1);
      }
    }

    int? maxRuntime;
    final minutes = RegExp(
      r'(unter|bis|max(?:imal)?|under|less than)\s*(\d{2,3})\s*(min|minuten|minutes)',
    ).firstMatch(q);
    final hours = RegExp(
      r'(unter|bis|max(?:imal)?|under|less than)\s*(\d(?:[.,]5)?)\s*(std|stunden|h\b|hours?)',
    ).firstMatch(q);
    if (minutes != null) {
      maxRuntime = int.parse(minutes.group(2)!);
    } else if (hours != null) {
      maxRuntime = (double.parse(hours.group(2)!.replaceAll(',', '.')) * 60)
          .round();
    } else if (RegExp(r'\b(kurz|kurzer|kurzes|short|quick)').hasMatch(q)) {
      maxRuntime = 100;
    }
    if (maxRuntime != null) understood.add('bis $maxRuntime Min.');

    int? fromYear;
    int? toYear;
    final decade = RegExp(
      r"\b(?:19|20)?(\d)0(?:ern|ers|er|s|'s)\b",
    ).firstMatch(q);
    if (decade != null) {
      final digit = int.parse(decade.group(1)!);
      fromYear = (digit >= 3 ? 1900 : 2000) + digit * 10;
      toYear = fromYear + 9;
      understood.add('$fromYear–$toYear');
    } else if (RegExp(
      r'\b(neu|neue|neuer|neues|aktuell|new|recent)\b',
    ).hasMatch(q)) {
      fromYear = (_now ?? DateTime.now()).year - 3;
      understood.add('ab $fromYear');
    } else if (RegExp(
      r'\b(klassiker|alt|alte|alter|altes|classic|old)\b',
    ).hasMatch(q)) {
      toYear = 1985;
      understood.add('Klassiker');
    }

    final includeWatched = RegExp(
      r'\b(nochmal|noch mal|wieder|lieblings|again|rewatch|favou?rite)',
    ).hasMatch(q);
    if (includeWatched) understood.add('auch Gesehenes');

    return ParsedQuery(
      genres: genres,
      maxRuntime: maxRuntime,
      fromYear: fromYear,
      toYear: toYear,
      includeWatched: includeWatched,
      understood: understood,
    );
  }
}
