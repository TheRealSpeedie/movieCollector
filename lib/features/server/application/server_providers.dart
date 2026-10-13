import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/credential_store.dart';
import '../data/library_repository.dart';
import '../data/pairing_service.dart';
import '../data/server_client.dart';
import '../data/server_credentials.dart';
import '../data/server_discovery.dart';
import '../domain/server_models.dart';

final credentialStoreProvider = Provider<CredentialStore>(
  (ref) => SecureCredentialStore(),
);

final serverDiscoveryProvider = Provider<ServerDiscovery>(
  (ref) => MdnsServerDiscovery(),
);

final pairingServiceProvider = Provider<PairingService>(
  (ref) => PairingService(dio: buildServerDio()),
);

final serverRevokedProvider = StateProvider<bool>((ref) => false);

class ServerSession extends AsyncNotifier<ServerCredentials?> {
  @override
  Future<ServerCredentials?> build() =>
      ref.read(credentialStoreProvider).load();

  Future<void> connect(ServerCredentials credentials) async {
    await ref.read(credentialStoreProvider).save(credentials);
    ref.read(serverRevokedProvider.notifier).state = false;
    state = AsyncData(credentials);
  }

  Future<void> disconnect() async {
    final credentials = state.valueOrNull;
    if (credentials != null) {
      final client = ServerClient(
        credentials: credentials,
        store: ref.read(credentialStoreProvider),
        discovery: ref.read(serverDiscoveryProvider),
        onRevoked: () {},
      );
      await client
          .delete('/api/devices/${credentials.deviceId}')
          .catchError((_) => null);
    }
    await ref.read(credentialStoreProvider).clear();
    state = const AsyncData(null);
  }

  void revoked() {
    ref.read(serverRevokedProvider.notifier).state = true;
    state = const AsyncData(null);
  }
}

final serverSessionProvider =
    AsyncNotifierProvider<ServerSession, ServerCredentials?>(ServerSession.new);

final serverClientProvider = Provider<ServerClient?>((ref) {
  final credentials = ref.watch(serverSessionProvider).valueOrNull;
  if (credentials == null) return null;
  return ServerClient(
    credentials: credentials,
    store: ref.watch(credentialStoreProvider),
    discovery: ref.watch(serverDiscoveryProvider),
    onRevoked: () => ref.read(serverSessionProvider.notifier).revoked(),
  );
});

final libraryRepositoryProvider = Provider<LibraryRepository?>((ref) {
  final client = ref.watch(serverClientProvider);
  return client == null ? null : LibraryRepository(client);
});

final serverHomeProvider = FutureProvider.autoDispose<HomeData>(
  (ref) => ref.watch(libraryRepositoryProvider)!.home(),
);

final serverTitleProvider = FutureProvider.autoDispose.family<TitleDetail, int>(
  (ref, id) => ref.watch(libraryRepositoryProvider)!.title(id),
);

final serverEpisodesProvider = FutureProvider.autoDispose
    .family<List<ServerEpisode>, int>(
      (ref, id) => ref.watch(libraryRepositoryProvider)!.episodes(id),
    );
