import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:movie_shelf/features/server/data/credential_store.dart';
import 'package:movie_shelf/features/server/data/server_credentials.dart';
import 'package:movie_shelf/features/server/data/server_discovery.dart';

typedef Handler = FutureOr<ResponseBody> Function(RequestOptions options);

class FakeAdapter implements HttpClientAdapter {
  FakeAdapter(this.handler);

  final Handler handler;
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return handler(options);
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody jsonBody(Object? body, [int status = 200]) =>
    ResponseBody.fromString(
      jsonEncode(body),
      status,
      headers: {
        Headers.contentTypeHeader: ['application/json'],
      },
    );

ResponseBody unreachable(RequestOptions options) =>
    throw DioException.connectionError(
      requestOptions: options,
      reason: 'offline',
    );

Dio fakeDio(Handler handler) {
  final dio = Dio();
  dio.httpClientAdapter = FakeAdapter(handler);
  return dio;
}

class MemoryStore implements CredentialStore {
  MemoryStore([this.value]);

  ServerCredentials? value;

  @override
  Future<ServerCredentials?> load() async => value;

  @override
  Future<void> save(ServerCredentials credentials) async => value = credentials;

  @override
  Future<void> clear() async => value = null;
}

class FakeDiscovery implements ServerDiscovery {
  FakeDiscovery([this.servers = const []]);

  List<DiscoveredServer> servers;
  int calls = 0;

  @override
  Future<List<DiscoveredServer>> discover({
    Duration timeout = const Duration(seconds: 4),
  }) async {
    calls++;
    return servers;
  }
}

ServerCredentials sampleCredentials({
  String host = '192.168.1.10',
  String refreshToken = 'refresh-1',
}) => ServerCredentials(
  serverId: 'server-1',
  serverName: 'Wohnzimmer',
  host: host,
  port: 8096,
  tls: false,
  fingerprint:
      '62dad5bb09cd5a45a09f25dad719d56858c51ff993415162f3cfddbd8b80d078',
  deviceId: '11111111-2222-3333-4444-555555555555',
  refreshToken: refreshToken,
  userId: 1,
  username: 'owner',
  role: 'Admin',
);

final _seed = List<int>.generate(32, (i) => i + 7);

Future<Map<String, Object?>> identityResponse(String nonce) async {
  final ed = Ed25519();
  final pair = await ed.newKeyPairFromSeed(_seed);
  final publicKey = (await pair.extractPublicKey()).bytes;
  final signature = await ed.sign(
    utf8.encode('movieshelf-identity|$nonce'),
    keyPair: pair,
  );
  return {
    'serverId': 'server-1',
    'name': 'Wohnzimmer',
    'version': '1.0.0',
    'publicKey': base64.encode(publicKey),
    'fingerprint': sampleCredentials().fingerprint,
    'signature': base64.encode(signature.bytes),
    'setupComplete': true,
    'secure': false,
  };
}
