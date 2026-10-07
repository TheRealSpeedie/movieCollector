import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/core/network/upcmdb/upcmdb_client.dart';
import 'package:movie_shelf/core/network/upcitemdb/upcitemdb_models.dart';
import 'package:movie_shelf/features/scanner/domain/barcode_lookup_cache.dart';
import 'package:movie_shelf/features/scanner/domain/barcode_lookup_service.dart';
import 'package:movie_shelf/features/scanner/domain/scan_trace.dart';

import 'barcode_resolver_test.mocks.dart';

void main() {
  late MockBarcodeProvider upcItemDb;
  late ScanTrace trace;

  setUp(() {
    upcItemDb = MockBarcodeProvider();
    trace = ScanTrace();
  });

  test('UPCMDB hit with an IMDb id does not call UPCitemdb', () async {
    final upcmdb = _FakeUpcmdb(
      const UpcmdbFound(
        UpcmdbRecord(
          title: 'The Matrix',
          imdbId: 'tt0133093',
          format: 'Blu-ray',
          year: 1999,
          publisher: 'Warner',
        ),
      ),
    );
    final service = BarcodeLookupService(upcItemDb: upcItemDb, upcmdb: upcmdb);

    final result = await service.lookup('0123456789055', trace);

    expect(result, isA<ExternalLookupHit>());
    final hit = result as ExternalLookupHit;
    expect(hit.product.imdbId, 'tt0133093');
    expect(hit.product.source, 'upcmdb');
    expect(hit.product.physicalFormat, 'blu_ray');
    expect(hit.product.title, 'The Matrix');
    expect(upcmdb.calls, 1);
    verifyNever(upcItemDb.lookup(any));
  });

  test('UPCMDB hit without an IMDb id still returns a clean title', () async {
    final service = BarcodeLookupService(
      upcItemDb: upcItemDb,
      upcmdb: _FakeUpcmdb(
        const UpcmdbFound(
          UpcmdbRecord(title: 'Interstellar 4K UHD Steelbook', year: 2014),
        ),
      ),
    );

    final result = await service.lookup('0123456789055', trace);

    final hit = result as ExternalLookupHit;
    expect(hit.product.imdbId, isNull);
    expect(hit.product.title, 'Interstellar');
    expect(hit.product.physicalFormat, 'uhd_4k');
    expect(hit.product.edition?.toLowerCase(), contains('steelbook'));
    verifyNever(upcItemDb.lookup(any));
  });

  test('UPCMDB not found continues to UPCitemdb', () async {
    when(upcItemDb.lookup(any)).thenAnswer(
      (_) async => const UpcLookupResult(
        code: 'OK',
        items: [UpcItem(title: 'Der Pate DVD')],
      ),
    );
    final service = BarcodeLookupService(
      upcItemDb: upcItemDb,
      upcmdb: _FakeUpcmdb(const UpcmdbNotFound()),
    );

    final result = await service.lookup('0123456789055', trace);

    expect((result as ExternalLookupHit).product.source, 'upcitemdb');
    expect(result.product.title.toLowerCase(), 'der pate');
    verify(upcItemDb.lookup('0123456789055')).called(1);
  });

  test('an invalid UPCMDB response continues to UPCitemdb', () async {
    when(upcItemDb.lookup(any)).thenAnswer(
      (_) async => const UpcLookupResult(
        code: 'OK',
        items: [UpcItem(title: 'Heat')],
      ),
    );
    final service = BarcodeLookupService(
      upcItemDb: upcItemDb,
      upcmdb: _FakeUpcmdb(const UpcmdbFailed('invalid')),
    );

    final result = await service.lookup('0123456789055', trace);

    expect((result as ExternalLookupHit).product.source, 'upcitemdb');
    expect(trace.text, contains('upcmdb=failed:invalid'));
  });

  test('UPCMDB timeout continues to UPCitemdb', () async {
    when(upcItemDb.lookup(any)).thenAnswer(
      (_) async => const UpcLookupResult(
        code: 'OK',
        items: [UpcItem(title: 'Heat')],
      ),
    );
    final service = BarcodeLookupService(
      upcItemDb: upcItemDb,
      upcmdb: _FakeUpcmdb(const UpcmdbFailed('unavailable')),
    );

    final result = await service.lookup('0123456789055', trace);

    expect(result, isA<ExternalLookupHit>());
    expect(trace.text, contains('upcmdb=failed:unavailable'));
  });

  test('rate limit with no other hit is a provider failure', () async {
    when(upcItemDb.lookup(any)).thenThrow(const RateLimitException());
    final service = BarcodeLookupService(
      upcItemDb: upcItemDb,
      upcmdb: _FakeUpcmdb(const UpcmdbFailed('rate_limit')),
    );

    final result = await service.lookup('0123456789055', trace);

    expect(result, isA<ExternalLookupFailed>());
  });

  test('cached UPCMDB hit skips both network calls', () async {
    final cache = _MemoryCache()
      ..put(
        CachedProviderResult(
          barcode: '0123456789055',
          provider: 'upcmdb',
          outcome: 'found',
          expiresAt: DateTime.now().add(const Duration(days: 1)),
          payload:
              '{"source":"upcmdb","title":"Heat","imdbId":"tt0113277","year":1995}',
        ),
      );
    final upcmdb = _FakeUpcmdb(const UpcmdbNotFound());
    final service = BarcodeLookupService(
      upcItemDb: upcItemDb,
      upcmdb: upcmdb,
      cache: cache,
    );

    final result = await service.lookup('0123456789055', trace);

    expect((result as ExternalLookupHit).product.imdbId, 'tt0113277');
    expect(upcmdb.calls, 0);
    verifyNever(upcItemDb.lookup(any));
  });

  test('cached UPCMDB miss still allows UPCitemdb', () async {
    when(upcItemDb.lookup(any)).thenAnswer(
      (_) async => const UpcLookupResult(
        code: 'OK',
        items: [UpcItem(title: 'Alien')],
      ),
    );
    final cache = _MemoryCache()
      ..put(
        CachedProviderResult(
          barcode: '0123456789055',
          provider: 'upcmdb',
          outcome: 'not_found',
          expiresAt: DateTime.now().add(const Duration(days: 1)),
        ),
      );
    final upcmdb = _FakeUpcmdb(const UpcmdbFound(UpcmdbRecord(title: 'Nope')));
    final service = BarcodeLookupService(
      upcItemDb: upcItemDb,
      upcmdb: upcmdb,
      cache: cache,
    );

    final result = await service.lookup('0123456789055', trace);

    expect((result as ExternalLookupHit).product.source, 'upcitemdb');
    expect(upcmdb.calls, 0);
  });
}

class _FakeUpcmdb implements UpcmdbApi {
  _FakeUpcmdb(this.call);

  final UpcmdbCall call;
  int calls = 0;

  @override
  Future<UpcmdbCall> lookupGtin(String gtin) async {
    calls += 1;
    return call;
  }
}

class _MemoryCache implements BarcodeLookupCacheStore {
  final items = <String, CachedProviderResult>{};

  void put(CachedProviderResult result) {
    items['${result.provider}|${result.barcode}'] = result;
  }

  @override
  Future<CachedProviderResult?> read(String barcode, String provider) async {
    return items['$provider|$barcode'];
  }

  @override
  Future<void> save(CachedProviderResult result) async {
    put(result);
  }
}
