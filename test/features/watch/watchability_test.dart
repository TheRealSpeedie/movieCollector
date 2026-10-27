import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_watch_models.dart';
import 'package:movie_shelf/features/watch/domain/watchability.dart';

const _netflix = 8;
const _prime = 9;

TmdbWatchOffer _offer(int id, String name, OfferType type) =>
    TmdbWatchOffer(providerId: id, providerName: name, type: type);

void main() {
  test('sources come in the order server, subscription, shelf, paid', () {
    final sources = watchSources(
      onServer: true,
      ownedFormats: ['Blu-ray'],
      offers: [
        _offer(_netflix, 'Netflix', OfferType.flatrate),
        _offer(_prime, 'Prime Video', OfferType.rent),
      ],
      subscriptions: {_netflix},
    );
    expect(sources.map((s) => s.option), [
      WatchOption.playNow,
      WatchOption.subscription,
      WatchOption.shelf,
      WatchOption.rentOrBuy,
    ]);
  });

  test('a disc is never a streaming source', () {
    final sources = watchSources(
      onServer: false,
      ownedFormats: ['DVD'],
      offers: const [],
      subscriptions: const {},
    );
    expect(sources.single.option, WatchOption.shelf);
    expect(sources.single.detail, contains('Abspielgerät nötig'));
  });

  test('a subscription the user does not have costs extra', () {
    final sources = watchSources(
      onServer: false,
      ownedFormats: const [],
      offers: [
        _offer(_netflix, 'Netflix', OfferType.flatrate),
        _offer(_prime, 'Prime Video', OfferType.rent),
        _offer(_prime, 'Prime Video', OfferType.buy),
      ],
      subscriptions: const {},
    );
    expect(sources.map((s) => s.option).toSet(), {WatchOption.rentOrBuy});
    expect(sources.firstWhere((s) => s.title == 'Netflix').detail, 'Abo nötig');
    expect(
      sources.firstWhere((s) => s.title == 'Prime Video').detail,
      'Leihen · Kaufen',
    );
  });

  test('free offers count without a subscription', () {
    final sources = watchSources(
      onServer: false,
      ownedFormats: const [],
      offers: [_offer(1, 'ARD Mediathek', OfferType.free)],
      subscriptions: const {},
    );
    expect(sources.single.option, WatchOption.free);
  });

  test('nothing known is said plainly', () {
    final sources = watchSources(
      onServer: false,
      ownedFormats: const [],
      offers: const [],
      subscriptions: const {},
    );
    expect(sources.single.option, WatchOption.unavailable);
  });
}
