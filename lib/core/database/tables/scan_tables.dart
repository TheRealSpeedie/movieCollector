import 'package:drift/drift.dart';

/// Barcodes scanned without a connection, resolved once the device is online.
@DataClassName('PendingScanRow')
class PendingScans extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text().unique()();
  DateTimeColumn get scannedAt => dateTime().withDefault(currentDateAndTime)();
  IntColumn get attempts => integer().withDefault(const Constant(0))();
  TextColumn get lastError => text().nullable()();
}

/// Recently scanned items in Fundstück.
@DataClassName('ScanHistoryRow')
class ScanHistory extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get code => text()();
  TextColumn get title => text().nullable()();

  /// A ScanVerdict name.
  TextColumn get verdict => text()();
  IntColumn get movieId => integer().nullable()();
  DateTimeColumn get scannedAt => dateTime().withDefault(currentDateAndTime)();
}
