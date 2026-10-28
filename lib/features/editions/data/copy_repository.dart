import 'package:drift/drift.dart';

import '../../../core/collection/ownership_service.dart';
import '../../../core/database/app_database.dart';
import '../../../core/database/media_format.dart';
import '../../../shared/models/physical_edition_kind.dart';
import 'edition_catalog.dart';

class EditionWithCopies {
  const EditionWithCopies({
    required this.edition,
    required this.copies,
    required this.titleCount,
  });

  final PhysicalEditionRow edition;
  final List<OwnedCopyRow> copies;

  /// How many films or seasons the edition holds; more than one is a set.
  final int titleCount;

  MediaFormat get format => MediaFormat.fromName(edition.format);

  String get label {
    final parts = [
      if (format != MediaFormat.unknown) format.label,
      if (edition.editionName?.isNotEmpty ?? false) edition.editionName!,
      if (titleCount > 1) 'Box mit $titleCount Titeln',
    ];
    return parts.isEmpty
        ? (edition.productTitle ?? 'Ausgabe')
        : parts.join(' · ');
  }
}

/// Editions of a title and the copies the user owns. Every change of a copy
/// goes through OwnershipService so the derived status stays correct.
class CopyRepository {
  CopyRepository(this._db) : _ownership = OwnershipService(_db);

  final AppDatabase _db;
  final OwnershipService _ownership;

  Stream<List<EditionWithCopies>> watchForMovie(int movieId) {
    final query = _db.select(_db.physicalEditions).join([
      innerJoin(
        _db.physicalEditionMovies,
        _db.physicalEditionMovies.editionId.equalsExp(_db.physicalEditions.id),
      ),
    ])..where(_db.physicalEditionMovies.movieId.equals(movieId));
    return query.watch().asyncMap(
      (rows) => _withCopies([
        for (final r in rows) r.readTable(_db.physicalEditions),
      ]),
    );
  }

  Stream<List<EditionWithCopies>> watchForSeason(int seasonId) {
    final query = _db.select(_db.physicalEditions).join([
      innerJoin(
        _db.physicalEditionTvSeasons,
        _db.physicalEditionTvSeasons.editionId.equalsExp(
          _db.physicalEditions.id,
        ),
      ),
    ])..where(_db.physicalEditionTvSeasons.seasonId.equals(seasonId));
    return query.watch().asyncMap(
      (rows) => _withCopies([
        for (final r in rows) r.readTable(_db.physicalEditions),
      ]),
    );
  }

  Future<List<EditionWithCopies>> _withCopies(
    List<PhysicalEditionRow> editions,
  ) async {
    final result = <EditionWithCopies>[];
    for (final edition in editions) {
      final copies = await (_db.select(
        _db.ownedCopies,
      )..where((t) => t.editionId.equals(edition.id))).get();
      final movies = await (_db.select(
        _db.physicalEditionMovies,
      )..where((t) => t.editionId.equals(edition.id))).get();
      final seasons = await (_db.select(
        _db.physicalEditionTvSeasons,
      )..where((t) => t.editionId.equals(edition.id))).get();
      result.add(
        EditionWithCopies(
          edition: edition,
          copies: copies,
          titleCount: movies.length + seasons.length,
        ),
      );
    }
    // Owned editions first.
    result.sort((a, b) => b.copies.length.compareTo(a.copies.length));
    return result;
  }

