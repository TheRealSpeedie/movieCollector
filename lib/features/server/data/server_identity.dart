import 'dart:convert';
import 'dart:math';

import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import 'pairing_crypto.dart';

class ServerIdentityInfo {
  const ServerIdentityInfo({
    required this.serverId,
    required this.name,
    required this.fingerprint,
    required this.setupComplete,
  });

  final String serverId;
  final String name;
  final String fingerprint;
  final bool setupComplete;
}

Future<ServerIdentityInfo> verifyServerIdentity(
  Dio dio,
  String baseUrl,
  String? expectedFingerprint,
) async {
  final nonce = base64Url.encode(
    List.generate(16, (_) => Random.secure().nextInt(256)),
  );
  final Map<String, dynamic> body;
  try {
    final response = await dio.get<Map<String, dynamic>>(
      '$baseUrl/api/server/identity',
      queryParameters: {'nonce': nonce},
    );
    body = response.data!;
  } on DioException {
    throw const ServerUnreachableException();
  }

  final publicKey = base64.decode(body['publicKey'] as String);
  final fingerprint =
      expectedFingerprint ?? await PairingCrypto.fingerprint(publicKey);
  final trusted = await PairingCrypto.verifyIdentity(
    publicKey: publicKey,
    signature: base64.decode(body['signature'] as String),
    nonce: nonce,
    expectedFingerprint: fingerprint,
  );
  if (!trusted) {
    throw const PairingFailedException(
      'Dieser Server konnte nicht als der erwartete Movie-Shelf-Server bestätigt werden. Die Verbindung wurde abgebrochen.',
    );
  }
  return ServerIdentityInfo(
    serverId: body['serverId'] as String,
    name: body['name'] as String,
    fingerprint: fingerprint,
    setupComplete: body['setupComplete'] as bool,
  );
}
