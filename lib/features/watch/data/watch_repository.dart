import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../../../core/network/tmdb/tmdb_api_client.dart';
import '../../../core/network/tmdb/tmdb_watch_models.dart';

class CachedOffers {
  const CachedOffers({required this.offers, this.checkedAt, this.link});

  final List<TmdbWatchOffer> offers;

  /// When the offers were last fetched; null if never.
  final DateTime? checkedAt;
  final String? link;
}

/// Streaming offers (cached per title and region) and the user's
/// subscriptions. Offers are never treated as ownership.
class WatchRepository {
  WatchRepository(this._db, this._tmdb, {DateTime Function()? now})
    : _now = now ?? DateTime.now;

  static const cacheFor = Duration(days: 7);

  final AppDatabase _db;
  final TmdbApiClient _tmdb;
  final DateTime Function() _now;

  /// Cached offers, refreshed from TMDB when older than [cacheFor] or when
  /// [refresh] is set. Without a connection the cache is returned as is.
  Future<CachedOffers> offers(
    String mediaType,
    int tmdbId,
    String region, {
    bool refresh = false,
  }) async {
    final cached = await cachedOffers(mediaType, tmdbId, region);
    final fresh =
        cached.checkedAt != null &&
        _now().difference(cached.checkedAt!) < cacheFor;
    if (fresh && !refresh) return cached;
    try {
      final result = await _tmdb.getWatchProviders(mediaType, tmdbId, region);
      await _store(mediaType, tmdbId, region, result);
      return CachedOffers(
        offers: result.offers,
        checkedAt: _now(),
        link: result.link,
      );
    } catch (_) {
      return cached;
    }
  }

  Future<CachedOffers> cachedOffers(
    String mediaType,
    int tmdbId,
    String region,
  ) async {
    final check =
        await (_db.select(_db.streamingChecks)..where(
              (t) =>
                  t.mediaType.equals(mediaType) &
                  t.tmdbId.equals(tmdbId) &
                  t.region.equals(region),
            ))
            .getSingleOrNull();
    final rows =
        await (_db.select(_db.streamingOffers)..where(
              (t) =>
                  t.mediaType.equals(mediaType) &
                  t.tmdbId.equals(tmdbId) &
                  t.region.equals(region),
            ))
            .get();
    return CachedOffers(
      offers: [
        for (final r in rows)
          TmdbWatchOffer(
            providerId: r.providerId,
            providerName: r.providerName,
            logoPath: r.logoPath,
            type: OfferType.values.byName(r.offerType),
          ),
      ],
      checkedAt: check?.checkedAt,
      link: rows.firstOrNull?.link,
    );
  }

  /// Offers of every cached title in [region], keyed by "movie:603".
  Future<Map<String, List<TmdbWatchOffer>>> allCached(String region) async {
    final rows = await (_db.select(
      _db.streamingOffers,
    )..where((t) => t.region.equals(region))).get();
    final result = <String, List<TmdbWatchOffer>>{};
    for (final r in rows) {
      result
          .putIfAbsent('${r.mediaType}:${r.tmdbId}', () => [])
          .add(
            TmdbWatchOffer(
              providerId: r.providerId,
              providerName: r.providerName,
              logoPath: r.logoPath,
              type: OfferType.values.byName(r.offerType),
            ),
          );
    }
    return result;
  }

  /// Titles whose offers in [region] were never fetched or are stale.
  Future<bool> isStale(String mediaType, int tmdbId, String region) async {
    final check =
        await (_db.select(_db.streamingChecks)..where(
              (t) =>
                  t.mediaType.equals(mediaType) &
                  t.tmdbId.equals(tmdbId) &
                  t.region.equals(region),
            ))
            .getSingleOrNull();
    return check == null || _now().difference(check.checkedAt) >= cacheFor;
  }

  Future<void> _store(
    String mediaType,
    int tmdbId,
    String region,
    TmdbWatchProviders result,
  ) async {
    final now = _now();
    await _db.transaction(() async {
      await (_db.delete(_db.streamingOffers)..where(
            (t) =>
                t.mediaType.equals(mediaType) &
                t.tmdbId.equals(tmdbId) &
                t.region.equals(region),
          ))
          .go();
      for (final offer in result.offers) {
        await _db
            .into(_db.streamingOffers)
            .insertOnConflictUpdate(
              StreamingOffersCompanion.insert(
                mediaType: mediaType,
                tmdbId: tmdbId,
                region: region,
                providerId: offer.providerId,
                providerName: offer.providerName,
                logoPath: Value(offer.logoPath),
                offerType: offer.type.name,
                link: Value(result.link),
                checkedAt: now,
              ),
            );
      }
      await _db
          .into(_db.streamingChecks)
          .insertOnConflictUpdate(
            StreamingChecksCompanion.insert(
              mediaType: mediaType,
              tmdbId: tmdbId,
              region: region,
              checkedAt: now,
            ),
          );
    });
  }

  Stream<List<StreamingSubscriptionRow>> watchSubscriptions() => (_db.select(
    _db.streamingSubscriptions,
  )..orderBy([(t) => OrderingTerm.asc(t.providerName)])).watch();

  Future<void> setSubscribed(TmdbProvider provider, bool subscribed) async {
    if (subscribed) {
      await _db
          .into(_db.streamingSubscriptions)
          .insertOnConflictUpdate(
            StreamingSubscriptionsCompanion.insert(
              providerId: Value(provider.id),
              providerName: provider.name,
              logoPath: Value(provider.logoPath),
            ),
          );
    } else {
      await (_db.delete(
        _db.streamingSubscriptions,
      )..where((t) => t.providerId.equals(provider.id))).go();
    }
  }

  Future<List<TmdbProvider>> providers(String region) =>
      _tmdb.getProviders(region);
}
