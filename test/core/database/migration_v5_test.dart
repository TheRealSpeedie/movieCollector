import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/app_database.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:sqlite3/sqlite3.dart';

void main() {
  test(
    'v5 turns owned titles into copies and the wishlist into personal state',
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
      // 1 owned with a scanned Blu-ray, 2 and 5 owned without barcode,
      // 3 on the wishlist, 4 open.
      for (final row in [
        "(1, 'Der Pate', 238, 'owned')",
        "(2, 'Heat', 949, 'owned')",
        "(3, 'Alien', 348, 'wishlist')",
        "(4, 'Aliens', 679, 'open')",
        "(5, 'Alien 3', 8077, 'owned')",
      ]) {
        sqlite.execute(
          'INSERT INTO movies (id, title, tmdb_id, user_status) VALUES $row;',
        );
      }
      sqlite.execute(
        "INSERT INTO barcodes (movie_id, barcode, barcode_type, product_title) "
        "VALUES (1, '4001234567890', 'EAN-13', 'Der Pate Blu-ray');",
      );
      sqlite.execute('PRAGMA user_version = 1;');

      final db = AppDatabase(NativeDatabase.opened(sqlite));
      final movies = {
        for (final m in await db.select(db.movies).get()) m.id: m,
      };
      expect(movies, hasLength(5));
      expect(movies.values.every((m) => m.uuid != null), isTrue);

      // Status survives, now derived from copies and personal state.
      expect(movies[1]!.userStatus, CollectionStatus.owned);
      expect(movies[2]!.userStatus, CollectionStatus.owned);
      expect(movies[3]!.userStatus, CollectionStatus.wishlist);
      expect(movies[4]!.userStatus, CollectionStatus.open);
      expect(movies[5]!.userStatus, CollectionStatus.owned);

      final barcode = await db.select(db.barcodes).getSingle();
      final copies = await db.select(db.ownedCopies).get();
      // The scanned edition of film 1 is owned, film 2 and 5 got their own.
      expect(copies, hasLength(3));
      expect(
        copies.map((c) => c.editionId),
        contains(barcode.physicalEditionId),
      );

      final states = await db.select(db.personalStates).get();
      expect(states.single.movieId, 3);
      expect(states.single.onWishlist, isTrue);

      final editions = await db.select(db.physicalEditions).get();
      expect(editions.every((e) => e.uuid != null), isTrue);
      await db.close();
    },
  );
}
