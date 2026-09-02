import 'package:drift/drift.dart';

import 'genres_table.dart';
import 'tv_series_table.dart';

@DataClassName('TvSeriesGenreRow')
class TvSeriesGenres extends Table {
  IntColumn get seriesId =>
      integer().references(TvSeriesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get genreId =>
      integer().references(Genres, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {seriesId, genreId};
}
