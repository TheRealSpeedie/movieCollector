import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/converters/collection_status_converter.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';

void main() {
  test('German labels are stable and correct', () {
    expect(CollectionStatus.owned.germanLabel, 'Gekauft');
    expect(CollectionStatus.wishlist.germanLabel, 'Wunschliste');
    expect(CollectionStatus.open.germanLabel, 'Offen');
  });

  test('fromName resolves a known enum name', () {
    expect(CollectionStatus.fromName('owned'), CollectionStatus.owned);
    expect(CollectionStatus.fromName('wishlist'), CollectionStatus.wishlist);
  });

  test('fromName falls back to open for unknown values', () {
    expect(CollectionStatus.fromName('unknown_value'), CollectionStatus.open);
  });

  test(
    'the persisted database representation is the stable enum name, not the German label',
    () {
      const converter = CollectionStatusConverter();
      for (final status in CollectionStatus.values) {
        expect(converter.toSql(status), status.name);
        expect(converter.toSql(status), isNot(status.germanLabel));
        expect(converter.fromSql(converter.toSql(status)), status);
      }
    },
  );

  test('owned is stronger than wishlist and open and is not downgraded', () {
    expect(
      CollectionStatus.wishlist.mergePreferringStronger(CollectionStatus.owned),
      CollectionStatus.owned,
    );
    expect(
      CollectionStatus.open.mergePreferringStronger(CollectionStatus.owned),
      CollectionStatus.owned,
    );
    expect(
      CollectionStatus.owned.mergePreferringStronger(CollectionStatus.wishlist),
      CollectionStatus.owned,
    );
    expect(
      CollectionStatus.owned.mergePreferringStronger(CollectionStatus.open),
      CollectionStatus.owned,
    );
    expect(
      CollectionStatus.open.mergePreferringStronger(CollectionStatus.wishlist),
      CollectionStatus.wishlist,
    );
  });
}
