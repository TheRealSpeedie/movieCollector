import 'dart:async';

import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import 'credential_store.dart';
import 'certificate_pins.dart';
import 'server_credentials.dart';
import 'server_discovery.dart';
import 'server_identity.dart';

Dio buildServerDio() => Dio(
  BaseOptions(
    connectTimeout: const Duration(seconds: 6),
    receiveTimeout: const Duration(seconds: 45),
    headers: {'Accept': 'application/json'},
  ),
);

class ServerClient {
  ServerClient({
    required ServerCredentials credentials,
    required CredentialStore store,
    required ServerDiscovery discovery,
    required this.onRevoked,
    Dio? dio,
    DateTime Function()? now,
  }) : _credentials = credentials,
       _store = store,
       _discovery = discovery,
       _dio = dio ?? buildServerDio(),
       _now = now ?? DateTime.now {
    _pin(credentials);
  }

  static void _pin(ServerCredentials c) {
    if (c.secure) {
      CertificatePins.instance.pin(c.host, c.securePort!, c.certificateSha256!);
    }
  }

  /// Pairings made before the server offered HTTPS learn its certificate from
  /// the signed identity response and switch to HTTPS. Best effort.
  Future<void> upgradeToHttps() async {
    if (_credentials.secure) return;
    try {
      final identity = await verifyServerIdentity(
        _dio,
        _credentials.baseUrl,
        _credentials.fingerprint,
      );
      if (identity.securePort == null || identity.certificateSha256 == null) {
        return;
      }
      _credentials = _credentials.copyWith(
        securePort: identity.securePort,
        certificateSha256: identity.certificateSha256,
      );
      _pin(_credentials);
      await _store.save(_credentials);
    } on AppException {
      return;
    }
  }

  static const _margin = Duration(seconds: 30);

  final CredentialStore _store;
  final ServerDiscovery _discovery;
  final Dio _dio;
  final DateTime Function() _now;
  final void Function() onRevoked;

  ServerCredentials _credentials;
  String? _accessToken;
  DateTime _expiresAt = DateTime.fromMillisecondsSinceEpoch(0);
  Future<void>? _refreshing;

  ServerCredentials get credentials => _credentials;

  String url(String path) => '${_credentials.baseUrl}$path';

  Future<Map<String, String>> authHeaders() async {
    await _ensureToken();
    return {'Authorization': 'Bearer $_accessToken'};
  }

  Future<String> accessToken() async {
    await _ensureToken();
    return _accessToken!;
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _send('GET', path, query: query);

  Future<dynamic> post(String path, {Object? body}) =>
      _send('POST', path, body: body);

  Future<dynamic> put(String path, {Object? body}) =>
      _send('PUT', path, body: body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(
    String method,
    String path, {
    Map<String, dynamic>? query,
    Object? body,
  }) async {
    try {
      return await _attempt(method, path, query, body);
    } on ServerUnreachableException {
      if (!await _relocate()) rethrow;
      return _attempt(method, path, query, body);
    }
  }

  Future<dynamic> _attempt(
    String method,
    String path,
    Map<String, dynamic>? query,
    Object? body, {
    bool retried = false,
  }) async {
    await _ensureToken();
    try {
      final response = await _dio.request<dynamic>(
        url(path),
        data: body,
        queryParameters: query,
        options: Options(
          method: method,
          headers: {'Authorization': 'Bearer $_accessToken'},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      if (e.response?.statusCode == 401 && !retried) {
        _accessToken = null;
        return _attempt(method, path, query, body, retried: true);
      }
      throw _map(e);
    }
  }

  Future<void> _ensureToken() {
    if (_accessToken != null && _now().isBefore(_expiresAt.subtract(_margin))) {
      return Future.value();
    }
    return _refreshing ??= _refresh().whenComplete(() => _refreshing = null);
  }

  Future<void> _refresh() async {
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        url('/api/auth/refresh'),
        data: {
          'deviceId': _credentials.deviceId,
          'refreshToken': _credentials.refreshToken,
        },
      );
      final data = response.data!;
      _accessToken = data['accessToken'] as String;
      _expiresAt = _now().add(Duration(seconds: data['expiresIn'] as int));
      _credentials = _credentials.copyWith(
        refreshToken: data['refreshToken'] as String,
      );
      await _store.save(_credentials);
    } on DioException catch (e) {
      if (e.response?.statusCode == 401) {
        await _store.clear();
        onRevoked();
        throw const ServerRevokedException();
      }
      throw _map(e);
    }
  }

  Future<bool> _relocate() async {
    final servers = await _discovery.discover(
      timeout: const Duration(seconds: 3),
    );
    final match = servers
        .where((s) => s.serverId == _credentials.serverId)
        .firstOrNull;
    if (match == null ||
        (match.host == _credentials.host && match.port == _credentials.port)) {
      return false;
    }
    ServerIdentityInfo identity;
    try {
      identity = await verifyServerIdentity(
        _dio,
        match.baseUrl,
        _credentials.fingerprint,
      );
    } on AppException {
      return false;
    }
    _credentials = _credentials.copyWith(
      host: match.host,
      port: match.port,
      securePort: identity.securePort,
      certificateSha256: identity.certificateSha256,
    );
    _pin(_credentials);
    _accessToken = null;
    await _store.save(_credentials);
    return true;
  }

  static AppException _map(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return const ServerUnreachableException();
      default:
        final status = e.response?.statusCode ?? 0;
        final data = e.response?.data;
        final message = data is Map && data['error'] is String
            ? data['error'] as String
            : status == 429
            ? 'Zu viele Anfragen. Bitte warte einen Moment.'
            : 'Der Server hat die Anfrage abgelehnt.';
        return ServerRejectedException(message, status);
    }
  }
}
