import 'dart:convert';

import '../../../core/errors/app_exception.dart';
import '../../../core/network/dio_client.dart';

sealed class UpcmdbCall {
  const UpcmdbCall();
}

class UpcmdbFound extends UpcmdbCall {
  const UpcmdbFound(this.record);
  final UpcmdbRecord record;
}

class UpcmdbNotFound extends UpcmdbCall {
  const UpcmdbNotFound();
}

class UpcmdbFailed extends UpcmdbCall {
  const UpcmdbFailed(this.reason);
  final String reason;
}

class UpcmdbRecord {
  const UpcmdbRecord({
    required this.title,
    this.upc,
    this.year,
    this.format,
    this.specialFeatures,
    this.publisher,
    this.imdbId,
    this.mediaType,
  });

  final String title;
  final String? upc;
  final int? year;
  final String? format;
  final String? specialFeatures;
  final String? publisher;
  final String? imdbId;
  final String? mediaType;

  factory UpcmdbRecord.fromJson(Map<String, dynamic> json) {
    final title = (json['title'] as String?)?.trim() ?? '';
    return UpcmdbRecord(
      title: title,
      upc: json['upc'] as String? ?? json['ean'] as String?,
      year: _year(json['year']),
      format: _text(json['format']),
      specialFeatures: _text(json['special_features']),
      publisher: _text(json['publisher']),
      imdbId: normalizeImdbId(json['imdbID'] as String? ?? json['imdbId'] as String?),
      mediaType: _mediaType(json['mediaType'] as String? ?? json['type'] as String?),
    );
  }
}

abstract class UpcmdbApi {
  Future<UpcmdbCall> lookupGtin(String gtin);
}

class UpcmdbClient implements UpcmdbApi {
  UpcmdbClient(this._client);

  final DioClient _client;

  @override
  Future<UpcmdbCall> lookupGtin(String gtin) async {
    if (gtin.length == 13) {
      final ean = await _fetch('/v1/lookup/ean/$gtin');
      if (ean is UpcmdbNotFound && gtin.startsWith('0')) {
        return _fetch('/v1/lookup/${gtin.substring(1)}');
      }
      return ean;
    }
    if (gtin.length == 12) {
      final upc = await _fetch('/v1/lookup/$gtin');
      if (upc is UpcmdbNotFound) {
        return _fetch('/v1/lookup/ean/0$gtin');
      }
      return upc;
    }
    return const UpcmdbNotFound();
  }

  Future<UpcmdbCall> _fetch(String path) async {
    try {
      final response = await _client.get<dynamic>(path);
      return _parse(response.data);
    } on MovieNotFoundException {
      return const UpcmdbNotFound();
    } on BarcodeNotFoundException {
      return const UpcmdbNotFound();
    } on RateLimitException {
      return const UpcmdbFailed('rate_limit');
    } on NoInternetException {
      return const UpcmdbFailed('offline');
    } on InvalidApiConfigException {
      return const UpcmdbFailed('auth');
    } on ApiUnavailableException {
      return const UpcmdbFailed('unavailable');
    } on AppException {
      return const UpcmdbFailed('error');
    } on FormatException {
      return const UpcmdbFailed('invalid');
    }
  }

  UpcmdbCall _parse(dynamic data) {
    if (data is List) {
      if (data.isEmpty) return const UpcmdbNotFound();
      final first = data.first;
      if (first is! Map) return const UpcmdbFailed('invalid');
      data = Map<String, dynamic>.from(first);
    }
    if (data is String) {
      try {
        data = jsonDecode(data);
      } on FormatException {
        return const UpcmdbFailed('invalid');
      }
    }
    if (data is! Map) return const UpcmdbFailed('invalid');
    final record = UpcmdbRecord.fromJson(Map<String, dynamic>.from(data));
    if (record.title.isEmpty) return const UpcmdbNotFound();
    return UpcmdbFound(record);
  }
}

String? normalizeImdbId(String? raw) {
  if (raw == null) return null;
  final trimmed = raw.trim();
  if (trimmed.isEmpty) return null;
  final prefixed = RegExp(r'tt\d{5,}', caseSensitive: false).firstMatch(trimmed);
  if (prefixed != null) return prefixed.group(0)!.toLowerCase();
  if (RegExp(r'^\d{5,}$').hasMatch(trimmed)) return 'tt$trimmed';
  return null;
}

int? _year(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value.trim());
  return null;
}

String? _text(dynamic value) {
  if (value is! String) return null;
  final trimmed = value.trim();
  return trimmed.isEmpty ? null : trimmed;
}

String? _mediaType(String? raw) {
  if (raw == null) return null;
  final value = raw.toLowerCase();
  if (value.contains('tv') || value.contains('series') || value.contains('show')) {
    return 'tv';
  }
  if (value.contains('movie') || value.contains('film')) return 'movie';
  return null;
}

String? mapPhysicalFormat(String? raw) {
  if (raw == null) return null;
  final value = raw.toLowerCase();
  if (value.contains('4k') || value.contains('uhd') || value.contains('ultra')) {
    return 'uhd_4k';
  }
  if (value.contains('blu')) return 'blu_ray';
  if (value.contains('dvd')) return 'dvd';
  return raw.trim().isEmpty ? null : raw.trim();
}
