import 'package:drift/drift.dart';

import 'genres_table.dart';
import 'movies_table.dart';

@DataClassName('MovieGenreRow')
class MovieGenres extends Table {
  IntColumn get movieId =>
      integer().references(Movies, #id, onDelete: KeyAction.cascade)();
  IntColumn get genreId =>
      integer().references(Genres, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {movieId, genreId};
}
