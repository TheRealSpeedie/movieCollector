import '../../../core/database/media_format.dart';

/// The facts of an edition that matter when choosing between releases.
class EditionFacts {
  const EditionFacts({
    required this.format,
    this.audio,
    this.subtitles,
    this.region,
    this.editionName,
  });

  final MediaFormat format;
  final String? audio;
  final String? subtitles;
  final String? region;
  final String? editionName;

  static Set<String> languages(String? list) => {
    for (final part in (list ?? '').split(RegExp(r'[,;/]')))
      if (part.trim().isNotEmpty) part.trim().toLowerCase(),
  };

  /// What is not known about this edition yet.
  List<String> get missing => [
    if (format == MediaFormat.unknown) 'Format',
    if (languages(audio).isEmpty) 'Tonspuren',
    if (languages(subtitles).isEmpty) 'Untertitel',
    if (region == null || region!.trim().isEmpty) 'Region',
  ];
}

/// How another edition differs from the ones the person owns, in plain
/// words. No verdict: a 4K disc has the sharper picture, an older Blu-ray may
/// have the dubbing or subtitles someone prefers.
List<String> editionDifferences(List<EditionFacts> owned, EditionFacts other) {
  if (owned.isEmpty) return const [];
  final differences = <String>[];

  final ownedFormats = {for (final o in owned) o.format};
  if (other.format != MediaFormat.unknown &&
      !ownedFormats.contains(other.format)) {
    final known = ownedFormats.where((f) => f != MediaFormat.unknown);
    if (known.isNotEmpty) {
      final best = known.reduce((a, b) => a.rank >= b.rank ? a : b);
      if (other.format.rank > best.rank) {
        differences.add(
          '${other.format.label}: höhere Bildauflösung als deine ${best.label}',
        );
      } else if (other.format.rank < best.rank) {
        differences.add(
          '${other.format.label}: geringere Bildauflösung als deine ${best.label}',
        );
      } else {
        differences.add('${other.format.label} statt ${best.label}');
      }
    }
  }

  void languagesDiff(String label, Set<String> mine, Set<String> theirs) {
    if (mine.isEmpty || theirs.isEmpty) return;
    final extra = theirs.difference(mine);
    final lacking = mine.difference(theirs);
    if (extra.isNotEmpty) {
      differences.add('zusätzlich $label: ${extra.join(', ')}');
    }
    if (lacking.isNotEmpty) {
      differences.add('ohne $label: ${lacking.join(', ')}');
    }
  }

  languagesDiff('Ton', {
    for (final o in owned) ...EditionFacts.languages(o.audio),
  }, EditionFacts.languages(other.audio));
  languagesDiff('Untertitel', {
    for (final o in owned) ...EditionFacts.languages(o.subtitles),
  }, EditionFacts.languages(other.subtitles));

  final regions = {
    for (final o in owned)
      if (o.region != null && o.region!.trim().isNotEmpty)
        o.region!.trim().toUpperCase(),
  };
  final region = other.region?.trim().toUpperCase();
  if (region != null &&
      region.isNotEmpty &&
      regions.isNotEmpty &&
      !regions.contains(region)) {
    differences.add('Region $region (deine: ${regions.join(', ')})');
  }
  return differences;
}
