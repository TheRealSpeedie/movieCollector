import 'package:uuid/uuid.dart';

/// Stable identities for synchronised records.
///
/// Titles, seasons, barcodes and personal state are derived from what they
/// describe (UUIDv5), so two devices that add the same film offline create the
/// same record and the server merges them instead of storing a duplicate.
/// Editions and copies are genuinely distinct things and get random ids.
class SyncIds {
  SyncIds._();

  /// Fixed namespace for every Movie Shelf UUIDv5. Never change it: existing
  /// collections on phones and servers depend on it.
  static const namespace = '0b6f3e8a-4c1d-5e2f-9a7b-8c3d2e1f0a95';

  static const _uuid = Uuid();

  static String random() => _uuid.v4();

  static String _derived(String name) => _uuid.v5(namespace, name);

  static String movie(int tmdbId) => _derived('movie:$tmdbId');

  static String series(int tmdbId) => _derived('tv:$tmdbId');

  static String season(int seriesTmdbId, int seasonNumber) =>
      _derived('tv:$seriesTmdbId:s$seasonNumber');

  static String barcode(String code) => _derived('barcode:$code');

  static String personalState(String subjectUuid) =>
      _derived('state:$subjectUuid');

  static String subscription(int providerId) =>
      _derived('subscription:$providerId');

  static String editionContent(String editionUuid, String subjectUuid) =>
      _derived('content:$editionUuid:$subjectUuid');
}
