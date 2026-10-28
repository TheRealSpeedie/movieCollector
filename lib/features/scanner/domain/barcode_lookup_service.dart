import 'dart:convert';

import '../../../core/errors/app_exception.dart';
import '../../../core/network/upcmdb/upcmdb_client.dart';
import '../../../core/network/upcitemdb/upcitemdb_client.dart';
import '../../../core/utils/title_normalizer.dart';
import '../../editions/data/edition_catalog.dart';
import 'barcode_lookup_cache.dart';
import 'physical_product.dart';
import 'scan_trace.dart';

sealed class ExternalLookup {
  const ExternalLookup();
}

class ExternalLookupHit extends ExternalLookup {
  const ExternalLookupHit(this.product);
  final PhysicalProduct product;
}

class ExternalLookupMiss extends ExternalLookup {
  const ExternalLookupMiss();
}

class ExternalLookupFailed extends ExternalLookup {
  const ExternalLookupFailed(this.message);
  final String message;
}

class BarcodeLookupService {
  BarcodeLookupService({
    required BarcodeProvider upcItemDb,
    this.upcmdb,
    this.cache,
    this.catalog,
  }) : _upcItemDb = upcItemDb;

  final BarcodeProvider _upcItemDb;
  final UpcmdbApi? upcmdb;
  final BarcodeLookupCacheStore? cache;

  /// The edition catalog of the own server or Movie Shelf Cloud. Asked
  /// first: its entries were described and checked by people.
  final EditionCatalog? catalog;

  static const foundTtl = Duration(days: 30);
  static const missTtl = Duration(days: 7);
  static const errorTtl = Duration(minutes: 10);

  Future<ExternalLookup> lookup(String gtin, ScanTrace trace) async {
    var sawMiss = false;
    String? failure;

    if (catalog != null) {
      try {
        final entries = await catalog!.forBarcode(gtin);
        trace.add('catalog=${entries.length}');
        if (entries.isNotEmpty) {
          final e = entries.first;
          return ExternalLookupHit(
            PhysicalProduct(
              source: 'catalog',
              title: e.title,
              year: e.year,
              physicalFormat: e.format.name,
              edition: e.editionName,
              region: e.region,
              publisher: e.publisher,
              mediaType: e.kind,
            ),
          );
        }
      } on Exception catch (error) {
        trace.add('catalog-error=$error');
      }
    }

    if (upcmdb != null && (gtin.length == 12 || gtin.length == 13)) {
      final upcmdbResult = await _upcmdb(gtin, trace);
      switch (upcmdbResult) {
        case ExternalLookupHit():
          return upcmdbResult;
        case ExternalLookupMiss():
          sawMiss = true;
        case ExternalLookupFailed(:final message):
          failure = message;
      }
    } else {
      trace.add('upcmdb=skipped');
    }

    final upc = await _upcItem(gtin, trace);
    switch (upc) {
      case ExternalLookupHit():
        return upc;
      case ExternalLookupMiss():
        sawMiss = true;
      case ExternalLookupFailed(:final message):
        failure ??= message;
    }

    if (sawMiss) return const ExternalLookupMiss();
    return ExternalLookupFailed(
      failure ?? 'Die Produktabfrage ist fehlgeschlagen.',
    );
  }

  Future<ExternalLookup> _upcmdb(String gtin, ScanTrace trace) async {
    final cached = await cache?.read(gtin, 'upcmdb');
    if (cached != null && cached.isFresh) {
      trace.add('upcmdb-cache=${cached.outcome}');
      return _fromCache(cached);
    }
    trace.add('upcmdb=request');
    final call = await upcmdb!.lookupGtin(gtin);
    switch (call) {
      case UpcmdbFound(:final record):
        trace.add('upcmdb=hit');
        final product = _fromUpcmdb(record);
        await _store(
          gtin,
          'upcmdb',
          'found',
          foundTtl,
          jsonEncode(product.toJson()),
        );
        return ExternalLookupHit(product);
      case UpcmdbNotFound():
        trace.add('upcmdb=not-found');
        await _store(gtin, 'upcmdb', 'not_found', missTtl, null);
        return const ExternalLookupMiss();
      case UpcmdbFailed(:final reason):
        trace.add('upcmdb=failed:$reason');
        await _store(gtin, 'upcmdb', 'error', errorTtl, null);
        return ExternalLookupFailed(_failureMessage(reason));
    }
  }

