import 'dart:convert';

import 'package:drift/drift.dart';

import '../../shared/models/physical_edition_kind.dart';
import '../database/app_database.dart';
import 'sync_ids.dart';

/// Record types of the collection sync protocol. They match
/// MovieShelf.Core.Sync.SyncEntityTypes on the server.
abstract final class SyncEntityType {
  static const title = 'title';
  static const season = 'season';
  static const edition = 'edition';
  static const editionContent = 'editionContent';
  static const copy = 'copy';
  static const barcode = 'barcode';
  static const personalState = 'personalState';
  static const subscription = 'subscription';

  /// Order in which incoming records are written, so references resolve.
  static const applyOrder = [
    title,
    season,
    edition,
    editionContent,
    copy,
    barcode,
    personalState,
    subscription,
  ];
}

/// One record of the collection as the sync protocol sees it: a UUID, a type
/// and a flat map of JSON values.
class SyncRecord {
  const SyncRecord(this.type, this.uuid, this.fields);

  final String type;
  final String uuid;
  final Map<String, Object?> fields;
}

/// Compares JSON values the way the server does.
bool sameJson(Object? a, Object? b) => jsonEncode(a) == jsonEncode(b);

/// Converts the local database into sync records and writes records that
/// arrive from another device back into it.
class CollectionRecords {
  CollectionRecords(this._db);

  final AppDatabase _db;

