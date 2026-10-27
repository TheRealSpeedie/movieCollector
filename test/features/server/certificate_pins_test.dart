import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/features/server/data/pairing_crypto.dart';
import 'package:movie_shelf/features/server/data/server_credentials.dart';

void main() {
  test('credentials with a pinned certificate use https', () {
    const plain = ServerCredentials(
      serverId: 's',
      serverName: 'n',
      host: '192.168.1.20',
      port: 8420,
      tls: false,
      fingerprint: 'f',
      deviceId: 'd',
      refreshToken: 'r',
      userId: 1,
      username: 'u',
      role: 'User',
    );
    expect(plain.baseUrl, 'http://192.168.1.20:8420');

    final secure = plain.copyWith(securePort: 8421, certificateSha256: 'aa');
    expect(secure.baseUrl, 'https://192.168.1.20:8421');
    final restored = ServerCredentials.decode(secure.encode())!;
    expect(restored.securePort, 8421);
    expect(restored.certificateSha256, 'aa');
  });

  test('older stored credentials stay on plain http', () {
    final legacy = ServerCredentials.decode(
      jsonEncode({
        'serverId': 's',
        'serverName': 'n',
        'host': 'h',
        'port': 8096,
        'tls': false,
        'fingerprint': 'f',
        'deviceId': 'd',
        'refreshToken': 'r',
        'userId': 1,
        'username': 'u',
        'role': 'User',
      }),
    )!;
    expect(legacy.secure, isFalse);
    expect(legacy.baseUrl, 'http://h:8096');
  });

  test('a signature over another certificate is rejected', () async {
    final key = List<int>.filled(32, 1);
    expect(
      await PairingCrypto.verifyIdentity(
        publicKey: key,
        signature: List<int>.filled(64, 0),
        nonce: 'abc',
        expectedFingerprint: await PairingCrypto.fingerprint(key),
        certificateSha256: 'ab' * 32,
      ),
      isFalse,
    );
  });
}
