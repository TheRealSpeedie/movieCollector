import 'package:drift/drift.dart';

@DataClassName('TvSeriesRow')
class TvSeriesTable extends Table {
  @override
  String get tableName => 'tv_series';
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tmdbId => integer().unique()();
  TextColumn get name => text()();
  TextColumn get originalName => text().nullable()();
  TextColumn get overview => text().nullable()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get backdropPath => text().nullable()();
  DateTimeColumn get firstAirDate => dateTime().nullable()();
  DateTimeColumn get lastAirDate => dateTime().nullable()();
  IntColumn get numberOfSeasons => integer().nullable()();
  TextColumn get seriesStatus => text().nullable()();
  TextColumn get originalLanguage => text().nullable()();
  TextColumn get contentRating => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastMetadataSyncAt => dateTime().nullable()();
}
