import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../core/errors/app_exception.dart';

/// The signed-in Movie Shelf Cloud account on this device.
class CloudSession {
  const CloudSession({
    required this.email,
    required this.deviceId,
    required this.refreshToken,
  });

  factory CloudSession.fromJson(Map<String, dynamic> json) => CloudSession(
    email: json['email'] as String,
    deviceId: json['deviceId'] as String,
    refreshToken: json['refreshToken'] as String,
  );

  final String email;
  final String deviceId;
  final String refreshToken;

  Map<String, Object?> toJson() => {
    'email': email,
    'deviceId': deviceId,
    'refreshToken': refreshToken,
  };
}

abstract interface class CloudSessionStore {
  Future<CloudSession?> load();
  Future<void> save(CloudSession session);
  Future<void> clear();
}

class SecureCloudSessionStore implements CloudSessionStore {
  SecureCloudSessionStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'movieshelf.cloud';

  final FlutterSecureStorage _storage;

  @override
  Future<CloudSession?> load() async {
    final raw = await _storage.read(key: _key);
    if (raw == null) return null;
    try {
      return CloudSession.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on Object {
      return null;
    }
  }

  @override
  Future<void> save(CloudSession session) =>
      _storage.write(key: _key, value: jsonEncode(session.toJson()));

  @override
  Future<void> clear() => _storage.delete(key: _key);
}

/// Talks to Movie Shelf Cloud. Access tokens live 15 minutes and are renewed
/// with the rotating refresh token, which is saved after every rotation.
class CloudClient {
  CloudClient({
    required this.baseUrl,
    required CloudSessionStore store,
    CloudSession? session,
    this.onSignedOut,
    Dio? dio,
  }) : _store = store,
       _session = session,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               connectTimeout: const Duration(seconds: 10),
               receiveTimeout: const Duration(seconds: 45),
               headers: {'Accept': 'application/json'},
             ),
           );

  final String baseUrl;
  final CloudSessionStore _store;
  final Dio _dio;
  final void Function()? onSignedOut;

  CloudSession? _session;
  String? _accessToken;
  DateTime _expiresAt = DateTime.fromMillisecondsSinceEpoch(0);
  Future<void>? _refreshing;

  CloudSession? get session => _session;

  Future<CloudSession> signUp(String email, String password, String device) =>
      _start('/api/accounts', email, password, device);

  Future<CloudSession> signIn(String email, String password, String device) =>
      _start('/api/sessions', email, password, device);

  Future<CloudSession> _start(
    String path,
    String email,
    String password,
    String device,
  ) async {
    final body =
        await _request('POST', path, {
              'email': email.trim(),
              'password': password,
              'deviceName': device,
              'platform': 'app',
            }, authorized: false)
            as Map<String, dynamic>;
    return _accept(body, email.trim().toLowerCase());
  }

  Future<void> verify(String code) => _request('POST', '/api/accounts/verify', {
    'token': code,
  }, authorized: false);

  Future<void> resendVerification() =>
      _send('POST', '/api/account/verification', {});

  Future<void> forgotPassword(String email) => _request(
    'POST',
    '/api/password/forgot',
    {'email': email.trim()},
    authorized: false,
  );

  Future<void> resetPassword(String code, String password) => _request(
    'POST',
    '/api/password/reset',
    {'token': code, 'password': password},
    authorized: false,
  );

  Future<Map<String, dynamic>> account() async =>
      await get('/api/account') as Map<String, dynamic>;

  Future<List<Map<String, dynamic>>> devices() async => [
    for (final d in await get('/api/devices') as List)
      d as Map<String, dynamic>,
  ];

  Future<void> revokeDevice(String id) => _send('DELETE', '/api/devices/$id');

  Future<Map<String, dynamic>> export() async =>
      await get('/api/account/export') as Map<String, dynamic>;

  Future<void> deleteAccount(String password) async {
    await _send('DELETE', '/api/account', {'password': password});
    await _forget();
  }

  Future<void> signOut() async {
    try {
      await _send('DELETE', '/api/sessions/current');
    } on AppException {
      // Signing out locally is enough when the service cannot be reached.
    }
    await _forget();
  }

  Future<dynamic> get(String path, {Map<String, dynamic>? query}) =>
      _request('GET', path, null, query: query);

  Future<dynamic> post(String path, {Object? body}) =>
      _send('POST', path, body);

  Future<dynamic> delete(String path) => _send('DELETE', path);

  Future<dynamic> _send(String method, String path, [Object? body]) =>
      _request(method, path, body);

  Future<dynamic> _request(
    String method,
    String path,
    Object? body, {
    Map<String, dynamic>? query,
    bool authorized = true,
  }) async {
    if (authorized) await _ensureToken();
    try {
      final response = await _dio.request<dynamic>(
        '$baseUrl$path',
        data: body,
        queryParameters: query,
        options: Options(
          method: method,
          headers: {if (authorized) 'Authorization': 'Bearer $_accessToken'},
        ),
      );
      return response.data;
    } on DioException catch (e) {
      throw await _map(e, authorized);
    }
  }

  Future<CloudSession> _accept(Map<String, dynamic> body, String email) async {
    final session = CloudSession(
      email: email,
      deviceId: body['deviceId'] as String,
      refreshToken: body['refreshToken'] as String,
    );
    _session = session;
    _accessToken = body['accessToken'] as String;
    _expiresAt = DateTime.now().add(
      Duration(seconds: (body['expiresIn'] as int) - 30),
    );
    await _store.save(session);
    return session;
  }

  Future<void> _ensureToken() {
    if (_session == null) {
      throw const ServerRejectedException(
        'Melde dich bei Movie Shelf Cloud an.',
        401,
      );
    }
    if (_accessToken != null && DateTime.now().isBefore(_expiresAt)) {
      return Future.value();
    }
    // One refresh for all requests waiting at the same time; a second one
    // would use the already rotated token and sign the device out.
    return _refreshing ??= _refresh().whenComplete(() => _refreshing = null);
  }

  Future<void> _refresh() async {
    final session = _session!;
    try {
      final response = await _dio.post<Map<String, dynamic>>(
        '$baseUrl/api/sessions/refresh',
        data: {
          'deviceId': session.deviceId,
          'refreshToken': session.refreshToken,
        },
      );
      await _accept(response.data!, session.email);
    } on DioException catch (e) {
      throw await _map(e, true);
    }
  }

  Future<void> _forget() async {
    _session = null;
    _accessToken = null;
    await _store.clear();
  }

  Future<AppException> _map(DioException e, bool authorized) async {
    final status = e.response?.statusCode ?? 0;
    final data = e.response?.data;
    final message = data is Map && data['error'] is String
        ? data['error'] as String
        : null;
    if (status == 0) {
      return const CloudUnreachableException();
    }
    if (status == 401 && authorized) {
      await _forget();
      onSignedOut?.call();
      return const ServerRejectedException(
        'Dieses Gerät wurde von Movie Shelf Cloud abgemeldet. Melde dich erneut an.',
        401,
      );
    }
    if (status == 402) {
      return CloudSubscriptionException(
        message ??
            'Dein Movie-Shelf-Cloud-Abo ist abgelaufen. Deine Sammlung bleibt auf dem Gerät.',
      );
    }
    if (status == 429) {
      return const ServerRejectedException(
        'Zu viele Versuche. Warte eine Minute und versuche es dann erneut.',
        429,
      );
    }
    return ServerRejectedException(
      message ?? 'Movie Shelf Cloud hat die Anfrage abgelehnt ($status).',
      status,
    );
  }
}
