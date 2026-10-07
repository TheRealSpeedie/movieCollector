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

    test('separates a trailing home-entertainment suffix', () {
      final described = TitleNormalizer.describe(
        'Pirates Of The Caribbean - Am Ende Der Welt By Buena Vista Home Entertainment.',
      );
      expect(
        described.searchTitle,
        'Pirates Of The Caribbean - Am Ende Der Welt',
      );
      expect(described.publisher, 'Buena Vista Home Entertainment');
    });

    test('separates other distributor suffixes', () {
      final samples = [
        (
          'Heat by Warner Home Video',
          'Heat',
          'Warner Home Video',
        ),
        (
          'Jaws by Universal Pictures Home Entertainment',
          'Jaws',
          'Universal Pictures Home Entertainment',
        ),
        (
          'Top Gun by Paramount Home Entertainment.',
          'Top Gun',
          'Paramount Home Entertainment',
        ),
        (
          'Der Pate von Paramount Home Entertainment',
          'Der Pate',
          'Paramount Home Entertainment',
        ),
      ];
      for (final sample in samples) {
        final described = TitleNormalizer.describe(sample.$1);
        expect(described.searchTitle, sample.$2, reason: sample.$1);
        expect(described.publisher, sample.$3, reason: sample.$1);
      }
    });

    test('leaves an ordinary by phrase in the title', () {
      final described = TitleNormalizer.describe('Stand by Me');
      expect(described.searchTitle, 'Stand by Me');
      expect(described.publisher, isNull);
    });

    test('uses a structured publisher field to clean the title', () {
      final described = TitleNormalizer.describe(
        'The Matrix By Warner Bros. Home Entertainment',
        publisher: 'Warner Bros. Home Entertainment',
      );
      expect(described.searchTitle, 'The Matrix');
      expect(described.publisher, 'Warner Bros. Home Entertainment');
    });

    test('keeps the movie title and splits format and edition', () {
      final described = TitleNormalizer.describe(
        'Interstellar Steelbook 4K UHD + Blu-ray',
      );
      expect(described.searchTitle, 'Interstellar');
      expect(described.physicalFormat, 'uhd_4k');
      expect(described.edition?.toLowerCase(), 'steelbook');
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
    test('ignores a distributor suffix when comparing a localized title', () {
      expect(
        TitleNormalizer.similarity(
          'Pirates Of The Caribbean - Am Ende Der Welt By Buena Vista Home Entertainment.',
          'Pirates of the Caribbean - Am Ende der Welt',
        ),
        1,
      );
    });

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
