import 'package:drift/drift.dart';

import 'collections_table.dart';

@DataClassName('CollectionMovieRow')
class CollectionMovies extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get collectionId =>
      integer().references(Collections, #id, onDelete: KeyAction.cascade)();
  IntColumn get tmdbMovieId => integer()();
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get posterPath => text().nullable()();
  DateTimeColumn get releaseDate => dateTime().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {collectionId, tmdbMovieId},
  ];
}
