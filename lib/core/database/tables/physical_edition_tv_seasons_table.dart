import 'package:drift/drift.dart';

import 'physical_editions_table.dart';
import 'tv_seasons_table.dart';

@DataClassName('PhysicalEditionTvSeasonRow')
class PhysicalEditionTvSeasons extends Table {
  IntColumn get editionId => integer().references(
    PhysicalEditions,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get seasonId =>
      integer().references(TvSeasonsTable, #id, onDelete: KeyAction.cascade)();

  @override
  Set<Column> get primaryKey => {editionId, seasonId};
}
