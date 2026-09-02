import 'package:drift/drift.dart';

import '../converters/collection_status_converter.dart';
import 'tv_series_table.dart';

@DataClassName('TvSeasonRow')
class TvSeasonsTable extends Table {
  @override
  String get tableName => 'tv_seasons';
  IntColumn get id => integer().autoIncrement()();
  IntColumn get seriesId =>
      integer().references(TvSeriesTable, #id, onDelete: KeyAction.cascade)();
  IntColumn get tmdbSeasonId => integer().nullable()();
  IntColumn get seasonNumber => integer()();
  TextColumn get name => text()();
  TextColumn get overview => text().nullable()();
  TextColumn get posterPath => text().nullable()();
  DateTimeColumn get airDate => dateTime().nullable()();
  IntColumn get episodeCount => integer().nullable()();
  TextColumn get userStatus =>
      text().nullable().map(const CollectionStatusConverter())();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {seriesId, seasonNumber},
  ];
}
