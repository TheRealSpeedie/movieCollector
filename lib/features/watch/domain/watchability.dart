import '../../../core/network/tmdb/tmdb_watch_models.dart';

/// Ways to watch a title, best first.
enum WatchOption {
  /// A playable file on the home server.
  playNow,

  /// Included in a subscription the user has.
  subscription,

  /// Free, possibly with ads.
  free,

  /// A disc the user owns. Needs a player; it is not a digital copy.
  shelf,

  /// Costs extra: rent or buy, or a subscription the user does not have.
  rentOrBuy,

  /// No known way.
  unavailable,
}

class WatchSource {
  const WatchSource({
    required this.option,
    required this.title,
    this.detail,
    this.logoPath,
  });

  final WatchOption option;
  final String title;
  final String? detail;
  final String? logoPath;
}

/// Answers "where can I watch this with what I already have?". Physical
/// ownership never counts as a streaming source.
List<WatchSource> watchSources({
  required bool onServer,
  required List<String> ownedFormats,
  required List<TmdbWatchOffer> offers,
  required Set<int> subscriptions,
}) {
  final sources = <WatchSource>[];
  if (onServer) {
    sources.add(
      const WatchSource(
        option: WatchOption.playNow,
        title: 'Jetzt abspielen',
        detail: 'Auf deinem Movie Shelf Server',
      ),
    );
  }

  final included = offers.where(
    (o) => o.type == OfferType.flatrate && subscriptions.contains(o.providerId),
  );
  for (final offer in _byProvider(included)) {
    sources.add(
      WatchSource(
        option: WatchOption.subscription,
        title: offer.providerName,
        detail: 'In deinem Abo',
        logoPath: offer.logoPath,
      ),
    );
  }
  for (final offer in _byProvider(
    offers.where((o) => o.type == OfferType.free || o.type == OfferType.ads),
  )) {
    sources.add(
      WatchSource(
        option: WatchOption.free,
        title: offer.providerName,
        detail: offer.type.label,
        logoPath: offer.logoPath,
      ),
    );
  }

  if (ownedFormats.isNotEmpty) {
    sources.add(
      WatchSource(
        option: WatchOption.shelf,
        title: 'In deinem Regal',
        detail: '${ownedFormats.join(', ')} · Abspielgerät nötig',
      ),
    );
  }

  final paid = <int, List<OfferType>>{};
  final names = <int, TmdbWatchOffer>{};
  for (final offer in offers) {
    final extra =
        offer.type == OfferType.rent ||
        offer.type == OfferType.buy ||
        (offer.type == OfferType.flatrate &&
            !subscriptions.contains(offer.providerId));
    if (!extra) continue;
    paid.putIfAbsent(offer.providerId, () => []).add(offer.type);
    names[offer.providerId] = offer;
  }
  for (final entry in paid.entries) {
    final offer = names[entry.key]!;
    sources.add(
      WatchSource(
        option: WatchOption.rentOrBuy,
        title: offer.providerName,
        detail: entry.value
            .map((t) => t == OfferType.flatrate ? 'Abo nötig' : t.label)
            .toSet()
            .join(' · '),
        logoPath: offer.logoPath,
      ),
    );
  }

  if (sources.isEmpty) {
    sources.add(
      const WatchSource(
        option: WatchOption.unavailable,
        title: 'Keine bekannte Möglichkeit',
        detail: 'Weder im Regal, auf dem Server noch bei einem Anbieter.',
      ),
    );
  }
  return sources;
}

Iterable<TmdbWatchOffer> _byProvider(Iterable<TmdbWatchOffer> offers) {
  final seen = <int>{};
  return offers.where((o) => seen.add(o.providerId));
}