  /// The whole collection, keyed by UUID.
  Future<Map<String, SyncRecord>> buildAll() async {
    final records = <String, SyncRecord>{};
    void add(SyncRecord record) => records[record.uuid] = record;

    final movieUuids = <int, String>{};
    for (final m in await _db.select(_db.movies).get()) {
      final uuid = movieUuid(m);
      movieUuids[m.id] = uuid;
      add(
        SyncRecord(SyncEntityType.title, uuid, {
          'kind': 'movie',
          'tmdbId': m.tmdbId,
          'title': m.title,
          'originalTitle': m.originalTitle,
          'year': m.releaseYear,
          'runtime': m.runtime,
          'posterPath': m.posterPath,
          'tmdbCollectionId': m.tmdbCollectionId,
        }),
      );
    }

    final seriesUuids = <int, String>{};
    final seriesTmdb = <int, int>{};
    for (final s in await _db.select(_db.tvSeriesTable).get()) {
      final uuid = SyncIds.series(s.tmdbId);
      seriesUuids[s.id] = uuid;
      seriesTmdb[s.id] = s.tmdbId;
      add(
        SyncRecord(SyncEntityType.title, uuid, {
          'kind': 'series',
          'tmdbId': s.tmdbId,
          'title': s.name,
          'originalTitle': s.originalName,
          'year': s.firstAirDate?.year,
          'posterPath': s.posterPath,
        }),
      );
    }

    final seasonUuids = <int, String>{};
    for (final s in await _db.select(_db.tvSeasonsTable).get()) {
      final uuid = SyncIds.season(seriesTmdb[s.seriesId]!, s.seasonNumber);
      seasonUuids[s.id] = uuid;
      add(
        SyncRecord(SyncEntityType.season, uuid, {
          'seriesId': seriesUuids[s.seriesId],
          'seasonNumber': s.seasonNumber,
          'name': s.name,
          'tmdbSeasonId': s.tmdbSeasonId,
          'posterPath': s.posterPath,
          'episodeCount': s.episodeCount,
        }),
      );
    }

    final editionUuids = <int, String>{};
    for (final e in await _db.select(_db.physicalEditions).get()) {
      editionUuids[e.id] = e.uuid!;
      add(
        SyncRecord(SyncEntityType.edition, e.uuid!, {
          'kind': e.mediaKind,
          'format': e.format,
          'productTitle': e.productTitle,
          'editionName': e.editionName,
          'region': e.region,
          'releaseCountry': e.releaseCountry,
          'audioLanguages': e.audioLanguages,
          'subtitleLanguages': e.subtitleLanguages,
          'publisher': e.publisher,
          'notes': e.notes,
          'tmdbCollectionId': e.tmdbCollectionId,
          'tmdbTvSeriesId': e.tmdbTvSeriesId,
        }),
      );
    }

    for (final link in await _db.select(_db.physicalEditionMovies).get()) {
      final edition = editionUuids[link.editionId]!;
      final subject = movieUuids[link.movieId]!;
      add(
        SyncRecord(
          SyncEntityType.editionContent,
          SyncIds.editionContent(edition, subject),
          {'editionId': edition, 'subjectId': subject, 'subjectType': 'title'},
        ),
      );
    }
    for (final link in await _db.select(_db.physicalEditionTvSeasons).get()) {
      final edition = editionUuids[link.editionId]!;
      final subject = seasonUuids[link.seasonId]!;
      add(
        SyncRecord(
          SyncEntityType.editionContent,
          SyncIds.editionContent(edition, subject),
          {'editionId': edition, 'subjectId': subject, 'subjectType': 'season'},
        ),
      );
    }

    for (final c in await _db.select(_db.ownedCopies).get()) {
      add(
        SyncRecord(SyncEntityType.copy, c.uuid, {
          'editionId': editionUuids[c.editionId],
          'quantity': c.quantity,
          'condition': c.condition,
          'purchaseDate': c.purchaseDate?.toUtc().toIso8601String(),
          'purchasePrice': c.purchasePrice,
          'storageLocation': c.storageLocation,
          'notes': c.notes,
        }),
      );
    }

    for (final b in await _db.select(_db.barcodes).get()) {
      if (b.movieId == null && b.physicalEditionId == null) continue;
      add(
        SyncRecord(SyncEntityType.barcode, SyncIds.barcode(b.barcode), {
          'code': b.barcode,
          'type': b.barcodeType,
          'editionId': editionUuids[b.physicalEditionId],
          'titleId': movieUuids[b.movieId],
          'productTitle': b.productTitle,
          'editionName': b.editionName,
          'format': b.physicalFormat,
          'region': b.region,
          'imdbId': b.imdbId,
          'verified': b.verified,
        }),
      );
    }

    for (final p in await _db.select(_db.personalStates).get()) {
      final subject = p.movieId != null
          ? movieUuids[p.movieId]
          : p.seriesId != null
          ? seriesUuids[p.seriesId]
          : seasonUuids[p.seasonId];
      if (subject == null) continue;
      add(
        SyncRecord(
          SyncEntityType.personalState,
          SyncIds.personalState(subject),
          {
            'subjectId': subject,
            'subjectType': p.seasonId != null ? 'season' : 'title',
            'onWishlist': p.onWishlist,
            'maxPrice': p.maxPrice,
            'watchStatus': p.watchStatus,
            'watchCount': p.watchCount,
            'lastWatchedAt': p.lastWatchedAt?.toUtc().toIso8601String(),
            'rating': p.rating,
            'favourite': p.favourite,
            'tags': p.tags,
            'preferredEditionId': p.preferredEditionUuid,
          },
        ),
      );
    }
    for (final s in await _db.select(_db.streamingSubscriptions).get()) {
      add(
        SyncRecord(
          SyncEntityType.subscription,
          SyncIds.subscription(s.providerId),
          {
            'providerId': s.providerId,
            'providerName': s.providerName,
            'logoPath': s.logoPath,
          },
        ),
      );
    }
    return records;
  }

  static String movieUuid(MovieRow m) =>
      m.tmdbId != null ? SyncIds.movie(m.tmdbId!) : m.uuid!;

