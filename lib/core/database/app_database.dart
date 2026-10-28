import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../shared/models/collection_status.dart';
import '../../shared/models/physical_edition_kind.dart';
import '../constants/app_constants.dart';
import '../sync/sync_ids.dart';
import 'media_format.dart';
import 'converters/collection_status_converter.dart';
import 'tables/barcode_lookup_cache_table.dart';
import 'tables/barcodes_table.dart';
import 'tables/collection_movies_table.dart';
import 'tables/collections_table.dart';
import 'tables/genres_table.dart';
import 'tables/movie_genres_table.dart';
import 'tables/movies_table.dart';
import 'tables/physical_edition_movies_table.dart';
import 'tables/physical_edition_tv_seasons_table.dart';
import 'tables/physical_editions_table.dart';
import 'tables/owned_copies_table.dart';
import 'tables/personal_states_table.dart';
import 'tables/scan_tables.dart';
import 'tables/streaming_tables.dart';
import 'tables/sync_tables.dart';
import 'tables/tv_seasons_table.dart';
import 'tables/tv_series_genres_table.dart';
import 'tables/tv_series_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Movies,
    Genres,
    MovieGenres,
    Barcodes,
    BarcodeLookupCache,
    Collections,
    CollectionMovies,
    TvSeriesTable,
    TvSeasonsTable,
    TvSeriesGenres,
    PhysicalEditions,
    PhysicalEditionMovies,
    PhysicalEditionTvSeasons,
    OwnedCopies,
    PersonalStates,
    SyncShadow,
    SyncConflicts,
    SyncMeta,
    PendingScans,
    ScanHistory,
    StreamingOffers,
    StreamingChecks,
    StreamingSubscriptions,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 7;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (migrator) async {
      await migrator.createAll();
      await _createIndexes(migrator);
    },
    onUpgrade: (migrator, from, to) async {
      if (from < 2) {
        await migrator.createTable(tvSeriesTable);
        await migrator.createTable(tvSeasonsTable);
        await migrator.createTable(tvSeriesGenres);
        await migrator.createTable(physicalEditions);
        await migrator.createTable(physicalEditionMovies);
        await migrator.createTable(physicalEditionTvSeasons);
        await customStatement('PRAGMA foreign_keys = OFF');
        await customStatement('''
CREATE TABLE barcodes_new (
  id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  movie_id INTEGER NULL REFERENCES movies (id) ON DELETE CASCADE,
  physical_edition_id INTEGER NULL REFERENCES physical_editions (id) ON DELETE SET NULL,
  barcode TEXT NOT NULL UNIQUE,
  barcode_type TEXT NOT NULL,
  product_title TEXT NULL,
  edition_name TEXT NULL,
  created_at INTEGER NOT NULL
);
''');
        await customStatement('''
INSERT INTO barcodes_new (id, movie_id, barcode, barcode_type, product_title, edition_name, created_at)
SELECT id, movie_id, barcode, barcode_type, product_title, edition_name, created_at FROM barcodes;
''');
        await customStatement('DROP TABLE barcodes');
        await customStatement('ALTER TABLE barcodes_new RENAME TO barcodes');
        await customStatement('PRAGMA foreign_keys = ON');
        await _createIndexes(migrator);
      }
      if (from < 3) {
        await migrator.addColumn(barcodes, barcodes.physicalFormat);
        await migrator.addColumn(barcodes, barcodes.region);
        await migrator.addColumn(barcodes, barcodes.imdbId);
        await migrator.addColumn(barcodes, barcodes.source);
        await migrator.addColumn(barcodes, barcodes.verified);
        await migrator.addColumn(barcodes, barcodes.updatedAt);
        await migrator.createTable(barcodeLookupCache);
        await customStatement(
          "UPDATE barcodes SET verified = 1, source = 'user' WHERE source IS NULL",
        );
      }
      if (from == 4) {
        // v4 kept the projection sync state; v5 replaces it with sync_shadow.
        await migrator.deleteTable('sync_states');
      }
      if (from < 5) {
        await _addColumnIfMissing('movies', movies.uuid);
        for (final column in [
          physicalEditions.uuid,
          physicalEditions.format,
          physicalEditions.region,
          physicalEditions.releaseCountry,
          physicalEditions.audioLanguages,
          physicalEditions.subtitleLanguages,
          physicalEditions.publisher,
          physicalEditions.notes,
        ]) {
          await _addColumnIfMissing('physical_editions', column);
        }
        await migrator.createTable(ownedCopies);
        await migrator.createTable(personalStates);
        await migrator.createTable(syncShadow);
        await migrator.createTable(syncConflicts);
        await migrator.createTable(syncMeta);
        await migrator.createTable(pendingScans);
        await migrator.createTable(scanHistory);
      }
      if (from < 2) {
        await _backfillPhysicalEditions();
      }
      if (from < 5) {
        await _migrateToOwnershipModel();
        await _createIndexes(migrator);
      }
      if (from < 6) {
        await migrator.createTable(streamingOffers);
        await migrator.createTable(streamingChecks);
        await migrator.createTable(streamingSubscriptions);
      }
      if (from < 7) {
        await _addColumnIfMissing('owned_copies', ownedCopies.ownerId);
        await _addColumnIfMissing('owned_copies', ownedCopies.isPrivate);
        await _addColumnIfMissing(
          'physical_editions',
          physicalEditions.catalogId,
        );
        await _addColumnIfMissing('physical_editions', physicalEditions.source);
      }
    },
  );

  /// Tables created by an earlier step of the same upgrade already have the
  /// newest columns, so adding them again is skipped.
  Future<void> _addColumnIfMissing(
    String table,
    GeneratedColumn<Object> column,
  ) async {
    if (await _hasColumn(table, column.name)) return;
    // Every column added in v5 holds text.
    const type = "TEXT";
    final fallback = column == physicalEditions.format
        ? " NOT NULL DEFAULT 'unknown'"
        : '';
    await customStatement(
      'ALTER TABLE $table ADD COLUMN ${column.name} $type$fallback',
    );
  }

  Future<bool> _hasColumn(String table, String column) async {
    final columns = await customSelect('PRAGMA table_info($table)').get();
    return columns.any((c) => c.read<String>('name') == column);
  }

  /// v5: ownership moves from one status per title to copies of editions plus
  /// a separate wishlist flag. Every owned title gets a copy of each edition
  /// that only holds owned titles, or of a new edition made for it.
  Future<void> _migrateToOwnershipModel() async {
    for (final row in await customSelect(
      'SELECT id FROM movies WHERE uuid IS NULL',
    ).get()) {
      await customStatement('UPDATE movies SET uuid = ? WHERE id = ?', [
        SyncIds.random(),
        row.read<int>('id'),
      ]);
    }
    for (final row in await customSelect(
      'SELECT id FROM physical_editions WHERE uuid IS NULL',
    ).get()) {
      await customStatement(
        'UPDATE physical_editions SET uuid = ? WHERE id = ?',
        [SyncIds.random(), row.read<int>('id')],
      );
    }

    // Format and region used to be stored on the barcode.
    for (final row in await customSelect(
      'SELECT physical_edition_id AS edition, physical_format AS format, region '
      'FROM barcodes WHERE physical_edition_id IS NOT NULL',
    ).get()) {
      final format = MediaFormat.parse(row.readNullable<String>('format'));
      await customStatement(
        "UPDATE physical_editions SET format = CASE WHEN format = 'unknown' "
        'THEN ? ELSE format END, region = COALESCE(region, ?) WHERE id = ?',
        [
          format.name,
          row.readNullable<String>('region'),
          row.read<int>('edition'),
        ],
      );
    }

    final ownedMovies = await customSelect(
      "SELECT id, title FROM movies WHERE user_status = 'owned'",
    ).get();
    for (final movie in ownedMovies) {
      final movieId = movie.read<int>('id');
      final editions = await customSelect(
        'SELECT em.edition_id AS id FROM physical_edition_movies em '
        'WHERE em.movie_id = ? AND NOT EXISTS ('
        '  SELECT 1 FROM physical_edition_movies other '
        '  JOIN movies m ON m.id = other.movie_id '
        "  WHERE other.edition_id = em.edition_id AND m.user_status != 'owned') "
        'AND NOT EXISTS (SELECT 1 FROM physical_edition_tv_seasons s '
        '  WHERE s.edition_id = em.edition_id)',
        variables: [Variable.withInt(movieId)],
      ).get();
      var editionIds = editions.map((e) => e.read<int>('id')).toList();
      if (editionIds.isEmpty) {
        final editionId = await into(physicalEditions).insert(
          PhysicalEditionsCompanion.insert(
            productTitle: Value(movie.read<String>('title')),
            mediaKind: PhysicalEditionKind.singleMovie.name,
          ),
        );
        await into(physicalEditionMovies).insert(
          PhysicalEditionMoviesCompanion.insert(
            editionId: editionId,
            movieId: movieId,
          ),
        );
        editionIds = [editionId];
      }
      for (final editionId in editionIds) {
        await _ensureCopy(editionId);
      }
    }

    final ownedSeasons = await customSelect(
      'SELECT s.id, s.season_number, t.name FROM tv_seasons s '
      "JOIN tv_series t ON t.id = s.series_id WHERE s.user_status = 'owned'",
    ).get();
    for (final season in ownedSeasons) {
      final seasonId = season.read<int>('id');
      final editions = await customSelect(
        'SELECT es.edition_id AS id FROM physical_edition_tv_seasons es '
        'WHERE es.season_id = ? AND NOT EXISTS ('
        '  SELECT 1 FROM physical_edition_tv_seasons other '
        '  JOIN tv_seasons s ON s.id = other.season_id '
        '  WHERE other.edition_id = es.edition_id '
        "  AND (s.user_status IS NULL OR s.user_status != 'owned')) "
        'AND NOT EXISTS (SELECT 1 FROM physical_edition_movies m '
        '  WHERE m.edition_id = es.edition_id)',
        variables: [Variable.withInt(seasonId)],
      ).get();
      var editionIds = editions.map((e) => e.read<int>('id')).toList();
      if (editionIds.isEmpty) {
        final editionId = await into(physicalEditions).insert(
          PhysicalEditionsCompanion.insert(
            productTitle: Value(
              '${season.read<String>('name')} – Staffel '
              '${season.read<int>('season_number')}',
            ),
            mediaKind: PhysicalEditionKind.singleTvSeason.name,
          ),
        );
        await into(physicalEditionTvSeasons).insert(
          PhysicalEditionTvSeasonsCompanion.insert(
            editionId: editionId,
            seasonId: seasonId,
          ),
        );
        editionIds = [editionId];
      }
      for (final editionId in editionIds) {
        await _ensureCopy(editionId);
      }
    }

    await customStatement(
      'INSERT INTO personal_states (movie_id, on_wishlist) '
      "SELECT id, 1 FROM movies WHERE user_status = 'wishlist'",
    );
    await customStatement(
      'INSERT INTO personal_states (season_id, on_wishlist) '
      "SELECT id, 1 FROM tv_seasons WHERE user_status = 'wishlist'",
    );
  }

  Future<void> _ensureCopy(int editionId) async {
    final existing = await (select(
      ownedCopies,
    )..where((t) => t.editionId.equals(editionId))).get();
    if (existing.isNotEmpty) return;
    await into(
      ownedCopies,
    ).insert(OwnedCopiesCompanion.insert(editionId: editionId));
  }

  Future<void> _backfillPhysicalEditions() async {
    final existing = await select(barcodes).get();
    for (final row in existing) {
      if (row.movieId == null || row.physicalEditionId != null) continue;
      final editionId = await into(physicalEditions).insert(
        PhysicalEditionsCompanion.insert(
          productTitle: Value(row.productTitle),
          editionName: Value(row.editionName),
          mediaKind: PhysicalEditionKind.singleMovie.name,
          createdAt: Value(row.createdAt),
        ),
      );
      await into(physicalEditionMovies).insert(
        PhysicalEditionMoviesCompanion.insert(
          editionId: editionId,
          movieId: row.movieId!,
        ),
      );
      await (update(barcodes)..where((t) => t.id.equals(row.id))).write(
        BarcodesCompanion(physicalEditionId: Value(editionId)),
      );
    }
  }

  Future<int> upsertGenre({required int tmdbId, required String name}) async {
    await into(genres).insert(
      GenresCompanion.insert(tmdbId: tmdbId, name: name),
      onConflict: DoUpdate(
        (_) => GenresCompanion(name: Value(name)),
        target: [genres.tmdbId],
      ),
    );
    final row = await (select(
      genres,
    )..where((t) => t.tmdbId.equals(tmdbId))).getSingle();
    return row.id;
  }

  Future<void> _createIndexes(Migrator migrator) async {
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movies_tmdb_collection ON movies(tmdb_collection_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_movies_status ON movies(user_status);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_barcodes_movie ON barcodes(movie_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_barcodes_edition ON barcodes(physical_edition_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_collection_movies_collection ON collection_movies(collection_id);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_tv_seasons_series ON tv_seasons(series_id);',
    );
    if (!await _hasColumn('movies', 'uuid')) return;
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_movies_uuid ON movies(uuid);',
    );
    await customStatement(
      'CREATE UNIQUE INDEX IF NOT EXISTS idx_physical_editions_uuid '
      'ON physical_editions(uuid);',
    );
    await customStatement(
      'CREATE INDEX IF NOT EXISTS idx_owned_copies_edition '
      'ON owned_copies(edition_id);',
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}
