import 'dart:async';

import 'package:drift/drift.dart' show TableUpdateQuery;
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/sync/sync_engine.dart';
import '../../../core/sync/sync_provider.dart';
import '../../cloud/application/cloud_providers.dart';
import '../../server/application/server_providers.dart';
import '../../server/data/library_repository.dart';
import '../../server/domain/server_models.dart';
import '../../settings/application/settings_providers.dart';
import '../../settings/data/settings_repository.dart';
import '../data/self_hosted_sync_provider.dart';

/// The home server as a sync target, whether or not it is the active one.
final selfHostedSyncProvider = Provider<CollectionSyncProvider?>((ref) {
  final client = ref.watch(serverClientProvider);
  return client == null ? null : SelfHostedSyncProvider(client);
});

/// The provider the collection syncs with now. Local only has none.
final activeSyncProvider = Provider<CollectionSyncProvider?>((ref) {
  return switch (ref.watch(collectionStorageProvider)) {
    CollectionStorage.selfHosted => ref.watch(selfHostedSyncProvider),
    CollectionStorage.cloud => ref.watch(cloudSyncProvider),
    CollectionStorage.local => null,
  };
});

final syncEngineProvider = Provider<SyncEngine?>((ref) {
  final provider = ref.watch(activeSyncProvider);
  if (provider == null) return null;
  return SyncEngine(ref.watch(appDatabaseProvider), provider);
});

class SyncController extends AsyncNotifier<SyncReport?> {
  @override
  Future<SyncReport?> build() async {
    final engine = ref.watch(syncEngineProvider);
    if (engine == null) return null;
    return engine.run();
  }

  Future<void> refresh() async {
    final engine = ref.read(syncEngineProvider);
    if (engine == null) return;
    state = const AsyncLoading<SyncReport?>().copyWithPrevious(state);
    state = await AsyncValue.guard(engine.run);
  }

  Future<void> resolve(
    SyncConflictRow conflict, {
    required bool keepLocal,
  }) async {
    final engine = ref.read(syncEngineProvider);
    if (engine == null) return;
    await engine.resolve(conflict, keepLocal: keepLocal);
    await refresh();
  }
}

final syncControllerProvider =
    AsyncNotifierProvider<SyncController, SyncReport?>(SyncController.new);

final syncConflictsProvider = StreamProvider<List<SyncConflictRow>>(
  (ref) => ref
      .watch(appDatabaseProvider)
      .select(ref.watch(appDatabaseProvider).syncConflicts)
      .watch(),
);

/// Starts a sync shortly after the collection changes and when the app
/// returns to the foreground. Watched once by the app.
final syncSchedulerProvider = Provider<void>((ref) {
  final engine = ref.watch(syncEngineProvider);
  if (engine == null) return;
  final db = ref.watch(appDatabaseProvider);
  Timer? debounce;
  void schedule([Duration delay = const Duration(seconds: 5)]) {
    debounce?.cancel();
    debounce = Timer(delay, () {
      ref.read(syncControllerProvider.notifier).refresh();
    });
  }

  final subscription = db
      .tableUpdates(
        TableUpdateQuery.onAllTables([
          db.movies,
          db.tvSeriesTable,
          db.tvSeasonsTable,
          db.physicalEditions,
          db.physicalEditionMovies,
          db.physicalEditionTvSeasons,
          db.ownedCopies,
          db.barcodes,
          db.personalStates,
        ]),
      )
      .listen((_) => schedule());
  final lifecycle = AppLifecycleListener(
    onResume: () => schedule(const Duration(seconds: 1)),
  );
  ref.onDispose(() {
    debounce?.cancel();
    subscription.cancel();
    lifecycle.dispose();
  });
});

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
