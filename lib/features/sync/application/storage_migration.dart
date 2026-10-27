import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/sync/collection_records.dart';
import '../../../core/sync/sync_engine.dart';
import '../../../core/sync/sync_provider.dart';
import '../../backup/application/backup_providers.dart';
import '../../backup/data/backup_service.dart';
import '../../settings/application/settings_providers.dart';
import '../../settings/data/settings_repository.dart';
import 'sync_providers.dart';

class MigrationException implements Exception {
  const MigrationException(this.message);

  final String message;

  @override
  String toString() => message;
}

class MigrationPreview {
  const MigrationPreview({required this.local, this.remote});

  final RecordCounts local;

  /// What the destination already holds, for example from another device.
  final RecordCounts? remote;
}

/// Moves the collection between storage providers.
///
/// Every move follows the same steps: save a snapshot, show what moves, check
/// the destination, transfer, verify the counts, and only then switch. The
/// collection on this device is never deleted, so a failed move just leaves
/// the old provider active.
class StorageMigration {
  StorageMigration(this._ref);

  final Ref _ref;

  BackupService get _backup => _ref.read(backupServiceProvider);

  Future<MigrationPreview> preview(CollectionStorage target) async {
    final local = await _backup.currentCounts();
    final destination = _provider(target);
    if (destination == null) return MigrationPreview(local: local);
    try {
      return MigrationPreview(
        local: local,
        remote: (await destination.snapshot()).counts,
      );
    } catch (e) {
      throw MigrationException('Das Ziel ist nicht erreichbar: $e');
    }
  }

  Future<void> migrate(CollectionStorage target) async {
    final storage = _ref.read(collectionStorageProvider.notifier);
    final current = _ref.read(collectionStorageProvider);
    if (current == target) return;
    if (target == CollectionStorage.cloud) {
      throw const MigrationException(
        'Movie Shelf Cloud ist noch nicht verfügbar.',
      );
    }

    await _backup.saveSnapshot('vor-umzug-${target.name}');

    if (target == CollectionStorage.local) {
      // The collection is already complete on this device; stop syncing and
      // forget the shared state so a later move starts cleanly.
      final engine = _ref.read(syncEngineProvider);
      await storage.set(CollectionStorage.local);
      await engine?.reset();
      return;
    }

    final destination = _provider(target);
    if (destination == null) {
      throw const MigrationException(
        'Verbinde zuerst einen Movie Shelf Server.',
      );
    }
    final engine = SyncEngine(_ref.read(appDatabaseProvider), destination);
    await engine.reset();
    try {
      await destination.snapshot();
      await engine.run();
      await _verify(destination);
    } catch (e) {
      await engine.reset();
      if (e is MigrationException) rethrow;
      throw MigrationException(
        'Der Umzug wurde abgebrochen, deine Sammlung bleibt auf dem Gerät: $e',
      );
    }
    await storage.set(target);
  }

  /// Every local record must exist at the destination. The destination may
  /// hold more, from other devices.
  Future<void> _verify(CollectionSyncProvider destination) async {
    final local = await _backup.currentCounts();
    final remote = (await destination.snapshot()).counts;
    for (final type in SyncEntityType.applyOrder) {
      final mine = local[type] ?? 0;
      final theirs = remote[type] ?? 0;
      if (theirs < mine) {
        throw MigrationException(
          'Nicht alle Einträge kamen an ($type: $theirs von $mine). '
          'Deine Sammlung bleibt auf dem Gerät.',
        );
      }
    }
  }

  CollectionSyncProvider? _provider(CollectionStorage target) =>
      switch (target) {
        CollectionStorage.selfHosted => _ref.read(selfHostedSyncProvider),
        _ => null,
      };
}

final storageMigrationProvider = Provider<StorageMigration>(
  StorageMigration.new,
);
