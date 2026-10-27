import '../../../core/database/media_format.dart';
import '../../../core/network/tmdb/tmdb_watch_models.dart';

/// Where a suggestion can be watched without paying extra.
enum SuggestionSource {
  server,
  subscription,
  shelf;

  String get label => switch (this) {
    SuggestionSource.server => 'Server',
    SuggestionSource.subscription => 'Abo & kostenlos',
    SuggestionSource.shelf => 'Regal',
  };
}

/// Everything known about one title that could be suggested.
class WatchCandidate {
  const WatchCandidate({
    required this.title,
    this.tmdbId,
    this.movieId,
    this.serverTitleId,
    this.posterPath,
    this.posterUrl,
    this.year,
    this.runtime,
    this.genres = const [],
    this.originalLanguage,
    this.onServer = false,
    this.ownedFormats = const [],
    this.offers = const [],
    this.watched = false,
    this.watchCount = 0,
    this.rating,
    this.onWishlist = false,
  });

  final String title;
  final int? tmdbId;

  /// Local movie id, when the film is in the collection.
  final int? movieId;

  /// Home server title id, when a file exists there.
  final int? serverTitleId;
  final String? posterPath;
  final String? posterUrl;
  final int? year;
  final int? runtime;
  final List<String> genres;
  final String? originalLanguage;
  final bool onServer;
  final List<MediaFormat> ownedFormats;
  final List<TmdbWatchOffer> offers;
  final bool watched;
  final int watchCount;
  final int? rating;
  final bool onWishlist;
}

class SuggestionFilter {
  const SuggestionFilter({
    this.genre,
    this.maxRuntime,
    this.sources = const {
      SuggestionSource.server,
      SuggestionSource.subscription,
      SuggestionSource.shelf,
    },
    this.unwatchedOnly = true,
    this.language,
  });

  final String? genre;
  final int? maxRuntime;
  final Set<SuggestionSource> sources;
  final bool unwatchedOnly;

  /// ISO 639-1 code; only titles originally in this language.
  final String? language;

  SuggestionFilter copyWith({
    String? genre,
    bool clearGenre = false,
    int? maxRuntime,
    bool clearRuntime = false,
    Set<SuggestionSource>? sources,
    bool? unwatchedOnly,
    String? language,
    bool clearLanguage = false,
  }) => SuggestionFilter(
    genre: clearGenre ? null : genre ?? this.genre,
    maxRuntime: clearRuntime ? null : maxRuntime ?? this.maxRuntime,
    sources: sources ?? this.sources,
    unwatchedOnly: unwatchedOnly ?? this.unwatchedOnly,
    language: clearLanguage ? null : language ?? this.language,
  );
}

class Suggestion {
  const Suggestion({
    required this.candidate,
    required this.sources,
    required this.reasons,
  });

  final WatchCandidate candidate;
  final List<SuggestionSource> sources;

  /// Why the title is suggested, most important first.
  final List<String> reasons;
}

const languageNames = {
  'de': 'Deutsch',
  'en': 'Englisch',
  'fr': 'Französisch',
  'es': 'Spanisch',
  'it': 'Italienisch',
  'ja': 'Japanisch',
  'ko': 'Koreanisch',
};

/// Rules, no AI: keep what matches the filter and can be watched without
/// extra cost, explain each choice, unwatched and closest sources first.
List<Suggestion> suggest(
  List<WatchCandidate> candidates,
  SuggestionFilter filter, {
  required Set<int> subscriptions,
  String? preferredLanguage,
}) {
  final result = <Suggestion>[];
  for (final c in candidates) {
    if (filter.unwatchedOnly && c.watched) continue;
    if (filter.genre != null &&
        !c.genres.any((g) => g.toLowerCase() == filter.genre!.toLowerCase())) {
      continue;
    }
    if (filter.maxRuntime != null &&
        (c.runtime == null || c.runtime! > filter.maxRuntime!)) {
      continue;
    }
    if (filter.language != null && c.originalLanguage != filter.language) {
      continue;
    }

    final included = [
      for (final o in c.offers)
        if ((o.type == OfferType.flatrate &&
                subscriptions.contains(o.providerId)) ||
            o.type == OfferType.free ||
            o.type == OfferType.ads)
          o,
    ];
    final sources = [
      if (c.onServer) SuggestionSource.server,
      if (included.isNotEmpty) SuggestionSource.subscription,
      if (c.ownedFormats.isNotEmpty) SuggestionSource.shelf,
    ].where(filter.sources.contains).toList();
    if (sources.isEmpty) continue;

    final reasons = <String>[
      for (final source in sources)
        switch (source) {
          SuggestionSource.server => 'Auf deinem Server',
          SuggestionSource.subscription =>
            included.first.type == OfferType.flatrate
                ? 'In deinem Abo bei ${included.first.providerName}'
                : 'Kostenlos bei ${included.first.providerName}',
          SuggestionSource.shelf =>
            'Im Regal als ${c.ownedFormats.map((f) => f == MediaFormat.unknown ? 'Disc' : f.label).toSet().join(', ')}',
        },
      if (c.runtime != null) '${c.runtime} Minuten',
      if (!c.watched)
        'Noch nicht gesehen'
      else if (c.watchCount > 1)
        'Schon ${c.watchCount}× gesehen',
      if (c.originalLanguage != null && c.originalLanguage == preferredLanguage)
        'Originalsprache ${languageNames[c.originalLanguage] ?? c.originalLanguage}',
      if (c.rating != null) 'Deine Bewertung ${c.rating}/10',
    ];
    result.add(Suggestion(candidate: c, sources: sources, reasons: reasons));
  }

  result.sort((a, b) {
    final watched =
        (a.candidate.watched ? 1 : 0) - (b.candidate.watched ? 1 : 0);
    if (watched != 0) return watched;
    final source = a.sources.first.index - b.sources.first.index;
    if (source != 0) return source;
    final rating = (b.candidate.rating ?? 0) - (a.candidate.rating ?? 0);
    if (rating != 0) return rating;
    return a.candidate.title.toLowerCase().compareTo(
      b.candidate.title.toLowerCase(),
    );
  });
  return result;
}

/// Short, optional observations about the collection for Home.
class CollectionInsights {
  const CollectionInsights({
    this.unwatchedOnShelf = 0,
    this.unwatchedOnServer = 0,
    this.wishlistInSubscription = const [],
  });

  final int unwatchedOnShelf;
  final int unwatchedOnServer;

  /// Wishlist titles now included in a subscription, with the provider.
  final List<({WatchCandidate candidate, String provider})>
  wishlistInSubscription;

  bool get isEmpty =>
      unwatchedOnShelf == 0 &&
      unwatchedOnServer == 0 &&
      wishlistInSubscription.isEmpty;
}

CollectionInsights collectionInsights(
  List<WatchCandidate> candidates, {
  required Set<int> subscriptions,
}) {
  final inSubscription = <({WatchCandidate candidate, String provider})>[];
  for (final c in candidates.where((c) => c.onWishlist)) {
    final offer = c.offers
        .where(
          (o) =>
              o.type == OfferType.flatrate &&
              subscriptions.contains(o.providerId),
        )
        .firstOrNull;
    if (offer != null) {
      inSubscription.add((candidate: c, provider: offer.providerName));
    }
  }
  return CollectionInsights(
    unwatchedOnShelf: candidates
        .where((c) => c.ownedFormats.isNotEmpty && !c.watched)
        .length,
    unwatchedOnServer: candidates
        .where((c) => c.onServer && c.ownedFormats.isEmpty && !c.watched)
        .length,
    wishlistInSubscription: inSubscription,
  );
}
