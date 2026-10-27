/// How a streaming service offers a title.
enum OfferType {
  flatrate,
  free,
  ads,
  rent,
  buy;

  /// Included in a subscription or free: no extra cost.
  bool get noExtraCost => this != rent && this != buy;

  String get label => switch (this) {
    OfferType.flatrate => 'Im Abo',
    OfferType.free => 'Kostenlos',
    OfferType.ads => 'Kostenlos mit Werbung',
    OfferType.rent => 'Leihen',
    OfferType.buy => 'Kaufen',
  };
}

class TmdbWatchOffer {
  const TmdbWatchOffer({
    required this.providerId,
    required this.providerName,
    required this.type,
    this.logoPath,
  });

  final int providerId;
  final String providerName;
  final String? logoPath;
  final OfferType type;
}

class TmdbWatchProviders {
  const TmdbWatchProviders({required this.offers, this.link});

  /// Parses one region of `/{movie|tv}/{id}/watch/providers`.
  factory TmdbWatchProviders.fromJson(Map<String, dynamic>? region) {
    if (region == null) return const TmdbWatchProviders(offers: []);
    final offers = <TmdbWatchOffer>[];
    for (final type in OfferType.values) {
      for (final entry in region[type.name] as List<dynamic>? ?? const []) {
        if (entry is! Map<String, dynamic>) continue;
        final id = entry['provider_id'];
        if (id is! int) continue;
        offers.add(
          TmdbWatchOffer(
            providerId: id,
            providerName: entry['provider_name'] as String? ?? 'Anbieter $id',
            logoPath: entry['logo_path'] as String?,
            type: type,
          ),
        );
      }
    }
    return TmdbWatchProviders(offers: offers, link: region['link'] as String?);
  }

  final List<TmdbWatchOffer> offers;

  /// TMDB page with all offers. TMDB has no links to single providers.
  final String? link;
}

class TmdbProvider {
  const TmdbProvider({
    required this.id,
    required this.name,
    this.logoPath,
    this.priority = 999,
  });

  final int id;
  final String name;
  final String? logoPath;
  final int priority;
}
