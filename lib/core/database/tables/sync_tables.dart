import 'package:drift/drift.dart';

/// The field values of each record as last agreed with the sync provider.
/// The difference between the collection and this shadow is what still has
/// to be sent, so nothing is lost when the app closes before syncing.
@DataClassName('SyncShadowRow')
class SyncShadow extends Table {
  TextColumn get uuid => text()();
  TextColumn get entityType => text()();
  IntColumn get baseSeq => integer()();
  TextColumn get fieldsJson => text()();

  @override
  Set<Column> get primaryKey => {uuid};
}

/// A field that two devices changed at the same time. Both values stay
/// here until the user picks one.
@DataClassName('SyncConflictRow')
class SyncConflicts extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get entityType => text()();
  TextColumn get entityUuid => text()();
  TextColumn get field => text()();
  TextColumn get localJson => text().nullable()();
  TextColumn get serverJson => text().nullable()();
  IntColumn get serverSeq => integer()();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();

  @override
  List<Set<Column>> get uniqueKeys => [
    {entityUuid, field},
  ];
}

@DataClassName('SyncMetaRow')
class SyncMeta extends Table {
  TextColumn get key => text()();
  TextColumn get value => text()();

  @override
  Set<Column> get primaryKey => {key};
}
