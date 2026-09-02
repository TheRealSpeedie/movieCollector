import 'package:drift/drift.dart';

@DataClassName('PhysicalEditionRow')
class PhysicalEditions extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get productTitle => text().nullable()();
  TextColumn get editionName => text().nullable()();
  TextColumn get mediaKind => text()();
  IntColumn get tmdbCollectionId => integer().nullable()();
  IntColumn get tmdbTvSeriesId => integer().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
