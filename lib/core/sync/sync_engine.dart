import 'dart:convert';

import 'package:drift/drift.dart';

import '../collection/ownership_service.dart';
import '../database/app_database.dart';
import 'collection_records.dart';
import 'sync_provider.dart';

class SyncReport {
  const SyncReport({
    required this.pushed,
    required this.received,
    required this.conflicts,
    required this.at,
  });

  final int pushed;
  final int received;
  final int conflicts;
  final DateTime at;
}

/// Brings the local collection and a sync provider together.
///
/// The collection itself is the outbox: whatever differs from the shadow
/// (the last agreed state) is sent. A run first pushes, then pulls. Fields that
/// conflict are kept locally and in `sync_conflicts` until the user decides,
/// and are not sent again in the meantime.
class SyncEngine {
  SyncEngine(this._db, this._provider)
    : _records = CollectionRecords(_db),
      _ownership = OwnershipService(_db);

  static const _batch = 200;

  final AppDatabase _db;
  final CollectionSyncProvider _provider;
  final CollectionRecords _records;
  final OwnershipService _ownership;

  Future<SyncReport>? _running;

  /// Runs one sync. Calls while a sync runs share its result.
  Future<SyncReport> run() => _running ??= _run().whenComplete(() {
    _running = null;
  });

  Future<SyncReport> _run() async {
    await _ensureScope();
    final pushed = await _push();
    final received = await _pull();
    final now = DateTime.now();
    await _setMeta('lastSyncAt', now.toUtc().toIso8601String());
    final conflicts = await _db.select(_db.syncConflicts).get();
    return SyncReport(
      pushed: pushed,
      received: received,
      conflicts: conflicts.length,
      at: now,
    );
  }

  /// Changes that would be sent now. Used to show what is waiting.
  Future<List<SyncChange>> pendingChanges() async {
    final shadow = await _shadow();
    final blocked = await _blockedFields();
    return _diff(await _records.buildAll(), shadow, blocked);
  }

  Future<int> _push() async {
    final changes = await pendingChanges();
    if (changes.isEmpty) return 0;
    final shadow = await _shadow();
    var applied = 0;
    for (var i = 0; i < changes.length; i += _batch) {
      final batch = changes.sublist(
        i,
        i + _batch > changes.length ? changes.length : i + _batch,
      );
      final results = await _provider.push(batch);
      final byOp = {for (final r in results) r.opId: r};
      await _db.transaction(() async {
        for (final change in batch) {
          final result = byOp[change.opId];
          if (result == null) continue;
          final before = shadow[change.entityId];
          switch (result.outcome) {
            case SyncOutcome.applied || SyncOutcome.unchanged:
              applied++;
              if (change.deleted) {
                await _deleteShadow(change.entityId);
              } else {
                await _writeShadow(
                  change.entityId,
                  change.entityType,
                  result.seq,
                  {...?before?.fields, ...change.fields},
                );
              }
            case SyncOutcome.partial || SyncOutcome.conflict:
              if (result.outcome == SyncOutcome.partial) applied++;
              final server = result.record;
              if (server != null) {
                await _writeShadow(
                  change.entityId,
                  change.entityType,
                  server.seq,
                  server.deleted ? const {} : server.data,
                );
              }
              for (final conflict in result.conflicts) {
                final row = SyncConflictsCompanion.insert(
                  entityType: change.entityType,
                  entityUuid: change.entityId,
                  field: conflict.field,
                  localJson: Value(jsonEncode(conflict.clientValue)),
                  serverJson: Value(jsonEncode(conflict.serverValue)),
                  serverSeq: server?.seq ?? result.seq,
                );
                await _db
                    .into(_db.syncConflicts)
                    .insert(
                      row,
                      onConflict: DoUpdate(
                        (_) => row,
                        target: [
                          _db.syncConflicts.entityUuid,
                          _db.syncConflicts.field,
                        ],
                      ),
                    );
              }
          }
        }
      });
    }
    return applied;
  }