  /// Writes records from another device. [local] is the result of
  /// [buildAll] before the write; it maps UUIDs to what exists here.
  /// Records listed in [deleted] are removed.
  Future<void> apply(
    List<SyncRecord> upserts,
    List<({String type, String uuid})> deleted,
    Map<String, SyncRecord> local,
  ) async {
    final ordered = [...upserts]
      ..sort(
        (a, b) => SyncEntityType.applyOrder
            .indexOf(a.type)
            .compareTo(SyncEntityType.applyOrder.indexOf(b.type)),
      );
    for (final record in ordered) {
      await _upsert(record);
    }
    // Remove dependants first: copies before editions before titles.
    final removals = [...deleted]
      ..sort(
        (a, b) => SyncEntityType.applyOrder
            .indexOf(b.type)
            .compareTo(SyncEntityType.applyOrder.indexOf(a.type)),
      );
    for (final removal in removals) {
      final known = local[removal.uuid];
      if (known != null) await _delete(known);
    }
  }

  Future<void> _upsert(SyncRecord r) async {
    final f = r.fields;
    switch (r.type) {
      case SyncEntityType.title:
        if (f['kind'] == 'series') {
          await _upsertSeries(f);
        } else {
          await _upsertMovie(r.uuid, f);
        }
      case SyncEntityType.season:
        await _upsertSeason(f);
      case SyncEntityType.edition:
        await _upsertEdition(r.uuid, f);
      case SyncEntityType.editionContent:
        await _upsertContent(f);
      case SyncEntityType.copy:
        await _upsertCopy(r.uuid, f);
      case SyncEntityType.barcode:
        await _upsertBarcode(f);
      case SyncEntityType.personalState:
        await _upsertPersonalState(f);
      case SyncEntityType.subscription:
        await _db
            .into(_db.streamingSubscriptions)
            .insertOnConflictUpdate(
              StreamingSubscriptionsCompanion.insert(
                providerId: Value(f['providerId'] as int),
                providerName: f['providerName'] as String? ?? '',
                logoPath: Value(f['logoPath'] as String?),
              ),
            );
    }
  }

  Future<MovieRow?> movieByUuid(String uuid) async {
    final byUuid = await (_db.select(
      _db.movies,
    )..where((t) => t.uuid.equals(uuid))).getSingleOrNull();
    if (byUuid != null) return byUuid;
    // Movies with a TMDB id use a derived UUID that is not stored.
    for (final m in await (_db.select(
      _db.movies,
    )..where((t) => t.tmdbId.isNotNull())).get()) {
      if (SyncIds.movie(m.tmdbId!) == uuid) return m;
    }
    return null;
  }

  Future<TvSeriesRow?> _seriesByUuid(String? uuid) async {
    if (uuid == null) return null;
    for (final s in await _db.select(_db.tvSeriesTable).get()) {
      if (SyncIds.series(s.tmdbId) == uuid) return s;
    }
    return null;
  }

  Future<TvSeasonRow?> _seasonByUuid(String? uuid) async {
    if (uuid == null) return null;
    for (final series in await _db.select(_db.tvSeriesTable).get()) {
      for (final s in await (_db.select(
        _db.tvSeasonsTable,
      )..where((t) => t.seriesId.equals(series.id))).get()) {
        if (SyncIds.season(series.tmdbId, s.seasonNumber) == uuid) return s;
      }
    }
    return null;
  }

  Future<PhysicalEditionRow?> _editionByUuid(String? uuid) async {
    if (uuid == null) return null;
    return (_db.select(
      _db.physicalEditions,
    )..where((t) => t.uuid.equals(uuid))).getSingleOrNull();
  }

  Future<void> _upsertMovie(String uuid, Map<String, Object?> f) async {
    final tmdbId = f['tmdbId'] as int?;
    final existing = tmdbId != null
        ? await (_db.select(
            _db.movies,
          )..where((t) => t.tmdbId.equals(tmdbId))).getSingleOrNull()
        : await movieByUuid(uuid);
    final companion = MoviesCompanion(
      title: Value(f['title'] as String? ?? ''),
      originalTitle: Value(f['originalTitle'] as String?),
      releaseYear: Value(f['year'] as int?),
      runtime: Value(f['runtime'] as int?),
      posterPath: Value(f['posterPath'] as String?),
      tmdbCollectionId: Value(f['tmdbCollectionId'] as int?),
    );
    if (existing != null) {
      await (_db.update(
        _db.movies,
      )..where((t) => t.id.equals(existing.id))).write(companion);
      return;
    }
    // Details such as the overview are loaded from TMDB later, because
    // lastMetadataSyncAt stays empty.
    await _db
        .into(_db.movies)
        .insert(
          companion.copyWith(
            tmdbId: Value(tmdbId),
            uuid: Value(tmdbId == null ? uuid : null),
          ),
        );
  }

