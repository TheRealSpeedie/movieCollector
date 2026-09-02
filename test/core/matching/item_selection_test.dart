import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/matching/item_selection.dart';
import 'package:movie_shelf/core/utils/season_format.dart';

void main() {
  group('ItemSelection', () {
    test('select all, deselect all, and regular seasons', () {
      final selection = ItemSelection([1, 2]);
      selection.selectAll([0, 1, 2, 3]);
      expect(selection.selected, {0, 1, 2, 3});
      selection.selectRegular([0, 1, 2, 3]);
      expect(selection.selected, {1, 2, 3});
      expect(selection.contains(0), isFalse);
      selection.deselectAll();
      expect(selection.count, 0);
    });

    test('toggle adds and removes ids', () {
      final selection = ItemSelection();
      selection.toggle(4);
      expect(selection.contains(4), isTrue);
      selection.toggle(4);
      expect(selection.contains(4), isFalse);
    });
  });

  group('season labels', () {
    test('formats contiguous ranges and specials', () {
      expect(seasonLabel(0), 'Specials');
      expect(seasonLabel(4), 'Staffel 4');
      expect(formatSeasonSelection([1, 2, 3, 4, 5]), 'Staffel 1–5');
      expect(
        formatSeasonSelection([1, 3, 4]),
        'Staffel 1, Staffel 3, Staffel 4',
      );
      expect(formatSeasonSelection([1, 2, 0]), 'Staffel 1–2 + Specials');
    });
  });
}
