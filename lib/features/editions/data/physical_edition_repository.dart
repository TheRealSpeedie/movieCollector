import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/mappers/movie_mapper.dart';
import '../../../core/database/mappers/tv_mapper.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/models/physical_edition.dart';
import '../../../shared/models/physical_edition_kind.dart';
import '../../../shared/models/tv_season.dart';
import '../../../shared/models/tv_series.dart';

class PhysicalEditionRepository {
  PhysicalEditionRepository(this._db);

  final AppDatabase _db;

  Future<PhysicalEditionContents> createEdition({
    required PhysicalEditionKind kind,
    String? productTitle,
    String? editionName,
    int? tmdbCollectionId,
    int? tmdbTvSeriesId,
    List<int> movieIds = const [],
    List<int> seasonIds = const [],
  }) async {
    final editionId = await _db.transaction(() async {
      final id = await _db
          .into(_db.physicalEditions)
          .insert(
            PhysicalEditionsCompanion.insert(
              productTitle: Value(productTitle),
              editionName: Value(editionName),
              mediaKind: kind.name,
              tmdbCollectionId: Value(tmdbCollectionId),
              tmdbTvSeriesId: Value(tmdbTvSeriesId),
            ),
          );
      for (final movieId in movieIds.toSet()) {
        await _db
            .into(_db.physicalEditionMovies)
            .insert(
              PhysicalEditionMoviesCompanion.insert(
                editionId: id,
                movieId: movieId,
              ),
            );
      }
      for (final seasonId in seasonIds.toSet()) {
        await _db
            .into(_db.physicalEditionTvSeasons)
            .insert(
              PhysicalEditionTvSeasonsCompanion.insert(
                editionId: id,
                seasonId: seasonId,
              ),
            );
      }
      return id;
    });
    return (await getById(editionId))!;
  }

  Future<PhysicalEditionContents?> getById(int id) async {
    final row = await (_db.select(
      _db.physicalEditions,
    )..where((t) => t.id.equals(id))).getSingleOrNull();
    if (row == null) return null;
    return _map(row);
  }

  Future<PhysicalEditionContents?> getByBarcode(String barcode) async {
    final barcodeRow = await (_db.select(
      _db.barcodes,
    )..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
    if (barcodeRow == null) return null;
    if (barcodeRow.physicalEditionId != null) {
      return getById(barcodeRow.physicalEditionId!);
    }
    if (barcodeRow.movieId != null) {
      final movieRow = await (_db.select(
        _db.movies,
      )..where((t) => t.id.equals(barcodeRow.movieId!))).getSingleOrNull();
      if (movieRow == null) return null;
      return PhysicalEditionContents(
        id: 0,
        kind: PhysicalEditionKind.singleMovie,
        productTitle: barcodeRow.productTitle,
        editionName: barcodeRow.editionName,
        movies: [mapMovieRow(movieRow, await _movieGenres(movieRow.id))],
        createdAt: barcodeRow.createdAt,
      );
    }
    return null;
  }

  Future<PhysicalEditionContents> _map(PhysicalEditionRow row) async {
    final movieLinks = await (_db.select(
      _db.physicalEditionMovies,
    )..where((t) => t.editionId.equals(row.id))).get();
    final movies = <Movie>[];
    for (final link in movieLinks) {
      final movieRow = await (_db.select(
        _db.movies,
      )..where((t) => t.id.equals(link.movieId))).getSingleOrNull();
      if (movieRow == null) continue;
      movies.add(mapMovieRow(movieRow, await _movieGenres(movieRow.id)));
    }

    final seasonLinks = await (_db.select(
      _db.physicalEditionTvSeasons,
    )..where((t) => t.editionId.equals(row.id))).get();
    final seasons = <TvSeason>[];
    for (final link in seasonLinks) {
      final seasonRow = await (_db.select(
        _db.tvSeasonsTable,
      )..where((t) => t.id.equals(link.seasonId))).getSingleOrNull();
      if (seasonRow == null) continue;
      seasons.add(mapTvSeasonRow(seasonRow));
    }

    TvSeries? series;
    if (row.tmdbTvSeriesId != null) {
      final seriesRow = await (_db.select(
        _db.tvSeriesTable,
      )..where((t) => t.tmdbId.equals(row.tmdbTvSeriesId!))).getSingleOrNull();
      if (seriesRow != null) {
        series = mapTvSeriesRow(seriesRow, const []);
      }
    } else if (seasons.isNotEmpty) {
      final seriesRow = await (_db.select(
        _db.tvSeriesTable,
      )..where((t) => t.id.equals(seasons.first.seriesId))).getSingleOrNull();
      if (seriesRow != null) {
        series = mapTvSeriesRow(seriesRow, const []);
      }
    }

    return PhysicalEditionContents(
      id: row.id,
      kind: PhysicalEditionKind.values.firstWhere(
        (k) => k.name == row.mediaKind,
        orElse: () => PhysicalEditionKind.singleMovie,
      ),
      productTitle: row.productTitle,
      editionName: row.editionName,
      tmdbCollectionId: row.tmdbCollectionId,
      tmdbTvSeriesId: row.tmdbTvSeriesId,
      movies: movies,
      seasons: seasons,
      series: series,
      createdAt: row.createdAt,
    );
  }

  Future<List<String>> _movieGenres(int movieId) async {
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
