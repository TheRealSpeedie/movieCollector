import 'package:drift/drift.dart';

import 'movies_table.dart';
import 'tv_seasons_table.dart';
import 'tv_series_table.dart';

/// Wishlist, watch history and rating of one movie, series or season,
/// independent of whether the user owns it. Exactly one subject is set.
@DataClassName('PersonalStateRow')
class PersonalStates extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get movieId => integer().nullable().unique().references(
    Movies,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get seriesId => integer().nullable().unique().references(
    TvSeriesTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get seasonId => integer().nullable().unique().references(
    TvSeasonsTable,
    #id,
    onDelete: KeyAction.cascade,
  )();
  BoolColumn get onWishlist => boolean().withDefault(const Constant(false))();
  RealColumn get maxPrice => real().nullable()();

  /// unwatched, watching or watched.
  TextColumn get watchStatus => text().nullable()();
  IntColumn get watchCount => integer().withDefault(const Constant(0))();
  DateTimeColumn get lastWatchedAt => dateTime().nullable()();

  /// 1 to 10.
  IntColumn get rating => integer().nullable()();
  BoolColumn get favourite => boolean().withDefault(const Constant(false))();
  TextColumn get tags => text().nullable()();
  TextColumn get preferredEditionUuid => text().nullable()();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
