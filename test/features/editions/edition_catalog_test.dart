import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_shelf/core/database/media_format.dart';
import 'package:movie_shelf/features/editions/data/copy_repository.dart';
import 'package:movie_shelf/features/editions/data/edition_catalog.dart';
import 'package:movie_shelf/features/scanner/domain/barcode_lookup_service.dart';
import 'package:movie_shelf/features/scanner/domain/scan_trace.dart';

import '../../core/sync/sync_engine_test.dart' show Device, FakeServer;
import '../scanner/barcode_resolver_test.mocks.dart';

class FakeCatalog implements EditionCatalog {
  FakeCatalog(this.entries);

  final List<CatalogEntry> entries;
  final submitted = <Map<String, Object?>>[];

  @override
  String get name => 'Testkatalog';

  @override
  Future<List<CatalogEntry>> forBarcode(String code) async =>
      entries.where((e) => e.barcodes.contains(code)).toList();

  @override
  Future<List<CatalogEntry>> forTitle(String kind, int tmdbId) async =>
      entries.where((e) => e.tmdbId == tmdbId).toList();

  @override
  Future<CatalogEntry> submit(CatalogEntry entry, {String? replaces}) async {
    submitted.add(entry.toSubmission(replaces: replaces));
    return CatalogEntry.fromJson({
      'id': 'new',
      'title': entry.title,
      'format': entry.format.name,
      'status': 'pending',
    });
  }
}

const steelbook = CatalogEntry(
  id: 'c1',
  kind: 'movie',
  title: 'The Matrix',
  tmdbId: 603,
  year: 1999,
  format: MediaFormat.uhd4k,
  editionName: 'Steelbook',
  region: 'B',
  barcodes: ['5051890012345'],
  attribution: 'Movie Shelf users',
);

void main() {
  test('catalog answers are read with their attribution and status', () {
    final entry = CatalogEntry.fromJson({
      'id': 'x',
      'kind': 'movie',
      'title': 'Arrival',
      'format': 'bluray',
      'barcodes': ['4006680012345'],
      'attribution': 'Movie Shelf users',
      'status': 'pending',
      'mine': true,
    });
    expect(entry.format, MediaFormat.bluray);
    expect(entry.pending, isTrue);
    expect(entry.attribution, 'Movie Shelf users');
  });

  test('sharing sends the release only, and names the corrected entry', () {
    final sent = steelbook.toSubmission(replaces: 'c1');
    expect(sent['replaces'], 'c1');
    expect(sent['format'], 'uhd4k');
    for (final private in ['ownerId', 'purchasePrice', 'notes', 'condition']) {
      expect(sent.containsKey(private), isFalse);
    }
    expect(steelbook.toSubmission().containsKey('replaces'), isFalse);
  });

  test('a catalog edition is kept on the device and counts as known', () async {
    final phone = Device(FakeServer());
    addTearDown(phone.db.close);
    final movieId = await phone.own(603);
    final repository = CopyRepository(phone.db);

    final editionId = await repository.adoptCatalogEdition(movieId, steelbook);

    final known = await repository.knownForMovie(movieId);
    expect(known.catalogIds, contains('c1'));
    expect(known.barcodes, contains('5051890012345'));
    // The film is owned on an unknown format from own(); the 4K entry is not owned.
    final copies = await (phone.db.select(
      phone.db.ownedCopies,
    )..where((t) => t.editionId.equals(editionId))).get();
    expect(copies, isEmpty);
    final entry = await repository.catalogEntryFor(editionId, movieId);
    expect(entry!.id, 'c1');
    expect(entry.barcodes, ['5051890012345']);
  });

  test(
    'a barcode in the catalog is answered without barcode services',
    () async {
      final upcItemDb = MockBarcodeProvider();
      final service = BarcodeLookupService(
        upcItemDb: upcItemDb,
        catalog: FakeCatalog([steelbook]),
      );

      final result = await service.lookup('5051890012345', ScanTrace());

      final hit = result as ExternalLookupHit;
      expect(hit.product.source, 'catalog');
      expect(hit.product.title, 'The Matrix');
      expect(hit.product.edition, 'Steelbook');
      verifyNever(upcItemDb.lookup(any));
    },
  );
}
