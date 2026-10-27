import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../../core/database/media_format.dart';
import '../../../core/providers/core_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../discover/domain/watch_suggestions.dart';
import '../../editions/data/copy_repository.dart';
import '../../movies/application/movie_providers.dart';
import '../../personal/data/personal_state_repository.dart';
import '../../settings/application/settings_providers.dart';
import '../../sync/application/sync_providers.dart';
import '../data/watch_repository.dart';

final watchRepositoryProvider = Provider<WatchRepository>(
  (ref) => WatchRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(tmdbApiClientProvider),
  ),
);

final personalStateRepositoryProvider = Provider<PersonalStateRepository>(
  (ref) => PersonalStateRepository(ref.watch(appDatabaseProvider)),
);

final copyRepositoryProvider = Provider<CopyRepository>(
  (ref) => CopyRepository(ref.watch(appDatabaseProvider)),
);

final regionProvider = Provider<String>(
  (ref) => ref.watch(userPreferencesProvider).region,
);

final subscriptionsProvider = StreamProvider<List<StreamingSubscriptionRow>>(
  (ref) => ref.watch(watchRepositoryProvider).watchSubscriptions(),
);

final subscribedIdsProvider = Provider<Set<int>>(
  (ref) => {
    for (final s in ref.watch(subscriptionsProvider).valueOrNull ?? [])
      s.providerId,
  },
);

/// Bumped after offers were fetched, so lists that read the cache reload.
final offersVersionProvider = StateProvider<int>((ref) => 0);

typedef OffersKey = ({String mediaType, int tmdbId, bool refresh});

final offersProvider = FutureProvider.autoDispose
    .family<CachedOffers, OffersKey>((ref, key) async {
      final offers = await ref
          .watch(watchRepositoryProvider)
          .offers(
            key.mediaType,
            key.tmdbId,
            ref.watch(regionProvider),
            refresh: key.refresh,
          );
      return offers;
    });

final personalStateProvider = StreamProvider.autoDispose
    .family<PersonalStateRow?, Subject>(
      (ref, subject) =>
          ref.watch(personalStateRepositoryProvider).watch(subject),
    );

final movieEditionsProvider = StreamProvider.autoDispose
    .family<List<EditionWithCopies>, int>(
      (ref, movieId) =>
          ref.watch(copyRepositoryProvider).watchForMovie(movieId),
    );

/// Formats of the copies the user owns, per local movie id.
final ownedFormatsProvider = StreamProvider<Map<int, List<MediaFormat>>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return db
      .customSelect(
        'SELECT DISTINCT em.movie_id AS movie, e.format AS format '
        'FROM owned_copies c '
        'JOIN physical_editions e ON e.id = c.edition_id '
        'JOIN physical_edition_movies em ON em.edition_id = e.id',
        readsFrom: {
          db.ownedCopies,
          db.physicalEditions,
          db.physicalEditionMovies,
        },
      )
      .watch()
      .map((rows) {
        final result = <int, List<MediaFormat>>{};
        for (final r in rows) {
          result
              .putIfAbsent(r.read<int>('movie'), () => [])
              .add(MediaFormat.fromName(r.read<String>('format')));
        }
        return result;
      });
});

final _movieStatesProvider = StreamProvider<Map<int, PersonalStateRow>>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return (db.select(db.personalStates)..where((t) => t.movieId.isNotNull()))
      .watch()
      .map((rows) => {for (final r in rows) r.movieId!: r});
});

/// Every film that could be watched: the collection plus films that are
/// only on the home server, with cached offers and personal state.
final watchCandidatesProvider = FutureProvider<List<WatchCandidate>>((
  ref,
) async {
  ref.watch(offersVersionProvider);
  final movies = await ref.watch(allMoviesProvider.future);
  final formats = await ref.watch(ownedFormatsProvider.future);
  final states = await ref.watch(_movieStatesProvider.future);
  final server = ref.watch(serverMoviesProvider).valueOrNull ?? const [];
  final offers = await ref
      .watch(watchRepositoryProvider)
      .allCached(ref.watch(regionProvider));

  final serverByTmdb = {
    for (final t in server)
      if (t.tmdbId != null) t.tmdbId!: t,
  };
  final candidates = <WatchCandidate>[];
  final seen = <int>{};
  for (final m in movies) {
    final state = states[m.id];
    final onServer = m.tmdbId != null ? serverByTmdb[m.tmdbId] : null;
    if (m.tmdbId != null) seen.add(m.tmdbId!);
    candidates.add(
      WatchCandidate(
        title: m.title,
        tmdbId: m.tmdbId,
        movieId: m.id,
        serverTitleId: onServer?.id,
        posterPath: m.posterPath,
        year: m.releaseYear,
        runtime: m.runtime,
        genres: m.genres,
        originalLanguage: m.originalLanguage,
        onServer: onServer != null,
        ownedFormats: formats[m.id] ?? const [],
        offers: m.tmdbId == null
            ? const []
            : offers['movie:${m.tmdbId}'] ?? const [],
        watched:
            state?.watchStatus == 'watched' || (onServer?.watched ?? false),
        watchCount: state?.watchCount ?? 0,
        rating: state?.rating,
        onWishlist: m.status == CollectionStatus.wishlist,
      ),
    );
  }
  for (final t in server) {
    if (t.tmdbId != null && seen.contains(t.tmdbId)) continue;
    candidates.add(
      WatchCandidate(
        title: t.name,
        tmdbId: t.tmdbId,
        serverTitleId: t.id,
        year: t.year,
        runtime: t.runtimeMinutes,
        genres: t.genres,
        onServer: true,
        watched: t.watched,
      ),
    );
  }
  return candidates;
});

final collectionInsightsProvider = Provider<AsyncValue<CollectionInsights>>((
  ref,
) {
  final subscriptions = ref.watch(subscribedIdsProvider);
  return ref
      .watch(watchCandidatesProvider)
      .whenData((c) => collectionInsights(c, subscriptions: subscriptions));
});

/// Looks up offers for collection films whose cache is missing or stale.
/// Sequential and limited, to stay well within TMDB's rate limits.
class OfferRefresher {
  OfferRefresher(this._ref);

  final Ref _ref;
  bool _running = false;

  Future<int> refresh({bool wishlistOnly = false, int limit = 40}) async {
    if (_running) return 0;
    _running = true;
    var fetched = 0;
    try {
      final repository = _ref.read(watchRepositoryProvider);
      final region = _ref.read(regionProvider);
      final movies = await _ref.read(allMoviesProvider.future);
      for (final m in movies) {
        if (fetched >= limit) break;
        if (m.tmdbId == null) continue;
        if (wishlistOnly && m.status != CollectionStatus.wishlist) continue;
        if (!await repository.isStale('movie', m.tmdbId!, region)) continue;
        await repository.offers('movie', m.tmdbId!, region);
        fetched++;
        await Future<void>.delayed(const Duration(milliseconds: 150));
      }
    } finally {
      _running = false;
      if (fetched > 0) _ref.read(offersVersionProvider.notifier).state++;
    }
    return fetched;
  }
}

final offerRefresherProvider = Provider<OfferRefresher>(OfferRefresher.new);

/// Keeps wishlist offers fresh in the background while Home is open, so
/// "now in your subscription" can appear. Only when subscriptions are set.
final wishlistOfferWatcherProvider = Provider.autoDispose<void>((ref) {
  if (ref.watch(subscribedIdsProvider).isEmpty) return;
  unawaited(
    ref.read(offerRefresherProvider).refresh(wishlistOnly: true, limit: 20),
  );
});