  Future<void> _upsertSeries(Map<String, Object?> f) async {
    final tmdbId = f['tmdbId'] as int;
    final year = f['year'] as int?;
    final companion = TvSeriesTableCompanion(
      name: Value(f['title'] as String? ?? ''),
      originalName: Value(f['originalTitle'] as String?),
      posterPath: Value(f['posterPath'] as String?),
    );
    final existing = await (_db.select(
      _db.tvSeriesTable,
    )..where((t) => t.tmdbId.equals(tmdbId))).getSingleOrNull();
    if (existing != null) {
      await (_db.update(
        _db.tvSeriesTable,
      )..where((t) => t.id.equals(existing.id))).write(companion);
      return;
    }
    await _db
        .into(_db.tvSeriesTable)
        .insert(
          companion.copyWith(
            tmdbId: Value(tmdbId),
            firstAirDate: Value(year == null ? null : DateTime(year)),
          ),
        );
  }

  Future<void> _upsertSeason(Map<String, Object?> f) async {
    final series = await _seriesByUuid(f['seriesId'] as String?);
    if (series == null) return;
    final number = f['seasonNumber'] as int;
    final companion = TvSeasonsTableCompanion(
      name: Value(f['name'] as String? ?? 'Staffel $number'),
      tmdbSeasonId: Value(f['tmdbSeasonId'] as int?),
      posterPath: Value(f['posterPath'] as String?),
      episodeCount: Value(f['episodeCount'] as int?),
    );
    final existing =
        await (_db.select(_db.tvSeasonsTable)..where(
              (t) =>
                  t.seriesId.equals(series.id) & t.seasonNumber.equals(number),
            ))
            .getSingleOrNull();
    if (existing != null) {
      await (_db.update(
        _db.tvSeasonsTable,
      )..where((t) => t.id.equals(existing.id))).write(companion);
      return;
    }
    await _db
        .into(_db.tvSeasonsTable)
        .insert(
          companion.copyWith(
            seriesId: Value(series.id),
            seasonNumber: Value(number),
          ),
        );
  }

  Future<void> _upsertEdition(String uuid, Map<String, Object?> f) async {
    final companion = PhysicalEditionsCompanion(
      mediaKind: Value(
        f['kind'] as String? ?? PhysicalEditionKind.singleMovie.name,
      ),
      format: Value(f['format'] as String? ?? 'unknown'),
      productTitle: Value(f['productTitle'] as String?),
      editionName: Value(f['editionName'] as String?),
      region: Value(f['region'] as String?),
      releaseCountry: Value(f['releaseCountry'] as String?),
      audioLanguages: Value(f['audioLanguages'] as String?),
      subtitleLanguages: Value(f['subtitleLanguages'] as String?),
      publisher: Value(f['publisher'] as String?),
      notes: Value(f['notes'] as String?),
      tmdbCollectionId: Value(f['tmdbCollectionId'] as int?),
      tmdbTvSeriesId: Value(f['tmdbTvSeriesId'] as int?),
    );
    final existing = await _editionByUuid(uuid);
    if (existing != null) {
      await (_db.update(
        _db.physicalEditions,
      )..where((t) => t.id.equals(existing.id))).write(companion);
      return;
    }
    await _db
        .into(_db.physicalEditions)
        .insert(companion.copyWith(uuid: Value(uuid)));
  }