  /// A new edition of a movie, for example a second Blu-ray release. Owned
  /// creates a copy right away.
  Future<int> addMovieEdition(
    int movieId, {
    required MediaFormat format,
    String? editionName,
    String? productTitle,
    bool owned = true,
  }) async {
    return _db.transaction(() async {
      final id = await _db
          .into(_db.physicalEditions)
          .insert(
            PhysicalEditionsCompanion.insert(
              mediaKind: PhysicalEditionKind.singleMovie.name,
              format: Value(format.name),
              editionName: Value(editionName),
              productTitle: Value(productTitle),
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
      if (owned) await addCopy(id);
      return id;
    });
  }

  /// A new edition of one season, for example a Blu-ray box of season 3.
  Future<int> addSeasonEdition(
    int seasonId, {
    required MediaFormat format,
    String? editionName,
    bool owned = true,
  }) async {
    return _db.transaction(() async {
      final season = await (_db.select(
        _db.tvSeasonsTable,
      )..where((t) => t.id.equals(seasonId))).getSingle();
      final series = await (_db.select(
        _db.tvSeriesTable,
      )..where((t) => t.id.equals(season.seriesId))).getSingle();
      final id = await _db
          .into(_db.physicalEditions)
          .insert(
            PhysicalEditionsCompanion.insert(
              mediaKind: PhysicalEditionKind.singleTvSeason.name,
              format: Value(format.name),
              editionName: Value(editionName),
              productTitle: Value(
                '${series.name} – Staffel ${season.seasonNumber}',
              ),
              tmdbTvSeriesId: Value(series.tmdbId),
            ),
          );
      await _db
          .into(_db.physicalEditionTvSeasons)
          .insert(
            PhysicalEditionTvSeasonsCompanion.insert(
              editionId: id,
              seasonId: seasonId,
            ),
          );
      if (owned) await addCopy(id);
      return id;
    });
  }

  Future<void> updateEdition(int editionId, PhysicalEditionsCompanion values) =>
      (_db.update(
        _db.physicalEditions,
      )..where((t) => t.id.equals(editionId))).write(values);

  /// Takes a catalog edition into the collection, without a copy. It stays
  /// on the device and syncs like any other edition.
  Future<int> adoptCatalogEdition(int movieId, CatalogEntry entry) async {
    return _db.transaction(() async {
      final id = await _db
          .into(_db.physicalEditions)
          .insert(
            PhysicalEditionsCompanion.insert(
              mediaKind: PhysicalEditionKind.singleMovie.name,
              format: Value(entry.format.name),
              editionName: Value(entry.editionName),
              productTitle: Value(entry.title),
              region: Value(entry.region),
              releaseCountry: Value(entry.releaseCountry),
              audioLanguages: Value(entry.audioLanguages),
              subtitleLanguages: Value(entry.subtitleLanguages),
              publisher: Value(entry.publisher),
              catalogId: Value(entry.id),
              source: const Value('catalog'),
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
      for (final code in entry.barcodes) {
        await _db
            .into(_db.barcodes)
            .insert(
              BarcodesCompanion.insert(
                barcode: code,
                barcodeType: code.length == 12 ? 'upc' : 'ean',
                movieId: Value(movieId),
                physicalEditionId: Value(id),
                editionName: Value(entry.editionName),
                physicalFormat: Value(entry.format.name),
                source: const Value('catalog'),
                verified: const Value(true),
              ),
              mode: InsertMode.insertOrIgnore,
            );
      }
      return id;
    });
  }

  /// The release facts of an own edition, ready to share with the catalog.
  Future<CatalogEntry?> catalogEntryFor(int editionId, int movieId) async {
    final edition = await (_db.select(
      _db.physicalEditions,
    )..where((t) => t.id.equals(editionId))).getSingleOrNull();
    final movie = await (_db.select(
      _db.movies,
    )..where((t) => t.id.equals(movieId))).getSingleOrNull();
    if (edition == null || movie == null || movie.tmdbId == null) return null;
    final codes = await (_db.select(
      _db.barcodes,
    )..where((t) => t.physicalEditionId.equals(editionId))).get();
    return CatalogEntry(
      id: edition.catalogId ?? '',
      kind: 'movie',
      title: movie.title,
      tmdbId: movie.tmdbId,
      year: movie.releaseYear,
      format: MediaFormat.fromName(edition.format),
      editionName: edition.editionName,
      region: edition.region,
      releaseCountry: edition.releaseCountry,
      publisher: edition.publisher,
      audioLanguages: edition.audioLanguages,
      subtitleLanguages: edition.subtitleLanguages,
      barcodes: [for (final c in codes) c.barcode],
    );
  }

  Future<void> linkCatalog(int editionId, String catalogId) =>
      (_db.update(_db.physicalEditions)..where((t) => t.id.equals(editionId)))
          .write(PhysicalEditionsCompanion(catalogId: Value(catalogId)));

  /// Barcodes and catalog ids of the editions of a movie, to tell known
  /// catalog entries from new ones.
  Future<({Set<String> catalogIds, Set<String> barcodes, int bestOwnedRank})>
  knownForMovie(int movieId) async {
    final editions = await _withCopies(
      await (_db.select(_db.physicalEditions).join([
        innerJoin(
          _db.physicalEditionMovies,
          _db.physicalEditionMovies.editionId.equalsExp(
            _db.physicalEditions.id,
          ),
        ),
      ])..where(_db.physicalEditionMovies.movieId.equals(movieId))).get().then(
        (rows) => [for (final r in rows) r.readTable(_db.physicalEditions)],
      ),
    );
    final ids = {for (final e in editions) e.edition.id};
    final codes = ids.isEmpty
        ? const <BarcodeRow>[]
        : await (_db.select(
            _db.barcodes,
          )..where((t) => t.physicalEditionId.isIn(ids))).get();
    var best = 0;
    for (final e in editions.where((e) => e.copies.isNotEmpty)) {
      final rank = MediaFormat.fromName(e.edition.format).rank;
      if (rank > best) best = rank;
    }
    return (
      catalogIds: {
        for (final e in editions)
          if (e.edition.catalogId != null) e.edition.catalogId!,
      },
      barcodes: {for (final c in codes) c.barcode},
      bestOwnedRank: best,
    );
  }

  /// Another copy of an edition, for example a second disc of the same
  /// release.
  Future<int> addCopy(int editionId) async {
    final id = await _db
        .into(_db.ownedCopies)
        .insert(OwnedCopiesCompanion.insert(editionId: editionId));
    await _ownership.recompute();
    return id;
  }

  Future<void> updateCopy(int copyId, OwnedCopiesCompanion values) =>
      (_db.update(_db.ownedCopies)..where((t) => t.id.equals(copyId))).write(
        values.copyWith(updatedAt: Value(DateTime.now())),
      );

  Future<void> removeCopy(int copyId) => _ownership.removeCopy(copyId);

  /// Removes an edition that has no copies and no barcode, for example one
  /// added by mistake.
  Future<bool> removeEditionIfUnused(int editionId) async {
    final copies = await (_db.select(
      _db.ownedCopies,
    )..where((t) => t.editionId.equals(editionId))).get();
    final barcodes = await (_db.select(
      _db.barcodes,
    )..where((t) => t.physicalEditionId.equals(editionId))).get();
    if (copies.isNotEmpty || barcodes.isNotEmpty) return false;
    await (_db.delete(
      _db.physicalEditions,
    )..where((t) => t.id.equals(editionId))).go();
    return true;
  }
}
