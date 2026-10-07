import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/features/scanner/domain/scanned_code.dart';

void main() {
  String ean13(String body) => '$body${gtinCheckDigit(body)}';

  test('accepts a valid EAN-13 and keeps it canonical', () {
    final code = ean13('400123456789');
    final scanned = ScannedCode.parse(code, formatName: 'ean13');
    expect(scanned.kind, ScannedCodeKind.ean13);
    expect(scanned.canonicalGtin, code);
    expect(scanned.isProductCode, isTrue);
  });

  test('expands UPC-A to the same canonical GTIN as a leading-zero EAN-13', () {
    final ean = ean13('012345678905');
    final upc = ean.substring(1);
    expect(isValidGtin(upc), isTrue);
    final fromUpc = ScannedCode.parse(upc, formatName: 'upcA');
    final fromEan = ScannedCode.parse(ean, formatName: 'ean13');
    expect(fromUpc.canonicalGtin, fromEan.canonicalGtin);
    expect(fromUpc.lookupKeys, contains(upc));
  });

  test('rejects an EAN-13 with a bad check digit', () {
    final scanned = ScannedCode.parse('4001234567890');
    expect(scanned.isProductCode, isFalse);
    expect(scanned.kind, ScannedCodeKind.text);
  });

  test('extracts a GTIN from a QR url and ignores a url without one', () {
    final code = ean13('400123456789');
    final withCode = ScannedCode.parse(
      'https://shop.example/product/$code',
      formatName: 'qrCode',
    );
    expect(withCode.canonicalGtin, code);
    expect(withCode.extractedFromUrl, isTrue);

    final without = ScannedCode.parse(
      'https://studio.example/digital-copy',
      formatName: 'qrCode',
    );
    expect(without.isProductCode, isFalse);
    expect(without.kind, ScannedCodeKind.qrUrl);
  });

  test('expands a UPC-E whose check digit matches the UPC-A', () {
    const body = '01234600005';
    final upcA = '$body${gtinCheckDigit(body)}';
    final upcE = '0123465${upcA[upcA.length - 1]}';
    expect(expandUpcE(upcE), upcA);
    final scanned = ScannedCode.parse(upcE, formatName: 'upcE');
    expect(scanned.kind, ScannedCodeKind.upcE);
    expect(scanned.canonicalGtin, '0$upcA');
  });
}