  Future<void> _upsertContent(Map<String, Object?> f) async {
    final edition = await _editionByUuid(f['editionId'] as String?);
    if (edition == null) return;
    final subject = f['subjectId'] as String?;
    if (f['subjectType'] == 'season') {
      final season = await _seasonByUuid(subject);
      if (season == null) return;
      await _db
          .into(_db.physicalEditionTvSeasons)
          .insert(
            PhysicalEditionTvSeasonsCompanion.insert(
              editionId: edition.id,
              seasonId: season.id,
            ),
            mode: InsertMode.insertOrIgnore,
          );
    } else {
      final movie = subject == null ? null : await movieByUuid(subject);
      if (movie == null) return;
      await _db
          .into(_db.physicalEditionMovies)
          .insert(
            PhysicalEditionMoviesCompanion.insert(
              editionId: edition.id,
              movieId: movie.id,
            ),
            mode: InsertMode.insertOrIgnore,
          );
    }
  }

  Future<void> _upsertCopy(String uuid, Map<String, Object?> f) async {
    final edition = await _editionByUuid(f['editionId'] as String?);
    if (edition == null) return;
    final purchase = f['purchaseDate'] as String?;
    final companion = OwnedCopiesCompanion(
      editionId: Value(edition.id),
      quantity: Value(f['quantity'] as int? ?? 1),
      condition: Value(f['condition'] as String?),
      purchaseDate: Value(purchase == null ? null : DateTime.parse(purchase)),
      purchasePrice: Value((f['purchasePrice'] as num?)?.toDouble()),
      storageLocation: Value(f['storageLocation'] as String?),
      notes: Value(f['notes'] as String?),
      updatedAt: Value(DateTime.now()),
    );
    final existing = await (_db.select(
      _db.ownedCopies,
    )..where((t) => t.uuid.equals(uuid))).getSingleOrNull();
    if (existing != null) {
      await (_db.update(
        _db.ownedCopies,
      )..where((t) => t.id.equals(existing.id))).write(companion);
      return;
    }
    await _db
        .into(_db.ownedCopies)
        .insert(companion.copyWith(uuid: Value(uuid)));
  }

  Future<void> _upsertBarcode(Map<String, Object?> f) async {
    final code = f['code'] as String;
    final edition = await _editionByUuid(f['editionId'] as String?);
    final titleId = f['titleId'] as String?;
    final movie = titleId == null ? null : await movieByUuid(titleId);
    if (edition == null && movie == null) return;
    final companion = BarcodesCompanion(
      barcodeType: Value(f['type'] as String? ?? 'EAN'),
      physicalEditionId: Value(edition?.id),
      movieId: Value(movie?.id),
      productTitle: Value(f['productTitle'] as String?),
      editionName: Value(f['editionName'] as String?),
      physicalFormat: Value(f['format'] as String?),
      region: Value(f['region'] as String?),
      imdbId: Value(f['imdbId'] as String?),
      verified: Value(f['verified'] as bool? ?? false),
      source: const Value('sync'),
      updatedAt: Value(DateTime.now()),
    );
    final existing = await (_db.select(
      _db.barcodes,
    )..where((t) => t.barcode.equals(code))).getSingleOrNull();
    if (existing != null) {
      await (_db.update(
        _db.barcodes,
      )..where((t) => t.id.equals(existing.id))).write(companion);
      return;
    }
    await _db
        .into(_db.barcodes)
        .insert(companion.copyWith(barcode: Value(code)));
  }

