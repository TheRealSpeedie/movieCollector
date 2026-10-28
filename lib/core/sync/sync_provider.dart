/// Transport of the collection sync protocol. The home server implements it
/// today, Movie Shelf Cloud will implement the same calls later.
library;

class SyncChange {
  const SyncChange({
    required this.opId,
    required this.entityType,
    required this.entityId,
    required this.baseSeq,
    required this.fields,
    this.deleted = false,
  });

  final String opId;
  final String entityType;
  final String entityId;
  final int baseSeq;
  final Map<String, Object?> fields;
  final bool deleted;

  Map<String, Object?> toJson() => {
    'opId': opId,
    'entityType': entityType,
    'entityId': entityId,
    'baseSeq': baseSeq,
    'fields': fields,
    'deleted': deleted,
  };
}

class RemoteRecord {
  const RemoteRecord({
    required this.type,
    required this.uuid,
    required this.seq,
    required this.deleted,
    required this.data,
  });

  factory RemoteRecord.fromJson(Map<String, dynamic> json) => RemoteRecord(
    type: json['entityType'] as String,
    uuid: json['entityId'] as String,
    seq: json['seq'] as int,
    deleted: json['deleted'] as bool? ?? false,
    data: Map<String, Object?>.from(json['data'] as Map? ?? const {}),
  );

  final String type;
  final String uuid;
  final int seq;
  final bool deleted;
  final Map<String, Object?> data;
}

enum SyncOutcome { applied, partial, conflict, unchanged }

class FieldConflict {
  const FieldConflict(this.field, this.serverValue, this.clientValue);

  factory FieldConflict.fromJson(Map<String, dynamic> json) => FieldConflict(
    json['field'] as String,
    json['serverValue'],
    json['clientValue'],
  );

  /// Set when one side deleted the record and the other changed it.
  static const deletedField = '_deleted';

  final String field;
  final Object? serverValue;
  final Object? clientValue;
}

class SyncPushResult {
  const SyncPushResult({
    required this.opId,
    required this.outcome,
    required this.seq,
    this.conflicts = const [],
    this.record,
  });

  factory SyncPushResult.fromJson(Map<String, dynamic> json) => SyncPushResult(
    opId: json['opId'] as String,
    outcome: SyncOutcome.values.byName(
      (json['outcome'] as String).toLowerCase(),
    ),
    seq: json['seq'] as int,
    conflicts: [
      for (final c in json['conflicts'] as List? ?? const [])
        FieldConflict.fromJson(c as Map<String, dynamic>),
    ],
    record: json['record'] == null
        ? null
        : RemoteRecord.fromJson(json['record'] as Map<String, dynamic>),
  );

  final String opId;
  final SyncOutcome outcome;
  final int seq;
  final List<FieldConflict> conflicts;

  /// The server copy, sent whenever the device cannot keep its own version.
  final RemoteRecord? record;
}

class SyncPullPage {
  const SyncPullPage({
    required this.changes,
    required this.nextCursor,
    required this.hasMore,
    required this.reset,
    this.collectionId,
    this.userId,
  });

  factory SyncPullPage.fromJson(Map<String, dynamic> json) => SyncPullPage(
    changes: [
      for (final c in json['changes'] as List)
        RemoteRecord.fromJson(c as Map<String, dynamic>),
    ],
    nextCursor: json['nextCursor'] as int,
    hasMore: json['hasMore'] as bool,
    reset: json['reset'] as bool? ?? false,
    collectionId: json['collectionId'] as String?,
    userId: (json['userId'] as num?)?.toInt(),
  );

  final List<RemoteRecord> changes;
  final int nextCursor;
  final bool hasMore;

  /// The device was away so long that deletions were cleaned up; it must
  /// load everything again from cursor 0.
  final bool reset;

  /// The collection on the other side. It changes when this account joins
  /// or leaves a household; the device then starts over.
  final String? collectionId;

  /// This person at the provider; owners of copies are given as this id.
  final int? userId;
}

class SyncSnapshotInfo {
  const SyncSnapshotInfo({required this.lastSeq, required this.counts});

  factory SyncSnapshotInfo.fromJson(Map<String, dynamic> json) =>
      SyncSnapshotInfo(
        lastSeq: json['lastSeq'] as int,
        counts: Map<String, int>.from(json['counts'] as Map),
      );

  final int lastSeq;
  final Map<String, int> counts;
}

abstract interface class CollectionSyncProvider {
  /// Identifies the collection on the other side. When it changes, the device
  /// starts over and sends its whole collection.
  String get scope;

  Future<List<SyncPushResult>> push(List<SyncChange> changes);

  Future<SyncPullPage> pull(int cursor, {int limit = 200});

  Future<SyncSnapshotInfo> snapshot();
}
