import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/features/editions/data/physical_edition_repository.dart';
import 'package:movie_shelf/features/scanner/data/barcode_repository.dart';
import 'package:movie_shelf/shared/models/physical_edition_kind.dart';

void main() {
  late AppDatabase db;
  late PhysicalEditionRepository editions;
  late BarcodeRepository barcodes;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    editions = PhysicalEditionRepository(db);
    barcodes = BarcodeRepository(db);
  });

  tearDown(() => db.close());

  test(
    'a barcode can point at a physical movie bundle and resolve offline',
    () async {
      final first = await db
          .into(db.movies)
          .insert(MoviesCompanion.insert(title: 'Sharknado'));
      final second = await db
          .into(db.movies)
          .insert(MoviesCompanion.insert(title: 'Sharknado 2'));
      final edition = await editions.createEdition(
        kind: PhysicalEditionKind.movieBundle,
        productTitle: "Sharknado Collector's Box",
        movieIds: [first, second],
      );
      await barcodes.saveEditionMapping(
        barcode: '4001111111111',
        barcodeType: 'EAN-13',
        physicalEditionId: edition.id,
        productTitle: "Sharknado Collector's Box",
      );

      final resolved = await editions.getByBarcode('4001111111111');
      expect(resolved, isNotNull);
      expect(resolved!.movies, hasLength(2));
      expect(await barcodes.resolveMovie('4001111111111'), isNull);
    },
  );

  test('schema version 2 creates TV and physical edition tables', () async {
    expect(db.schemaVersion, 2);
    await db
        .into(db.tvSeriesTable)
        .insert(
          TvSeriesTableCompanion.insert(tmdbId: 1622, name: 'Supernatural'),
        );
    final series = await db.select(db.tvSeriesTable).get();
    expect(series, hasLength(1));
  });
}
