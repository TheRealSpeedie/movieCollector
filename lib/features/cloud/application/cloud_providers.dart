import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/config/env.dart';
import '../../../core/sync/sync_provider.dart';
import '../data/cloud_client.dart';
import '../data/cloud_sync_provider.dart';

/// Whether this build knows a Movie Shelf Cloud address (CLOUD_URL).
final cloudAvailableProvider = Provider<bool>((ref) => Env.isCloudConfigured);

final cloudSessionStoreProvider = Provider<CloudSessionStore>(
  (ref) => SecureCloudSessionStore(),
);

class CloudAccount extends AsyncNotifier<CloudSession?> {
  @override
  Future<CloudSession?> build() => ref.read(cloudSessionStoreProvider).load();

  void signedIn(CloudSession session) => state = AsyncData(session);

  void signedOut() => state = const AsyncData(null);
}

final cloudAccountProvider = AsyncNotifierProvider<CloudAccount, CloudSession?>(
  CloudAccount.new,
);

/// A client for signing in, also without an account yet.
final cloudClientProvider = Provider<CloudClient?>((ref) {
  if (!ref.watch(cloudAvailableProvider)) return null;
  final session = ref.watch(cloudAccountProvider).valueOrNull;
  return CloudClient(
    baseUrl: Env.cloudUrl,
    store: ref.watch(cloudSessionStoreProvider),
    session: session,
    onSignedOut: () => ref.read(cloudAccountProvider.notifier).signedOut(),
  );
});

/// The cloud as a sync target; only with a signed-in account.
final cloudSyncProvider = Provider<CollectionSyncProvider?>((ref) {
  final client = ref.watch(cloudClientProvider);
  if (client == null || client.session == null) return null;
  return CloudSyncProvider(client);
});
