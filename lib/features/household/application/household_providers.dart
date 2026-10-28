import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../backup/application/backup_providers.dart';
import '../../cloud/application/cloud_providers.dart';
import '../../server/application/server_providers.dart';
import '../../settings/application/settings_providers.dart';
import '../../settings/data/settings_repository.dart';
import '../../sync/application/sync_providers.dart';
import '../data/household_api.dart';

/// Households need a place that shares the collection: the own server or
/// Movie Shelf Cloud, whichever the collection syncs with.
final householdApiProvider = Provider<HouseholdApi?>((ref) {
  switch (ref.watch(collectionStorageProvider)) {
    case CollectionStorage.selfHosted:
      final server = ref.watch(serverClientProvider);
      if (server == null) return null;
      return HouseholdApi(
        get: server.get,
        post: (path, body) => server.post(path, body: body),
        delete: server.delete,
      );
    case CollectionStorage.cloud:
      final cloud = ref.watch(cloudClientProvider);
      if (cloud?.session == null) return null;
      return HouseholdApi(
        get: cloud!.get,
        post: (path, body) => cloud.post(path, body: body),
        delete: cloud.delete,
      );
    case CollectionStorage.local:
      return null;
  }
});

final householdProvider = FutureProvider.autoDispose<Household?>(
  (ref) async => ref.watch(householdApiProvider)?.load(),
);

/// Joins, leaves or ends a household, then lets this device start over with
/// the collection it now belongs to. A snapshot is saved first, as before any
/// move; nothing on the device is deleted.
Future<void> changeHousehold(
  WidgetRef ref,
  String reason,
  Future<void> Function(HouseholdApi api) change,
) async {
  final api = ref.read(householdApiProvider);
  if (api == null) return;
  await ref.read(backupServiceProvider).saveSnapshot(reason);
  await change(api);
  await ref.read(syncEngineProvider)?.reset();
  ref.invalidate(householdProvider);
  await ref.read(syncControllerProvider.notifier).refresh();
}
