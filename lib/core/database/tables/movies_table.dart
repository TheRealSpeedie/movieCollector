import 'package:drift/drift.dart';

import '../../sync/sync_ids.dart';
import '../../../shared/models/collection_status.dart';
import '../converters/collection_status_converter.dart';

@DataClassName('MovieRow')
class Movies extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get tmdbId => integer().nullable().unique()();

  /// Sync identity of movies without a TMDB id. Movies with one use
  /// SyncIds.movie(tmdbId) so every device agrees on it.
  TextColumn get uuid => text().nullable().clientDefault(SyncIds.random)();
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

  /// Derived from copies and personal state by OwnershipService. Do not write directly.
  TextColumn get userStatus => text()
      .map(const CollectionStatusConverter())
      .withDefault(Constant(CollectionStatus.open.name))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get lastMetadataSyncAt => dateTime().nullable()();
}
