import 'package:drift/drift.dart';

@DataClassName('BarcodeLookupCacheRow')
class BarcodeLookupCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get barcode => text()();
  TextColumn get provider => text()();
  TextColumn get outcome => text()();
  TextColumn get payload => text().nullable()();
  DateTimeColumn get fetchedAt => dateTime()();
  DateTimeColumn get expiresAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {barcode, provider},
  ];
}
