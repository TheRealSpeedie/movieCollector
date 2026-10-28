import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/media_format.dart';
import 'package:movie_shelf/features/editions/domain/edition_compare.dart';

void main() {
  const myBluray = EditionFacts(
    format: MediaFormat.bluray,
    audio: 'de, en',
    subtitles: 'de',
    region: 'B',
  );

  test('a 4K release is described, not declared better', () {
    final differences = editionDifferences(
      [myBluray],
      const EditionFacts(
        format: MediaFormat.uhd4k,
        audio: 'en',
        subtitles: 'de, en',
        region: 'A',
      ),
    );

    expect(differences.first, contains('höhere Bildauflösung'));
    expect(differences, contains('ohne Ton: de'));
    expect(differences, contains('zusätzlich Untertitel: en'));
    expect(differences, contains('Region A (deine: B)'));
    expect(differences.join(), isNot(contains('besser')));
  });

  test('an older format and unknown facts are named as such', () {
    const dvd = EditionFacts(format: MediaFormat.dvd);
    expect(
      editionDifferences([myBluray], dvd).single,
      contains('geringere Bildauflösung'),
    );
    expect(dvd.missing, ['Tonspuren', 'Untertitel', 'Region']);
    // Nothing owned: nothing to compare with.
    expect(editionDifferences(const [], dvd), isEmpty);
  });
}
