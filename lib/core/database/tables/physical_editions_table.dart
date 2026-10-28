import 'package:drift/drift.dart';

import '../../sync/sync_ids.dart';

@DataClassName('PhysicalEditionRow')
class PhysicalEditions extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// Sync identity. Unique through an index created in AppDatabase.
  TextColumn get uuid => text().nullable().clientDefault(SyncIds.random)();
  TextColumn get productTitle => text().nullable()();
  TextColumn get editionName => text().nullable()();
  TextColumn get mediaKind => text()();
  IntColumn get tmdbCollectionId => integer().nullable()();
  IntColumn get tmdbTvSeriesId => integer().nullable()();

  /// A MediaFormat name: dvd, bluray, uhd4k, vhs, digital or unknown.
  TextColumn get format => text().withDefault(const Constant('unknown'))();
  TextColumn get region => text().nullable()();
  TextColumn get releaseCountry => text().nullable()();

  /// Comma separated language codes, for example "de,en".
  TextColumn get audioLanguages => text().nullable()();
  TextColumn get subtitleLanguages => text().nullable()();
  TextColumn get publisher => text().nullable()();
  TextColumn get notes => text().nullable()();

  /// The entry in the edition catalog this edition was taken from or shared
  /// as. Stays usable offline; the catalog is only asked when online.
  TextColumn get catalogId => text().nullable()();

  /// user, catalog or a barcode service.
  TextColumn get source => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
}
