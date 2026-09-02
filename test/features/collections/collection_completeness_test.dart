import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/shared/models/collection_with_entries.dart';

import '../../fixtures/movie_fixtures.dart';

void main() {
  test(
    'computes owned/total/missing counts and progress for an incomplete collection',
    () {
      final collection = incompleteCollectionFixture();

      expect(collection.totalCount, 4);
      expect(collection.ownedCount, 1);
      expect(collection.missingCount, 2);
      expect(collection.progress, 1 / 4);
    },
  );

  test('progress is 0 for a collection with no entries', () {
    final empty = incompleteCollectionFixture().copyWith(entries: []);
    expect(empty.progress, 0);
    expect(empty.totalCount, 0);
  });
}
