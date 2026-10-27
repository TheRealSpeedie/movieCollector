import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/features/server/data/certificate_pins.dart';
import 'package:movie_shelf/features/server/data/pairing_link.dart';
import 'package:movie_shelf/features/server/data/pairing_service.dart';
import 'package:movie_shelf/features/server/data/server_client.dart';
import 'package:movie_shelf/features/server/data/server_credentials.dart';

import '../features/server/support/fakes.dart';

final serverUrl = Platform.environment['MOVIESHELF_IT_URL'];
final skipReason = serverUrl == null
    ? 'Run movieshelf_server/scripts/flutter-integration.ps1 to start a real server.'
    : null;

class Admin {
  Admin(this._cookie);

  final String _cookie;
  final _dio = Dio(BaseOptions(validateStatus: (_) => true));

  static Future<Admin> login() async {
    // Like the apps: trust the server certificate named in pairing codes.
    CertificatePins.install();
    final dio = Dio();
    final response = await dio.post<dynamic>(
      '$serverUrl/api/auth/login',
      data: {
        'username': Platform.environment['MOVIESHELF_IT_ADMIN'],
        'password': Platform.environment['MOVIESHELF_IT_PASSWORD'],
      },
      options: Options(headers: {'X-MovieShelf-Client': 'integration'}),
    );
    final cookie = response.headers['set-cookie']!.first.split(';').first;
    return Admin(cookie);
  }

  Future<dynamic> send(String method, String path, [Object? body]) async {
    final response = await _dio.request<dynamic>(
      '$serverUrl$path',
      data: body,
      options: Options(
        method: method,
        headers: {'Cookie': _cookie, 'X-MovieShelf-Client': 'integration'},
      ),
    );
    if (response.statusCode! >= 400) {
      throw StateError('$method $path -> ${response.statusCode}');
    }
    return response.data;
  }

  Future<String> newLinkText() async =>
      ((await send('POST', '/api/pairing/sessions')) as Map)['link'] as String;

  Future<PairingLink> newLink() async => PairingLink.parse(await newLinkText());
}

PairingService pairing() => PairingService(
  dio: buildServerDio(),
  pollInterval: const Duration(milliseconds: 200),
  patience: const Duration(seconds: 20),
);

Future<ServerCredentials> pair(
  PairingLink link, {
  String? username = 'owner',
  String? password,
  String name = 'Test phone',
}) => pairing().pair(
  link,
  deviceName: name,
  username: username,
  password: username == null
      ? null
      : password ?? Platform.environment['MOVIESHELF_IT_PASSWORD'],
);

ServerClient clientFor(
  ServerCredentials credentials, {
  MemoryStore? store,
  void Function()? onRevoked,
}) => ServerClient(
  credentials: credentials,
  store: store ?? MemoryStore(credentials),
  discovery: FakeDiscovery(),
  onRevoked: onRevoked ?? () {},
);

Future<Uint8List> fetchBytes(
  ServerClient client,
  String path, {
  Map<String, String> extra = const {},
}) async {
  final response = await Dio().get<List<int>>(
    client.url(path),
    options: Options(
      responseType: ResponseType.bytes,
      headers: {...await client.authHeaders(), ...extra},
    ),
  );
  return Uint8List.fromList(response.data!);
}

Future<String> fetchText(ServerClient client, String path) async =>
    String.fromCharCodes(await fetchBytes(client, path));
