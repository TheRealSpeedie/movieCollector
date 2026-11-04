import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/features/server/data/pairing_crypto.dart';

const _id = '11111111-2222-3333-4444-555555555555';
const _secret = 'AQIDBAUGBwgJCgsMDQ4PEA';

/// Expected values come from the server (Speednema.Core PairingCrypto and
/// ServerIdentity), regenerated after the labels were renamed from
/// movieshelf-* to speednema-*. Never derive them from this Dart code.
void main() {
  test('derives the same keys as the server', () async {
    final keys = await PairingCrypto.derive(
      PairingCrypto.fromBase64Url(_secret),
    );
    expect(
      base64.encode(keys.authKey),
      'tSCY2IZCMCRT9h3r56fE2BPNCGv8RIZK24nNiQZRTwk=',
    );
    expect(
      base64.encode(keys.encKey),
      'tsQNZ4Ftc0n5N0zSMVXxEozYA3kTQ+SEgAPDtSpjtgU=',
    );
  });

  test('computes the same proofs as the server', () async {
    final keys = await PairingCrypto.derive(
      PairingCrypto.fromBase64Url(_secret),
    );
    expect(
      await PairingCrypto.proof(keys.authKey, 'claim|$_id|Pixel|phone'),
      'EodJzNF+lPJ3WSFNmf6B7zkPr3erad2VcE3+ByuA4rM=',
    );
    expect(
      await PairingCrypto.proof(keys.authKey, 'poll|$_id'),
      'BsBKqK4rbfsmHgd+p/+vMDMlYEanwfe0+SC03KXgEEY=',
    );
  });

  test('opens a value sealed by the server and rejects tampering', () async {
    final keys = await PairingCrypto.derive(
      PairingCrypto.fromBase64Url(_secret),
    );
    const sealed =
        'uKhr8+YKsW4FfhqYn7b5YY7RA+dJu5r65+9jOTuic9fYBlo8lUVLNT0KVkJpJMKcjJegWANAb/UWOKAaxQ8O5A==';
    final plain = await PairingCrypto.open(
      keys.encKey,
      sealed,
      'credential|$_id',
    );
    expect(utf8.decode(plain!), '{"username":"owner","password":"pw"}');
    expect(await PairingCrypto.open(keys.encKey, sealed, 'login|$_id'), isNull);
    expect(await PairingCrypto.open(keys.encKey, 'AAAA', 'x'), isNull);
    expect(await PairingCrypto.open(keys.encKey, '%%%', 'x'), isNull);
  });

  test('seals values the server can open', () async {
    final keys = await PairingCrypto.derive(
      PairingCrypto.fromBase64Url(_secret),
    );
    final sealed = await PairingCrypto.seal(
      keys.encKey,
      utf8.encode('hello'),
      'login|$_id',
    );
    final plain = await PairingCrypto.open(keys.encKey, sealed, 'login|$_id');
    expect(utf8.decode(plain!), 'hello');
  });

  test('verifies the server identity signature and fingerprint', () async {
    final publicKey = base64.decode(
      'oYDF5nG7vs82CONrCkgWXJvDZCjJgLvaoDins17I+UM=',
    );
    final signature = base64.decode(
      'v/Osnl3/uRd2+5wGzoTo4t/VJ2j88LNmICS4704dpg2us2rIpWK/U7AmZyjHRX6X7zaeRPpJwb3PlbWo4rEnCg==',
    );
    const fingerprint =
        'c703fa2090cf685cadda71c8d963c035c680f5e8456e9e55c57f58d049e27b06';

    Future<bool> check(String nonce, String fp) => PairingCrypto.verifyIdentity(
      publicKey: publicKey,
      signature: signature,
      nonce: nonce,
      expectedFingerprint: fp,
    );

    expect(await check('abc123', fingerprint), isTrue);
    expect(await check('other', fingerprint), isFalse);
    expect(await check('abc123', 'ff${fingerprint.substring(2)}'), isFalse);
  });
}
