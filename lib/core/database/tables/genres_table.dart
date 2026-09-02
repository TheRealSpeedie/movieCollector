import 'package:drift/drift.dart';

@DataClassName('GenreRow')
class Genres extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tmdbId => integer().unique()();
  TextColumn get name => text()();
}
