class CachedProviderResult {
  const CachedProviderResult({
    required this.barcode,
    required this.provider,
    required this.outcome,
    required this.expiresAt,
    this.payload,
  });

  final String barcode;
  final String provider;
  final String outcome;
  final DateTime expiresAt;
  final String? payload;

  bool get isFresh => expiresAt.isAfter(DateTime.now());
}

abstract class BarcodeLookupCacheStore {
  Future<CachedProviderResult?> read(String barcode, String provider);
  Future<void> save(CachedProviderResult result);
}
