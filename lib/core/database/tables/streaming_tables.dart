import 'package:drift/drift.dart';

/// Where a title can be streamed, rented or bought, per region. A cache of
/// TMDB watch providers (data by JustWatch); never part of ownership.
@DataClassName('StreamingOfferRow')
class StreamingOffers extends Table {
  /// movie or tv.
  TextColumn get mediaType => text()();
  IntColumn get tmdbId => integer()();
  TextColumn get region => text()();
  IntColumn get providerId => integer()();
  TextColumn get providerName => text()();
  TextColumn get logoPath => text().nullable()();

  /// An OfferType name: flatrate, free, ads, rent or buy.
  TextColumn get offerType => text()();

  /// The TMDB page that lists the offers; TMDB gives no per-provider links.
  TextColumn get link => text().nullable()();
  DateTimeColumn get checkedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {
    mediaType,
    tmdbId,
    region,
    providerId,
    offerType,
  };
}

/// Marks that a title was checked and has no offers, so it is not fetched
/// again until the cache expires.
@DataClassName('StreamingCheckRow')
class StreamingChecks extends Table {
  TextColumn get mediaType => text()();
  IntColumn get tmdbId => integer()();
  TextColumn get region => text()();
  DateTimeColumn get checkedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {mediaType, tmdbId, region};
}

/// Streaming services the user pays for. Synced between devices.
@DataClassName('StreamingSubscriptionRow')
class StreamingSubscriptions extends Table {
  IntColumn get providerId => integer()();
  TextColumn get providerName => text()();
  TextColumn get logoPath => text().nullable()();

  @override
  Set<Column> get primaryKey => {providerId};
}
