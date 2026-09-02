import 'package:drift/drift.dart';

import '../../../shared/models/collection_status.dart';

class CollectionStatusConverter
    extends TypeConverter<CollectionStatus, String> {
  const CollectionStatusConverter();

  @override
  CollectionStatus fromSql(String fromDb) => CollectionStatus.fromName(fromDb);

  @override
  String toSql(CollectionStatus value) => value.name;
}
