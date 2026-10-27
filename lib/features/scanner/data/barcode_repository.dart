import 'package:drift/drift.dart';

import '../../../core/database/media_format.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/mappers/movie_mapper.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/models/physical_edition_kind.dart';

class BarcodeRepository {
  BarcodeRepository(this._db);

  final AppDatabase _db;

  Future<Movie?> resolveMovie(String barcode) async {
    final barcodeRow = await (_db.select(
      _db.barcodes,
    )..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
    if (barcodeRow == null) return null;

    if (barcodeRow.movieId != null) {
      final movieRow = await (_db.select(
        _db.movies,
      )..where((t) => t.id.equals(barcodeRow.movieId!))).getSingleOrNull();
      if (movieRow != null) {
        return mapMovieRow(movieRow, await _genreNames(movieRow.id));
      }
    }

    if (barcodeRow.physicalEditionId != null) {
      final links = await (_db.select(
        _db.physicalEditionMovies,
      )..where((t) => t.editionId.equals(barcodeRow.physicalEditionId!))).get();
      if (links.length == 1) {
        final movieRow = await (_db.select(
          _db.movies,
        )..where((t) => t.id.equals(links.first.movieId))).getSingleOrNull();
        if (movieRow != null) {
          return mapMovieRow(movieRow, await _genreNames(movieRow.id));
        }
      }
    }
    return null;
  }

  Stream<List<BarcodeRow>> watchBarcodesForMovie(int movieId) {
    final query = _db.select(_db.barcodes)
      ..where((t) => t.movieId.equals(movieId))
      ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]);
    return query.watch();
  }

  /// Links [barcode] to a single-movie edition of [movieId] and returns that
  /// edition, so the caller can record a copy of exactly what was scanned.
  Future<int> saveMapping({
    required String barcode,
    required String barcodeType,
    required int movieId,
    String? productTitle,
    String? editionName,
    String? physicalFormat,
    String? region,
    String? imdbId,
    String source = 'user',
    bool allowRemap = false,
  }) async {
    final existing = await (_db.select(
      _db.barcodes,
    )..where((t) => t.barcode.equals(barcode))).getSingleOrNull();

    if (existing != null &&
        existing.movieId != null &&
        existing.movieId != movieId &&
        !allowRemap) {
      throw const DuplicateBarcodeException();
    }

    final editionId = await _ensureSingleMovieEdition(
      movieId: movieId,
      productTitle: productTitle,
      editionName: editionName,
      physicalFormat: physicalFormat,
      region: region,
      reuseEditionId: existing?.movieId == movieId
          ? existing?.physicalEditionId
          : null,
    );

    if (existing != null) {
      await (_db.update(
        _db.barcodes,
      )..where((t) => t.id.equals(existing.id))).write(
        BarcodesCompanion(
          movieId: Value(movieId),
          physicalEditionId: Value(editionId),
          barcodeType: Value(barcodeType),
          productTitle: Value(productTitle),
          editionName: Value(editionName),
          physicalFormat: Value(physicalFormat),
          region: Value(region),
          imdbId: Value(imdbId),
          source: Value(source),
          verified: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return editionId;
    }

    await _db
        .into(_db.barcodes)
        .insert(
          BarcodesCompanion.insert(
            movieId: Value(movieId),
            physicalEditionId: Value(editionId),
            barcode: barcode,
            barcodeType: barcodeType,
            productTitle: Value(productTitle),
            editionName: Value(editionName),
            physicalFormat: Value(physicalFormat),
            region: Value(region),
            imdbId: Value(imdbId),
            source: Value(source),
            verified: const Value(true),
            updatedAt: Value(DateTime.now()),
          ),
        );
    return editionId;
  }

  Future<void> saveEditionMapping({
    required String barcode,
    required String barcodeType,
    required int physicalEditionId,
    int? movieId,
    String? productTitle,
    String? editionName,
    String? physicalFormat,
    String? region,
    String? imdbId,
    String source = 'user',
    bool allowRemap = false,
  }) async {
    final existing = await (_db.select(
      _db.barcodes,
    )..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
    if (existing != null &&
        existing.physicalEditionId != null &&
        existing.physicalEditionId != physicalEditionId &&
        !allowRemap) {
      throw const DuplicateBarcodeException();
    }
    if (existing != null) {
      await (_db.update(
        _db.barcodes,
      )..where((t) => t.id.equals(existing.id))).write(
        BarcodesCompanion(
          movieId: Value(movieId),
          physicalEditionId: Value(physicalEditionId),
          barcodeType: Value(barcodeType),
          productTitle: Value(productTitle),
          editionName: Value(editionName),
          physicalFormat: Value(physicalFormat),
          region: Value(region),
          imdbId: Value(imdbId),
          source: Value(source),
          verified: const Value(true),
          updatedAt: Value(DateTime.now()),
        ),
      );
      return;
    }
    await _db
        .into(_db.barcodes)
        .insert(
          BarcodesCompanion.insert(
            movieId: Value(movieId),
            physicalEditionId: Value(physicalEditionId),
            barcode: barcode,
            barcodeType: barcodeType,
            productTitle: Value(productTitle),
            editionName: Value(editionName),
            physicalFormat: Value(physicalFormat),
            region: Value(region),
            imdbId: Value(imdbId),
            source: Value(source),
            verified: const Value(true),
            updatedAt: Value(DateTime.now()),
          ),
        );
  }

  Future<int> _ensureSingleMovieEdition({
    required int movieId,
    String? productTitle,
    String? editionName,
    String? physicalFormat,
    String? region,
    int? reuseEditionId,
  }) async {
    final format = MediaFormat.parse(physicalFormat).name;
    if (reuseEditionId != null) {
      final reused = await (_db.select(
        _db.physicalEditions,
      )..where((t) => t.id.equals(reuseEditionId))).getSingleOrNull();
      if (reused != null) {
        await (_db.update(
          _db.physicalEditions,
        )..where((t) => t.id.equals(reused.id))).write(
          PhysicalEditionsCompanion(
            format: reused.format == MediaFormat.unknown.name
                ? Value(format)
                : const Value.absent(),
            region: Value(reused.region ?? region),
          ),
        );
        return reused.id;
      }
    }
    final id = await _db
        .into(_db.physicalEditions)
        .insert(
          PhysicalEditionsCompanion.insert(
            productTitle: Value(productTitle),
            editionName: Value(editionName),
            mediaKind: PhysicalEditionKind.singleMovie.name,
            format: Value(format),
            region: Value(region),
          ),
        );
    await _db
        .into(_db.physicalEditionMovies)
        .insert(
          PhysicalEditionMoviesCompanion.insert(
            editionId: id,
            movieId: movieId,
          ),
        );
    return id;
  }

  Future<void> deleteMapping(int barcodeId) async {
    await (_db.delete(_db.barcodes)..where((t) => t.id.equals(barcodeId))).go();
  }

  Future<List<String>> _genreNames(int movieId) async {
    final query = _db.select(_db.genres).join([
      innerJoin(
        _db.movieGenres,
        _db.movieGenres.genreId.equalsExp(_db.genres.id),
      ),
    ])..where(_db.movieGenres.movieId.equals(movieId));
    final rows = await query.get();
    return rows.map((r) => r.readTable(_db.genres).name).toList();
  }
}
