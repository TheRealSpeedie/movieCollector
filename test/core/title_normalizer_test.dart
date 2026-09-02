import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/utils/title_normalizer.dart';

void main() {
  group('TitleNormalizer.normalize', () {
    test('removes edition and format noise words', () {
      expect(
        TitleNormalizer.normalize('Der Pate (Blu-ray) [Steelbook]'),
        'der pate',
      );
      expect(
        TitleNormalizer.normalize('Matrix - Special Edition DVD'),
        'matrix',
      );
      expect(
        TitleNormalizer.normalize("Der Herr der Ringe Collector's Edition"),
        'der herr der ringe',
      );
    });

    test('strips list bullets, checkboxes and numbering', () {
      expect(TitleNormalizer.stripListArtifacts('- Twilight'), 'Twilight');
      expect(TitleNormalizer.stripListArtifacts('• New Moon'), 'New Moon');
      expect(TitleNormalizer.stripListArtifacts('[x] Top Gun'), 'Top Gun');
      expect(
        TitleNormalizer.stripListArtifacts('1. Harry Potter'),
        'Harry Potter',
      );
    });

    test('does not strip numbers that belong to the title', () {
      expect(TitleNormalizer.normalize('Harry Potter 1'), 'harry potter 1');
      expect(
        TitleNormalizer.normalize('Fast and Furious Tokyo Drift'),
        'fast and furious tokyo drift',
      );
    });

    test('collapses whitespace and is case-insensitive', () {
      expect(TitleNormalizer.normalize('  Der   Pate   '), 'der pate');
    });
  });

  group('TitleNormalizer.extractYear', () {
    test('finds a plausible year', () {
      expect(TitleNormalizer.extractYear('Dune (2021)'), 2021);
      expect(TitleNormalizer.extractYear('Kein Jahr hier'), null);
    });
  });

  group('TitleNormalizer.similarity', () {
    test('is 1.0 for identical normalized titles', () {
      expect(TitleNormalizer.similarity('Der Pate', 'DER PATE (DVD)'), 1.0);
    });

    test('is lower for different titles', () {
      final similarity = TitleNormalizer.similarity(
        'Der Pate',
        'Der Herr der Ringe',
      );
      expect(similarity, lessThan(0.6));
    });

    test('is 0 when either title is empty after normalization', () {
      expect(TitleNormalizer.similarity('', 'Der Pate'), 0);
    });
  });
}
