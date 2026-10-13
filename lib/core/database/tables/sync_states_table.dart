import 'package:drift/drift.dart';

@DataClassName('SyncStateRow')
class SyncStates extends Table {
  TextColumn get scope => text()();
  IntColumn get tmdbId => integer()();
  IntColumn get revision => integer()();
  TextColumn get syncedJson => text()();
  TextColumn get conflictJson => text().nullable()();

  @override
  Set<Column> get primaryKey => {scope, tmdbId};
}
