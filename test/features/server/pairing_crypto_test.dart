import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/features/server/data/pairing_crypto.dart';

const _id = '11111111-2222-3333-4444-555555555555';
const _secret = 'AQIDBAUGBwgJCgsMDQ4PEA';

void main() {
  test('derives the same keys as the server', () async {
    final keys = await PairingCrypto.derive(
      PairingCrypto.fromBase64Url(_secret),
    );
    expect(
      base64.encode(keys.authKey),
      'TxdwmkZ5NPvSA22K/32vEeKt4PpnYTXbGCu97YEIwGc=',
    );
    expect(
      base64.encode(keys.encKey),
      '8FbOxavnQt/lj23G2MeqlL0FDo6SHbAKW1jpieVHaxo=',
    );
  });

  test('computes the same proofs as the server', () async {
    final keys = await PairingCrypto.derive(
      PairingCrypto.fromBase64Url(_secret),
    );
    expect(
      await PairingCrypto.proof(keys.authKey, 'claim|$_id|Pixel|phone'),
      'ZOI63+a5Awse4+Fm7H0v6e0x9yDXUcYdp9PQ6Eq/UtE=',
    );
    expect(
      await PairingCrypto.proof(keys.authKey, 'poll|$_id'),
      'd5dlEnzmmAZP68rIIG4ZoFnQCsRedwPd2V+qof7/zNQ=',
    );
  });

  test('opens a value sealed by the server and rejects tampering', () async {
    final keys = await PairingCrypto.derive(
      PairingCrypto.fromBase64Url(_secret),
    );
    const sealed =
        'H1whAfo0929U+Hg2qXxQBtbEQSyBgldJFMvjgJxu1qTVjonsC5RP9g9sJOFMnTBu7Lglxqx636/0TJS3iHMOrA==';
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
      'ANBaHR6iUTltVXr71FiLPG2Z2+uXL+0QoyVi6ibc3Po=',
    );
    final signature = base64.decode(
      'sHv+2ZslgsG8TuyQa+8YEQ0TtyTRhN2aiaNxLQFxRbjLQSqxrKG390DQlkp9YTyKUqSG5r7BWhxO9CBQOPrmDQ==',
    );
    const fingerprint =
        '62dad5bb09cd5a45a09f25dad719d56858c51ff993415162f3cfddbd8b80d078';

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