  Future<ExternalLookup> _upcItem(String gtin, ScanTrace trace) async {
    final cached = await cache?.read(gtin, 'upcitemdb');
    if (cached != null && cached.isFresh) {
      trace.add('upcitemdb-cache=${cached.outcome}');
      return _fromCache(cached);
    }
    trace.add('upcitemdb=request');
    try {
      final result = await _upcItemDb.lookup(gtin);
      if (!result.found) {
        trace.add('upcitemdb=not-found');
        await _store(gtin, 'upcitemdb', 'not_found', missTtl, null);
        return const ExternalLookupMiss();
      }
      final item = result.items.first;
      final described = TitleNormalizer.describe(
        item.title,
        publisher: item.brand,
      );
      final product = PhysicalProduct(
        source: 'upcitemdb',
        title: described.searchTitle.isEmpty
            ? item.title
            : described.searchTitle,
        productTitle: item.title,
        year: described.year,
        physicalFormat: described.physicalFormat,
        edition: described.edition,
        region: described.region,
        publisher: item.brand ?? described.publisher,
      );
      trace.add('upcitemdb=hit');
      await _store(
        gtin,
        'upcitemdb',
        'found',
        foundTtl,
        jsonEncode(product.toJson()),
      );
      return ExternalLookupHit(product);
    } on BarcodeNotFoundException {
      trace.add('upcitemdb=not-found');
      await _store(gtin, 'upcitemdb', 'not_found', missTtl, null);
      return const ExternalLookupMiss();
    } on MovieNotFoundException {
      trace.add('upcitemdb=not-found');
      await _store(gtin, 'upcitemdb', 'not_found', missTtl, null);
      return const ExternalLookupMiss();
    } on RateLimitException {
      trace.add('upcitemdb=failed:rate_limit');
      await _store(gtin, 'upcitemdb', 'error', errorTtl, null);
      return const ExternalLookupFailed(
        'Das Anfragelimit eines Produktdienstes ist erreicht.',
      );
    } on AppException catch (error) {
      trace.add('upcitemdb=failed:${error.message}');
      await _store(gtin, 'upcitemdb', 'error', errorTtl, null);
      return ExternalLookupFailed(error.message);
    }
  }

  ExternalLookup _fromCache(CachedProviderResult cached) {
    if (cached.outcome == 'found' && cached.payload != null) {
      final json = jsonDecode(cached.payload!);
      if (json is Map<String, dynamic>) {
        final product = PhysicalProduct.fromJson(json);
        if (product.title.isNotEmpty) return ExternalLookupHit(product);
      }
      if (json is Map) {
        final product = PhysicalProduct.fromJson(
          Map<String, dynamic>.from(json),
        );
        if (product.title.isNotEmpty) return ExternalLookupHit(product);
      }
    }
    if (cached.outcome == 'not_found') return const ExternalLookupMiss();
    return const ExternalLookupFailed('Die Produktabfrage ist fehlgeschlagen.');
  }

  PhysicalProduct _fromUpcmdb(UpcmdbRecord record) {
    final described = TitleNormalizer.describe(
      record.title,
      publisher: record.publisher,
    );
    final display = [
      record.title,
      if (record.format != null) record.format!,
      if (record.specialFeatures != null) record.specialFeatures!,
    ].join(' ');
    return PhysicalProduct(
      source: 'upcmdb',
      title: described.searchTitle.isEmpty
          ? record.title
          : described.searchTitle,
      productTitle: display,
      year: record.year ?? described.year,
      physicalFormat:
          mapPhysicalFormat(record.format) ?? described.physicalFormat,
      edition: record.specialFeatures ?? described.edition,
      region: described.region,
      publisher: record.publisher ?? described.publisher,
      imdbId: record.imdbId,
      mediaType: record.mediaType,
    );
  }

  Future<void> _store(
    String gtin,
    String provider,
    String outcome,
    Duration ttl,
    String? payload,
  ) async {
    final now = DateTime.now();
    await cache?.save(
      CachedProviderResult(
        barcode: gtin,
        provider: provider,
        outcome: outcome,
        payload: payload,
        expiresAt: now.add(ttl),
      ),
    );
  }

  String _failureMessage(String reason) {
    return switch (reason) {
      'rate_limit' => 'Das Anfragelimit eines Produktdienstes ist erreicht.',
      'auth' => 'Der Produktdienst hat den Zugriff abgelehnt.',
      'offline' => 'Keine Internetverbindung verfügbar.',
      _ => 'Die Produktabfrage ist fehlgeschlagen.',
    };
  }
}
