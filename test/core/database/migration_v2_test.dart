import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'migrates v1 movie barcodes to physical editions without dropping movies',
    () async {
      final sqlite = sqlite3.openInMemory();
      sqlite.execute('''
      CREATE TABLE movies (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        tmdb_id INTEGER NULL UNIQUE,
        title TEXT NOT NULL,
        original_title TEXT NULL,
        overview TEXT NULL,
        release_date INTEGER NULL,
        release_year INTEGER NULL,
        runtime INTEGER NULL,
        poster_path TEXT NULL,
        backdrop_path TEXT NULL,
        certification TEXT NULL,
        original_language TEXT NULL,
        tmdb_collection_id INTEGER NULL,
        user_status TEXT NOT NULL DEFAULT 'owned',
        created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER) * 1000),
        updated_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER) * 1000),
        last_metadata_sync_at INTEGER NULL
      );
    ''');
      sqlite.execute('''
      CREATE TABLE genres (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        tmdb_id INTEGER NOT NULL UNIQUE,
        name TEXT NOT NULL
      );
    ''');
      sqlite.execute('''
      CREATE TABLE movie_genres (
        movie_id INTEGER NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
        genre_id INTEGER NOT NULL REFERENCES genres(id) ON DELETE CASCADE,
        PRIMARY KEY (movie_id, genre_id)
      );
    ''');
      sqlite.execute('''
      CREATE TABLE barcodes (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        movie_id INTEGER NOT NULL REFERENCES movies(id) ON DELETE CASCADE,
        barcode TEXT NOT NULL UNIQUE,
        barcode_type TEXT NOT NULL,
        product_title TEXT NULL,
        edition_name TEXT NULL,
        created_at INTEGER NOT NULL DEFAULT (CAST(strftime('%s','now') AS INTEGER) * 1000)
      );
    ''');
      sqlite.execute('''
      CREATE TABLE collections (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        tmdb_collection_id INTEGER NULL UNIQUE,
        name TEXT NOT NULL,
        overview TEXT NULL,
        poster_path TEXT NULL,
        backdrop_path TEXT NULL,
        is_custom INTEGER NOT NULL DEFAULT 0,
        last_synced_at INTEGER NULL
      );
    ''');
      sqlite.execute('''
      CREATE TABLE collection_movies (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        collection_id INTEGER NOT NULL REFERENCES collections(id) ON DELETE CASCADE,
        tmdb_movie_id INTEGER NOT NULL,
        title TEXT NOT NULL,
        original_title TEXT NULL,
        poster_path TEXT NULL,
        release_date INTEGER NULL,
        UNIQUE (collection_id, tmdb_movie_id)
      );
    ''');
      sqlite.execute("INSERT INTO movies (title) VALUES ('Der Pate');");
      sqlite.execute(
        "INSERT INTO barcodes (movie_id, barcode, barcode_type, product_title) "
        "VALUES (1, '4001234567890', 'EAN-13', 'Der Pate DVD');",
      );
      sqlite.execute('PRAGMA user_version = 1;');

      final db = AppDatabase(NativeDatabase.opened(sqlite));
      final movies = await db.select(db.movies).get();
      expect(movies, hasLength(1));
      expect(movies.single.title, 'Der Pate');

      final editions = await db.select(db.physicalEditions).get();
      expect(editions, hasLength(1));
      expect(editions.single.mediaKind, 'singleMovie');

      final barcode = await db.select(db.barcodes).getSingle();
      expect(barcode.movieId, 1);
      expect(barcode.physicalEditionId, editions.single.id);

      final series = await db.select(db.tvSeriesTable).get();
      expect(series, isEmpty);
      await db.close();
    },
  );
}
