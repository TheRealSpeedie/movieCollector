import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/database/media_format.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_watch_models.dart';
import 'package:movie_shelf/features/discover/domain/watch_suggestions.dart';

const _netflix = 8;

final _horrorOnServer = WatchCandidate(
  title: 'Der Schacht',
  runtime: 94,
  genres: const ['Horror'],
  originalLanguage: 'es',
  onServer: true,
);
final _horrorInAbo = WatchCandidate(
  title: 'Es',
  runtime: 135,
  genres: const ['Horror'],
  originalLanguage: 'en',
  offers: const [
    TmdbWatchOffer(
      providerId: _netflix,
      providerName: 'Netflix',
      type: OfferType.flatrate,
    ),
  ],
);
final _comedyOnShelf = WatchCandidate(
  title: 'Good Bye, Lenin!',
  runtime: 121,
  genres: const ['Komödie'],
  originalLanguage: 'de',
  ownedFormats: const [MediaFormat.bluray],
  rating: 8,
);
final _seenDrama = WatchCandidate(
  title: 'Das Boot',
  runtime: 149,
  genres: const ['Drama'],
  ownedFormats: const [MediaFormat.dvd],
  watched: true,
  watchCount: 3,
);
final _rentOnly = WatchCandidate(
  title: 'Nur zum Leihen',
  offers: const [
    TmdbWatchOffer(
      providerId: 2,
      providerName: 'Apple TV',
      type: OfferType.rent,
    ),
  ],
);

final _all = [
  _horrorOnServer,
  _horrorInAbo,
  _comedyOnShelf,
  _seenDrama,
  _rentOnly,
];

void main() {
  test('a horror film under 100 minutes without extra cost', () {
    final result = suggest(
      _all,
      const SuggestionFilter(genre: 'Horror', maxRuntime: 100),
      subscriptions: {_netflix},
    );
    expect(result.single.candidate, _horrorOnServer);
    expect(result.single.reasons, [
      'Auf deinem Server',
      '94 Minuten',
      'Noch nicht gesehen',
    ]);
  });

  test('titles that only cost extra are never suggested', () {
    final result = suggest(_all, const SuggestionFilter(), subscriptions: {});
    expect(result.map((s) => s.candidate), isNot(contains(_rentOnly)));
    // Without the subscription the Netflix film is not free either.
    expect(result.map((s) => s.candidate), isNot(contains(_horrorInAbo)));
  });

  test('subscriptions, language and rating are explained', () {
    final result = suggest(
      _all,
      const SuggestionFilter(),
      subscriptions: {_netflix},
      preferredLanguage: 'de',
    );
    final abo = result.firstWhere((s) => s.candidate == _horrorInAbo);
    expect(abo.reasons.first, 'In deinem Abo bei Netflix');
    final shelf = result.firstWhere((s) => s.candidate == _comedyOnShelf);
    expect(shelf.reasons, contains('Im Regal als Blu-ray'));
    expect(shelf.reasons, contains('Originalsprache Deutsch'));
    expect(shelf.reasons, contains('Deine Bewertung 8/10'));
  });

  test(
    'server first, then subscription, then shelf; seen ones only on request',
    () {
      final unwatched = suggest(
        _all,
        const SuggestionFilter(),
        subscriptions: {_netflix},
      );
      expect(unwatched.map((s) => s.candidate.title), [
        'Der Schacht',
        'Es',
        'Good Bye, Lenin!',
      ]);

      final everything = suggest(
        _all,
        const SuggestionFilter(unwatchedOnly: false),
        subscriptions: {_netflix},
      );
      expect(everything.last.candidate, _seenDrama);
      expect(everything.last.reasons, contains('Schon 3× gesehen'));
    },
  );

  test('sources and original language narrow the list', () {
    final shelf = suggest(
      _all,
      const SuggestionFilter(sources: {SuggestionSource.shelf}),
      subscriptions: {_netflix},
    );
    expect(shelf.single.candidate, _comedyOnShelf);

    final german = suggest(
      _all,
      const SuggestionFilter(language: 'de'),
      subscriptions: {_netflix},
    );
    expect(german.single.candidate, _comedyOnShelf);
  });

  test('insights find wishlist films that arrived in a subscription', () {
    final wished = WatchCandidate(
      title: 'Alien',
      onWishlist: true,
      offers: const [
        TmdbWatchOffer(
          providerId: _netflix,
          providerName: 'Netflix',
          type: OfferType.flatrate,
        ),
      ],
    );
    final insights = collectionInsights(
      [..._all, wished],
      subscriptions: {_netflix},
    );
    expect(insights.wishlistInSubscription.single.provider, 'Netflix');
    expect(insights.unwatchedOnShelf, 1);
    expect(insights.unwatchedOnServer, 1);

    expect(collectionInsights([wished], subscriptions: {}).isEmpty, isTrue);
  });
}
