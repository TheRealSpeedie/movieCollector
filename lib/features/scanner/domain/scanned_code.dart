enum ScannedCodeKind { ean13, ean8, upcA, upcE, gtin14, qrUrl, text }

class ScannedCode {
  const ScannedCode({
    required this.raw,
    required this.kind,
    this.canonicalGtin,
    this.extractedFromUrl = false,
  });

  final String raw;
  final ScannedCodeKind kind;
  final String? canonicalGtin;
  final bool extractedFromUrl;

  bool get isProductCode => canonicalGtin != null;

  List<String> get lookupKeys {
    final keys = <String>[];
    if (canonicalGtin != null) keys.add(canonicalGtin!);
    final digits = _digits(raw);
    if (digits.isNotEmpty && !keys.contains(digits)) keys.add(digits);
    if (raw.trim().isNotEmpty && !keys.contains(raw.trim())) {
      keys.add(raw.trim());
    }
    if (canonicalGtin != null &&
        canonicalGtin!.length == 13 &&
        canonicalGtin!.startsWith('0')) {
      final upc = canonicalGtin!.substring(1);
      if (!keys.contains(upc)) keys.add(upc);
    }
    return keys;
  }

  static ScannedCode parse(String raw, {String? formatName}) {
    final trimmed = raw.trim();
    final format = formatName?.toLowerCase();
    final looksLikeUrl = _isUrl(trimmed);
    if (format == 'qrcode' || looksLikeUrl) {
      if (looksLikeUrl) {
        final embedded = _gtinInText(trimmed);
        if (embedded == null) {
          return ScannedCode(raw: trimmed, kind: ScannedCodeKind.qrUrl);
        }
        return ScannedCode(
          raw: trimmed,
          kind: embedded.kind,
          canonicalGtin: embedded.canonical,
          extractedFromUrl: true,
        );
      }
      final direct = _fromDigits(trimmed, formatName: format);
      if (direct != null) return direct.copyWith(raw: trimmed);
      return ScannedCode(raw: trimmed, kind: ScannedCodeKind.text);
    }
    return _fromDigits(trimmed, formatName: format) ??
        ScannedCode(raw: trimmed, kind: ScannedCodeKind.text);
  }

  ScannedCode copyWith({String? raw}) {
    return ScannedCode(
      raw: raw ?? this.raw,
      kind: kind,
      canonicalGtin: canonicalGtin,
      extractedFromUrl: extractedFromUrl,
    );
  }

  static ScannedCode? _fromDigits(String raw, {String? formatName}) {
    final digits = _digits(raw);
    if (digits.isEmpty || digits != raw.replaceAll(RegExp(r'[\s-]'), '')) {
      if (!RegExp(r'^\d+$').hasMatch(digits)) return null;
    }
    if (digits.isEmpty) return null;
    if (formatName == 'upce' && digits.length == 8) {
      final expanded = expandUpcE(digits);
      if (expanded != null) {
        return ScannedCode(
          raw: raw.trim(),
          kind: ScannedCodeKind.upcE,
          canonicalGtin: '0$expanded',
        );
      }
    }
    if (digits.length == 8 && formatName != 'upce' && isValidGtin(digits)) {
      return ScannedCode(
        raw: raw.trim(),
        kind: ScannedCodeKind.ean8,
        canonicalGtin: digits,
      );
    }
    if (digits.length == 8 && formatName == 'upce') return null;
    if ((digits.length == 12 || formatName == 'upca') &&
        digits.length == 12 &&
        isValidGtin(digits)) {
      return ScannedCode(
        raw: raw.trim(),
        kind: ScannedCodeKind.upcA,
        canonicalGtin: '0$digits',
      );
    }
    if (digits.length == 13 && isValidGtin(digits)) {
      return ScannedCode(
        raw: raw.trim(),
        kind: ScannedCodeKind.ean13,
        canonicalGtin: digits,
      );
    }
    if (digits.length == 14 && isValidGtin(digits)) {
      return ScannedCode(
        raw: raw.trim(),
        kind: ScannedCodeKind.gtin14,
        canonicalGtin: digits,
      );
    }
    if (digits.length == 8) {
      final expanded = expandUpcE(digits);
      if (expanded != null) {
        return ScannedCode(
          raw: raw.trim(),
          kind: ScannedCodeKind.upcE,
          canonicalGtin: '0$expanded',
        );
      }
    }
    return null;
  }

  static _GtinMatch? _gtinInText(String raw) {
    final matches = RegExp(
      r'(?<!\d)(\d{8}|\d{12}|\d{13}|\d{14})(?!\d)',
    ).allMatches(raw).map((m) => m.group(1)!).toList();
    const order = [13, 12, 14, 8];
    for (final length in order) {
      for (final candidate in matches.where((d) => d.length == length)) {
        final parsed = _fromDigits(candidate);
        if (parsed?.canonicalGtin != null) {
          return _GtinMatch(parsed!.kind, parsed.canonicalGtin!);
        }
      }
    }
    return null;
  }

  static bool _isUrl(String raw) {
    final uri = Uri.tryParse(raw);
    return uri != null && (uri.scheme == 'http' || uri.scheme == 'https');
  }

  static String _digits(String raw) => raw.replaceAll(RegExp(r'\D'), '');
}

class _GtinMatch {
  const _GtinMatch(this.kind, this.canonical);
  final ScannedCodeKind kind;
  final String canonical;
}

bool isValidGtin(String digits) {
  if (!RegExp(r'^\d{8}$|^\d{12}$|^\d{13}$|^\d{14}$').hasMatch(digits)) {
    return false;
  }
  final body = digits.substring(0, digits.length - 1);
  final check = int.parse(digits[digits.length - 1]);
  return gtinCheckDigit(body) == check;
}

int gtinCheckDigit(String body) {
  var sum = 0;
  var weight = 3;
  for (var i = body.length - 1; i >= 0; i--) {
    sum += int.parse(body[i]) * weight;
    weight = weight == 3 ? 1 : 3;
  }
  return (10 - (sum % 10)) % 10;
}

String? expandUpcE(String eight) {
  if (!RegExp(r'^\d{8}$').hasMatch(eight)) return null;
  final ns = eight[0];
  final d1 = eight[1];
  final d2 = eight[2];
  final d3 = eight[3];
  final d4 = eight[4];
  final d5 = eight[5];
  final d6 = eight[6];
  final check = eight[7];
  final String body;
  if (d6 == '0' || d6 == '1' || d6 == '2') {
    body = '$ns$d1$d2${d6}0000$d3$d4$d5';
  } else if (d6 == '3') {
    body = '$ns$d1$d2${d3}00000$d4$d5';
  } else if (d6 == '4') {
    body = '$ns$d1$d2$d3${d4}00000$d5';
  } else {
    body = '$ns$d1$d2$d3$d4${d5}0000$d6';
  }
  final upcA = '$body$check';
  if (upcA.length != 12 || !isValidGtin(upcA)) return null;
  return upcA;
}
