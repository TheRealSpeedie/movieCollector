import 'package:drift/drift.dart';

import '../../../shared/models/collection_status.dart';
import '../converters/collection_status_converter.dart';

@DataClassName('MovieRow')
class Movies extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tmdbId => integer().nullable().unique()();
  TextColumn get title => text()();
  TextColumn get originalTitle => text().nullable()();
  TextColumn get overview => text().nullable()();
  DateTimeColumn get releaseDate => dateTime().nullable()();
  IntColumn get releaseYear => integer().nullable()();
  IntColumn get runtime => integer().nullable()();
  TextColumn get posterPath => text().nullable()();
  TextColumn get backdropPath => text().nullable()();
  TextColumn get certification => text().nullable()();
  TextColumn get originalLanguage => text().nullable()();
  IntColumn get tmdbCollectionId => integer().nullable()();
  TextColumn get userStatus => text()
      .map(const CollectionStatusConverter())
      .withDefault(Constant(CollectionStatus.owned.name))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastMetadataSyncAt => dateTime().nullable()();
}
