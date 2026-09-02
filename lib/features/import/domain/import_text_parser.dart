import '../../../core/utils/title_normalizer.dart';

class ImportTextParser {
  const ImportTextParser();

  List<String> parsePlainText(String raw) {
    return raw
        .split(RegExp(r'\r\n|\r|\n'))
        .map(TitleNormalizer.stripListArtifacts)
        .map((line) => line.trim())
        .where((line) => line.isNotEmpty)
        .toList();
  }

  List<String> parseCsv(String raw) {
    final lines = raw
        .split(RegExp(r'\r\n|\r|\n'))
        .where((line) => line.trim().isNotEmpty)
        .toList();
    final titles = <String>[];
    for (var i = 0; i < lines.length; i++) {
      final firstCell = _firstCsvCell(lines[i]);
      if (firstCell.isEmpty) continue;
      if (i == 0 && _looksLikeHeader(firstCell)) continue;
      titles.add(TitleNormalizer.stripListArtifacts(firstCell));
    }
    return titles;
  }

  String _firstCsvCell(String line) {
    final trimmed = line.trim();
    if (trimmed.startsWith('"')) {
      final match = RegExp(r'^"([^"]*)"').firstMatch(trimmed);
      if (match != null) return match.group(1)!.trim();
    }
    final idx = trimmed.indexOf(',');
    return (idx == -1 ? trimmed : trimmed.substring(0, idx)).trim();
  }

  bool _looksLikeHeader(String value) {
    final normalized = value.toLowerCase().trim();
    return normalized == 'title' ||
        normalized == 'titel' ||
        normalized == 'movie' ||
        normalized == 'name';
  }
}