  Future<int> _pull() async {
    var cursor = int.tryParse(await _meta('cursor') ?? '') ?? 0;
    var fullReload = cursor == 0;
    final remote = <String, RemoteRecord>{};
    while (true) {
      final page = await _provider.pull(cursor, limit: _batch);
      if (page.reset) {
        cursor = 0;
        fullReload = true;
        remote.clear();
        continue;
      }
      for (final record in page.changes) {
        remote[record.uuid] = record;
      }
      cursor = page.nextCursor;
      if (!page.hasMore) break;
    }

    final shadow = await _shadow();
    final blocked = await _blockedFields();
    final local = await _records.buildAll();
    final upserts = <SyncRecord>[];
    final deleted = <({String type, String uuid})>[];
    final shadowWrites = <RemoteRecord>[];

    for (final record in remote.values) {
      final blockedHere = blocked[record.uuid] ?? const <String>{};
      if (blockedHere.contains(FieldConflict.deletedField)) continue;
      if (record.deleted) {
        deleted.add((type: record.type, uuid: record.uuid));
        continue;
      }
      final mine = local[record.uuid];
      final base = shadow[record.uuid];
      final merged = <String, Object?>{};
      for (final entry in record.data.entries) {
        final keepMine =
            mine != null &&
            (blockedHere.contains(entry.key) ||
                (base != null &&
                    !sameJson(mine.fields[entry.key], base.fields[entry.key])));
        merged[entry.key] = keepMine ? mine.fields[entry.key] : entry.value;
      }
      shadowWrites.add(record);
      final unchanged =
          mine != null &&
          merged.entries.every((e) => sameJson(mine.fields[e.key], e.value));
      if (!unchanged) upserts.add(SyncRecord(record.type, record.uuid, merged));
    }

    // After a full reload, records the server no longer has were removed
    // elsewhere while this device was away.
    if (fullReload) {
      for (final uuid in shadow.keys) {
        if (!remote.containsKey(uuid) && local.containsKey(uuid)) {
          deleted.add((type: local[uuid]!.type, uuid: uuid));
        }
      }
    }

    await _db.transaction(() async {
      await _records.apply(upserts, deleted, local);
      for (final record in shadowWrites) {
        await _writeShadow(record.uuid, record.type, record.seq, record.data);
      }
      for (final removal in deleted) {
        await _deleteShadow(removal.uuid);
      }
      // Recomputing notifies listeners, which schedule the next sync; only do
      // it when something arrived, or syncs would keep triggering each other.
      if (upserts.isNotEmpty || deleted.isNotEmpty) {
        await _ownership.recompute();
      }
      await _setMeta('cursor', '$cursor');
    });
    return upserts.length + deleted.length;
  }

  /// Settles a conflict. Keeping the local value sends it again on the next
  /// run; keeping the server value writes it into the collection.
  Future<void> resolve(
    SyncConflictRow conflict, {
    required bool keepLocal,
  }) async {
    await _db.transaction(() async {
      await (_db.delete(
        _db.syncConflicts,
      )..where((t) => t.id.equals(conflict.id))).go();
      if (keepLocal) return;

      final local = await _records.buildAll();
      final shadow = (await _shadow())[conflict.entityUuid];
      if (conflict.field == FieldConflict.deletedField) {
        final serverDeleted =
            jsonDecode(conflict.serverJson ?? 'false') == true;
        if (serverDeleted) {
          await _records.apply(const [], [
            (type: conflict.entityType, uuid: conflict.entityUuid),
          ], local);
          await _deleteShadow(conflict.entityUuid);
        } else if (shadow != null) {
          await _records.apply(
            [
              SyncRecord(
                conflict.entityType,
                conflict.entityUuid,
                shadow.fields,
              ),
            ],
            const [],
            local,
          );
        }
      } else {
        final mine = local[conflict.entityUuid];
        if (mine != null) {
          await _records.apply(
            [
              SyncRecord(mine.type, mine.uuid, {
                ...mine.fields,
                conflict.field: jsonDecode(conflict.serverJson ?? 'null'),
              }),
            ],
            const [],
            local,
          );
        }
      }
      await _ownership.recompute();
    });
  }

