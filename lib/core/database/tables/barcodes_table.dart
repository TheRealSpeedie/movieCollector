import 'package:drift/drift.dart';

import 'movies_table.dart';
import 'physical_editions_table.dart';

@DataClassName('BarcodeRow')
class Barcodes extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get movieId => integer().nullable().references(
    Movies,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get physicalEditionId => integer().nullable().references(
    PhysicalEditions,
    #id,
    onDelete: KeyAction.setNull,
  )();
  TextColumn get barcode => text().unique()();
  TextColumn get barcodeType => text()();
  TextColumn get productTitle => text().nullable()();
  TextColumn get editionName => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
