import 'package:drift/drift.dart';

import '../../../core/database/app_database.dart';
import '../domain/barcode_lookup_cache.dart';

class BarcodeLookupCacheRepository implements BarcodeLookupCacheStore {
  BarcodeLookupCacheRepository(this._db);

  final AppDatabase _db;

  @override
  Future<CachedProviderResult?> read(String barcode, String provider) async {
    final row =
        await (_db.select(_db.barcodeLookupCache)..where(
              (t) => t.barcode.equals(barcode) & t.provider.equals(provider),
            ))
            .getSingleOrNull();
    if (row == null) return null;
    return CachedProviderResult(
      barcode: row.barcode,
      provider: row.provider,
      outcome: row.outcome,
      payload: row.payload,
      expiresAt: row.expiresAt,
    );
  }

  @override
  Future<void> save(CachedProviderResult result) async {
    await _db
        .into(_db.barcodeLookupCache)
        .insertOnConflictUpdate(
          BarcodeLookupCacheCompanion.insert(
            barcode: result.barcode,
            provider: result.provider,
            outcome: result.outcome,
            payload: Value(result.payload),
            fetchedAt: DateTime.now(),
            expiresAt: result.expiresAt,
          ),
        );
  }
}
