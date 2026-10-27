import 'package:drift/drift.dart';

import '../../sync/sync_ids.dart';
import 'physical_editions_table.dart';

/// A physical item the user owns. Ownership of a title is derived from the
/// copies of editions that contain it.
@DataClassName('OwnedCopyRow')
class OwnedCopies extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique().clientDefault(SyncIds.random)();
  IntColumn get editionId => integer().references(
    PhysicalEditions,
    #id,
    onDelete: KeyAction.cascade,
  )();
  IntColumn get quantity => integer().withDefault(const Constant(1))();
  TextColumn get condition => text().nullable()();
  DateTimeColumn get purchaseDate => dateTime().nullable()();
  RealColumn get purchasePrice => real().nullable()();
  TextColumn get storageLocation => text().nullable()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
}