  /// Forgets everything agreed with the provider, so the next run sends the
  /// whole collection again. Used when the provider changes.
  Future<void> reset() async {
    await _db.transaction(() async {
      await _db.delete(_db.syncShadow).go();
      await _db.delete(_db.syncConflicts).go();
      await (_db.delete(
        _db.syncMeta,
      )..where((t) => t.key.isIn(['cursor', 'scope', 'lastSyncAt']))).go();
    });
  }

  Future<void> _ensureScope() async {
    if (await _meta('scope') == _provider.scope) return;
    await reset();
    await _setMeta('scope', _provider.scope);
  }

  List<SyncChange> _diff(
    Map<String, SyncRecord> local,
    Map<String, _Shadow> shadow,
    Map<String, Set<String>> blocked,
  ) {
    final changes = <SyncChange>[];
    for (final record in local.values) {
      final blockedHere = blocked[record.uuid] ?? const <String>{};
      if (blockedHere.contains(FieldConflict.deletedField)) continue;
      final base = shadow[record.uuid];
      final fields = <String, Object?>{};
      for (final entry in record.fields.entries) {
        if (blockedHere.contains(entry.key)) continue;
        if (base == null || !sameJson(base.fields[entry.key], entry.value)) {
          fields[entry.key] = entry.value;
        }
      }
      if (fields.isEmpty) continue;
      changes.add(_change(record.type, record.uuid, base?.seq ?? 0, fields));
    }
    for (final entry in shadow.entries) {
      if (local.containsKey(entry.key) || entry.value.fields.isEmpty) continue;
      if (blocked[entry.key]?.contains(FieldConflict.deletedField) ?? false) {
        continue;
      }
      changes.add(
        _change(entry.value.type, entry.key, entry.value.seq, const {}, true),
      );
    }
    return changes;
  }

  // The same pending change always gets the same id, so a retry after a lost
  // response is recognised by the server.
  SyncChange _change(
    String type,
    String uuid,
    int baseSeq,
    Map<String, Object?> fields, [
    bool deleted = false,
  ]) {
    final opId = '$uuid:$baseSeq:${_hash('${jsonEncode(fields)}$deleted')}';
    return SyncChange(
      opId: opId,
      entityType: type,
      entityId: uuid,
      baseSeq: baseSeq,
      fields: fields,
      deleted: deleted,
    );
  }

  static String _hash(String text) {
    // FNV-1a, 64 bit.
    var hash = 0xcbf29ce484222325;
    for (final unit in utf8.encode(text)) {
      hash ^= unit;
      hash *= 0x100000001b3;
    }
    return hash.toUnsigned(64).toRadixString(16);
  }

  Future<Map<String, _Shadow>> _shadow() async => {
    for (final row in await _db.select(_db.syncShadow).get())
      row.uuid: _Shadow(
        row.entityType,
        row.baseSeq,
        Map<String, Object?>.from(jsonDecode(row.fieldsJson) as Map),
      ),
  };

  Future<Map<String, Set<String>>> _blockedFields() async {
    final blocked = <String, Set<String>>{};
    for (final row in await _db.select(_db.syncConflicts).get()) {
      blocked.putIfAbsent(row.entityUuid, () => {}).add(row.field);
    }
    return blocked;
  }

  Future<void> _writeShadow(
    String uuid,
    String type,
    int seq,
    Map<String, Object?> fields,
  ) => _db
      .into(_db.syncShadow)
      .insertOnConflictUpdate(
        SyncShadowCompanion.insert(
          uuid: uuid,
          entityType: type,
          baseSeq: seq,
          fieldsJson: jsonEncode(fields),
        ),
      );

  Future<void> _deleteShadow(String uuid) =>
      (_db.delete(_db.syncShadow)..where((t) => t.uuid.equals(uuid))).go();

  Future<String?> _meta(String key) async => (await (_db.select(
    _db.syncMeta,
  )..where((t) => t.key.equals(key))).getSingleOrNull())?.value;

  Future<void> _setMeta(String key, String value) => _db
      .into(_db.syncMeta)
      .insertOnConflictUpdate(SyncMetaCompanion.insert(key: key, value: value));
}

class _Shadow {
  const _Shadow(this.type, this.seq, this.fields);

  final String type;
  final int seq;
  final Map<String, Object?> fields;
}
