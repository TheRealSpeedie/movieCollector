import 'package:drift/drift.dart';

import 'movies_table.dart';
import 'physical_editions_table.dart';

@DataClassName('PhysicalEditionMovieRow')
class PhysicalEditionMovies extends Table {
  IntColumn get editionId => integer().references(
    PhysicalEditions,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get movieId =>
      integer().references(Movies, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {editionId, movieId};
}
