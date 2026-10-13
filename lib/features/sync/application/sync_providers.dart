import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/core_providers.dart';
import '../../../core/providers/repository_providers.dart';
import '../../server/application/server_providers.dart';
import '../../server/data/library_repository.dart';
import '../../server/domain/server_models.dart';
import '../data/collection_sync_repository.dart';

final collectionSyncRepositoryProvider = Provider<CollectionSyncRepository?>((
  ref,
) {
  final client = ref.watch(serverClientProvider);
  if (client == null) return null;
  return CollectionSyncRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(barcodeRepositoryProvider),
    client,
    '${client.credentials.serverId}/${client.credentials.username}',
  );
});

class SyncController extends AsyncNotifier<SyncReport?> {
  @override
  Future<SyncReport?> build() {
    ref.watch(collectionSyncRepositoryProvider);
    return _run();
  }

  Future<SyncReport?> _run() =>
      ref.read(collectionSyncRepositoryProvider)?.sync() ?? Future.value();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_run);
  }

  Future<void> keepLocal(int tmdbId) async {
    await ref.read(collectionSyncRepositoryProvider)!.keepLocal(tmdbId);
    await refresh();
  }

  Future<void> keepServer(int tmdbId) async {
    await ref.read(collectionSyncRepositoryProvider)!.keepServer(tmdbId);
    await refresh();
  }
}

final syncControllerProvider =
    AsyncNotifierProvider<SyncController, SyncReport?>(SyncController.new);

final serverMoviesProvider = FutureProvider.autoDispose<List<ServerTitle>>((
  ref,
) async {
  final library = ref.watch(libraryRepositoryProvider);
  if (library == null) return [];
  final titles = <ServerTitle>[];
  while (true) {
    final page = await library.titles(
      const TitleQuery(kind: 'Movie'),
      offset: titles.length,
      limit: 200,
    );
    titles.addAll(page.items);
    if (page.items.isEmpty || titles.length >= page.total) return titles;
  }
});

final serverMovieByTmdbIdProvider = Provider.autoDispose
    .family<ServerTitle?, int>(
      (ref, tmdbId) => ref
          .watch(serverMoviesProvider)
          .valueOrNull
          ?.where((t) => t.tmdbId == tmdbId)
          .firstOrNull,
    );

final serverTmdbIdsProvider = Provider.autoDispose<Set<int>>(
  (ref) => {
    for (final title in ref.watch(serverMoviesProvider).valueOrNull ?? [])
      if (title.tmdbId != null) title.tmdbId!,
  },
);
