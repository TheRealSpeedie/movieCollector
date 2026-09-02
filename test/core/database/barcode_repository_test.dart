import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/features/scanner/data/barcode_repository.dart';

void main() {
  late AppDatabase db;
  late BarcodeRepository repository;

  setUp(() {
    db = AppDatabase(NativeDatabase.memory());
    repository = BarcodeRepository(db);
  });

  tearDown(() => db.close());

  Future<int> insertMovie(String title) {
    return db.into(db.movies).insert(MoviesCompanion.insert(title: title));
  }

  test(
    'resolveMovie returns null when the barcode has never been seen',
    () async {
      expect(await repository.resolveMovie('0000000000000'), isNull);
    },
  );

  test(
    'saveMapping persists a barcode and resolveMovie finds it locally afterwards',
    () async {
      final movieId = await insertMovie('Der Pate');

      await repository.saveMapping(
        barcode: '4001234567890',
        barcodeType: 'EAN-13',
        movieId: movieId,
        productTitle: 'Der Pate DVD',
      );

      final resolved = await repository.resolveMovie('4001234567890');
      expect(resolved, isNotNull);
      expect(resolved!.title, 'Der Pate');
    },
  );

  test('a movie can have multiple barcode editions', () async {
    final movieId = await insertMovie('Der Pate');

    await repository.saveMapping(
      barcode: '4001234567890',
      barcodeType: 'EAN-13',
      movieId: movieId,
      editionName: 'DVD',
    );
    await repository.saveMapping(
      barcode: '4001234567891',
      barcodeType: 'EAN-13',
      movieId: movieId,
      editionName: 'Blu-ray',
    );

    final editions = await repository.watchBarcodesForMovie(movieId).first;
    expect(editions, hasLength(2));
  });

  test(
    'mapping an already-assigned barcode to another movie fails without allowRemap',
    () async {
      final firstMovie = await insertMovie('Der Pate');
      final secondMovie = await insertMovie('Der Pate 2');

      await repository.saveMapping(
        barcode: '4001234567890',
        barcodeType: 'EAN-13',
        movieId: firstMovie,
      );

      expect(
        () => repository.saveMapping(
          barcode: '4001234567890',
          barcodeType: 'EAN-13',
          movieId: secondMovie,
        ),
        throwsA(isA<DuplicateBarcodeException>()),
      );
    },
  );

  test('a barcode can be manually remapped to a different movie', () async {
    final firstMovie = await insertMovie('Der Pate');
    final secondMovie = await insertMovie('Der Pate 2');

    await repository.saveMapping(
      barcode: '4001234567890',
      barcodeType: 'EAN-13',
      movieId: firstMovie,
    );
    await repository.saveMapping(
      barcode: '4001234567890',
      barcodeType: 'EAN-13',
      movieId: secondMovie,
      allowRemap: true,
    );

    final resolved = await repository.resolveMovie('4001234567890');
    expect(resolved!.title, 'Der Pate 2');
  });

  test(
    'deleteMapping removes the barcode so it can no longer be resolved locally',
    () async {
      final movieId = await insertMovie('Der Pate');
      await repository.saveMapping(
        barcode: '4001234567890',
        barcodeType: 'EAN-13',
        movieId: movieId,
      );
      final barcodeRow = await (db.select(
        db.barcodes,
      )..where((t) => t.barcode.equals('4001234567890'))).getSingle();

      await repository.deleteMapping(barcodeRow.id);

      expect(await repository.resolveMovie('4001234567890'), isNull);
    },
  );
}