  Future<void> _upsertPersonalState(Map<String, Object?> f) async {
    final subject = f['subjectId'] as String?;
    int? movieId;
    int? seriesId;
    int? seasonId;
    if (f['subjectType'] == 'season') {
      seasonId = (await _seasonByUuid(subject))?.id;
    } else if (subject != null) {
      movieId = (await movieByUuid(subject))?.id;
      if (movieId == null) seriesId = (await _seriesByUuid(subject))?.id;
    }
    if (movieId == null && seriesId == null && seasonId == null) return;
    final watched = f['lastWatchedAt'] as String?;
    final companion = PersonalStatesCompanion(
      onWishlist: Value(f['onWishlist'] as bool? ?? false),
      maxPrice: Value((f['maxPrice'] as num?)?.toDouble()),
      watchStatus: Value(f['watchStatus'] as String?),
      watchCount: Value(f['watchCount'] as int? ?? 0),
      lastWatchedAt: Value(watched == null ? null : DateTime.parse(watched)),
      rating: Value(f['rating'] as int?),
      favourite: Value(f['favourite'] as bool? ?? false),
      tags: Value(f['tags'] as String?),
      preferredEditionUuid: Value(f['preferredEditionId'] as String?),
      updatedAt: Value(DateTime.now()),
    );
    final existing =
        await (_db.select(_db.personalStates)..where(
              (t) => movieId != null
                  ? t.movieId.equals(movieId)
                  : seriesId != null
                  ? t.seriesId.equals(seriesId)
                  : t.seasonId.equals(seasonId!),
            ))
            .getSingleOrNull();
    if (existing != null) {
      await (_db.update(
        _db.personalStates,
      )..where((t) => t.id.equals(existing.id))).write(companion);
      return;
    }
    await _db
        .into(_db.personalStates)
        .insert(
          companion.copyWith(
            movieId: Value(movieId),
            seriesId: Value(seriesId),
            seasonId: Value(seasonId),
          ),
        );
  }

  Future<void> _delete(SyncRecord known) async {
    final f = known.fields;
    switch (known.type) {
      case SyncEntityType.title:
        if (f['kind'] == 'series') {
          await (_db.delete(
            _db.tvSeriesTable,
          )..where((t) => t.tmdbId.equals(f['tmdbId'] as int))).go();
        } else {
          final movie = await movieByUuid(known.uuid);
          if (movie != null) {
            await (_db.delete(
              _db.movies,
            )..where((t) => t.id.equals(movie.id))).go();
          }
        }
      case SyncEntityType.season:
        final season = await _seasonByUuid(known.uuid);
        if (season != null) {
          await (_db.delete(
            _db.tvSeasonsTable,
          )..where((t) => t.id.equals(season.id))).go();
        }
      case SyncEntityType.edition:
        await (_db.delete(
          _db.physicalEditions,
        )..where((t) => t.uuid.equals(known.uuid))).go();
      case SyncEntityType.editionContent:
        final edition = await _editionByUuid(f['editionId'] as String?);
        if (edition == null) return;
        if (f['subjectType'] == 'season') {
          final season = await _seasonByUuid(f['subjectId'] as String?);
          if (season == null) return;
          await (_db.delete(_db.physicalEditionTvSeasons)..where(
                (t) =>
                    t.editionId.equals(edition.id) &
                    t.seasonId.equals(season.id),
              ))
              .go();
        } else {
          final movie = await movieByUuid(f['subjectId'] as String);
          if (movie == null) return;
          await (_db.delete(_db.physicalEditionMovies)..where(
                (t) =>
                    t.editionId.equals(edition.id) & t.movieId.equals(movie.id),
              ))
              .go();
        }
      case SyncEntityType.copy:
        await (_db.delete(
          _db.ownedCopies,
        )..where((t) => t.uuid.equals(known.uuid))).go();
      case SyncEntityType.barcode:
        await (_db.delete(
          _db.barcodes,
        )..where((t) => t.barcode.equals(f['code'] as String))).go();
      case SyncEntityType.subscription:
        await (_db.delete(
          _db.streamingSubscriptions,
        )..where((t) => t.providerId.equals(f['providerId'] as int))).go();
      case SyncEntityType.personalState:
        final subject = f['subjectId'] as String?;
        if (subject == null) return;
        if (f['subjectType'] == 'season') {
          final season = await _seasonByUuid(subject);
          if (season == null) return;
          await (_db.delete(
            _db.personalStates,
          )..where((t) => t.seasonId.equals(season.id))).go();
        } else {
          final movie = await movieByUuid(subject);
          final series = movie == null ? await _seriesByUuid(subject) : null;
          await (_db.delete(_db.personalStates)..where(
                (t) => movie != null
                    ? t.movieId.equals(movie.id)
                    : t.seriesId.equals(series?.id ?? -1),
              ))
              .go();
        }
    }
  }
}
