import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/features/import/domain/import_text_parser.dart';

void main() {
  const parser = ImportTextParser();

  group('parsePlainText', () {
    test('normalizes bullets, checkboxes and numbering', () {
      final result = parser.parsePlainText('''
Harry Potter 1
- Twilight
[x] Top Gun
• New Moon
1. Fast and Furious Tokyo Drift
''');
      expect(result, [
        'Harry Potter 1',
        'Twilight',
        'Top Gun',
        'New Moon',
        'Fast and Furious Tokyo Drift',
      ]);
    });

    test('drops empty lines and excessive whitespace', () {
      final result = parser.parsePlainText('Der Pate\n\n\n   \nMatrix   ');
      expect(result, ['Der Pate', 'Matrix']);
    });
  });

  group('parseCsv', () {
    test('extracts the first column and skips a header row', () {
      final result = parser.parseCsv('Titel,Jahr\nDer Pate,1972\nMatrix,1999');
      expect(result, ['Der Pate', 'Matrix']);
    });

    test('handles quoted csv values', () {
      final result = parser.parseCsv('"Herr der Ringe, Die Gefährten",2001');
      expect(result, ['Herr der Ringe, Die Gefährten']);
    });
  });
}
