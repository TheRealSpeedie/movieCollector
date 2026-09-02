import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../shared/models/collection_status.dart';
import '../../shared/models/physical_edition_kind.dart';
import '../constants/app_constants.dart';
import 'converters/collection_status_converter.dart';
import 'tables/barcodes_table.dart';
import 'tables/collection_movies_table.dart';
import 'tables/collections_table.dart';
import 'tables/genres_table.dart';
import 'tables/movie_genres_table.dart';
import 'tables/movies_table.dart';
import 'tables/physical_edition_movies_table.dart';
import 'tables/physical_edition_tv_seasons_table.dart';
import 'tables/physical_editions_table.dart';
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
    Collections,
    CollectionMovies,
    TvSeriesTable,
    TvSeasonsTable,
    TvSeriesGenres,
    PhysicalEditions,
    PhysicalEditionMovies,
    PhysicalEditionTvSeasons,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 2;

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
        await _backfillPhysicalEditions();
      }
    },
  );

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
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, AppConstants.databaseFileName));
    return NativeDatabase.createInBackground(file);
  });
}
