String seasonLabel(int seasonNumber) {
  if (seasonNumber <= 0) return 'Specials';
  return 'Staffel $seasonNumber';
}

String formatSeasonSelection(Iterable<int> numbers) {
  final sorted = numbers.where((n) => n > 0).toSet().toList()..sort();
  if (sorted.isEmpty) {
    return numbers.any((n) => n <= 0) ? 'Specials' : '';
  }
  var contiguous = true;
  for (var i = 1; i < sorted.length; i++) {
    if (sorted[i] != sorted[i - 1] + 1) {
      contiguous = false;
      break;
    }
  }
  final regular = sorted.length == 1
      ? 'Staffel ${sorted.first}'
      : contiguous
      ? 'Staffel ${sorted.first}–${sorted.last}'
      : sorted.map(seasonLabel).join(', ');
  if (numbers.any((n) => n <= 0)) {
    return '$regular + Specials';
  }
  return regular;
}
