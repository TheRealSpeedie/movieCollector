import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';

class PairingKeys {
  const PairingKeys({required this.authKey, required this.encKey});

  final List<int> authKey;
  final List<int> encKey;
}

class PairingCrypto {
  PairingCrypto._();

  static final _salt = utf8.encode('movieshelf-pairing-v1');
  static final _hmac = Hmac.sha256();
  static final _gcm = AesGcm.with256bits();
  static final _hkdf = Hkdf(hmac: Hmac.sha256(), outputLength: 32);

  static Future<PairingKeys> derive(List<int> secret) async {
    Future<List<int>> expand(String info) async => (await _hkdf.deriveKey(
      secretKey: SecretKey(secret),
      nonce: _salt,
      info: utf8.encode(info),
    )).extractBytes();

    return PairingKeys(
      authKey: await expand('movieshelf-auth'),
      encKey: await expand('movieshelf-enc'),
    );
  }

  static Future<String> proof(List<int> authKey, String message) async {
    final mac = await _hmac.calculateMac(
      utf8.encode(message),
      secretKey: SecretKey(authKey),
    );
    return base64.encode(mac.bytes);
  }

  static Future<String> seal(
    List<int> encKey,
    List<int> plaintext,
    String aad,
  ) async {
    final box = await _gcm.encrypt(
      plaintext,
      secretKey: SecretKey(encKey),
      aad: utf8.encode(aad),
    );
    return base64.encode([...box.nonce, ...box.cipherText, ...box.mac.bytes]);
  }

  static Future<List<int>?> open(
    List<int> encKey,
    String sealedValue,
    String aad,
  ) async {
    try {
      final data = base64.decode(sealedValue);
      if (data.length < 28) return null;
      final box = SecretBox(
        data.sublist(12, data.length - 16),
        nonce: data.sublist(0, 12),
        mac: Mac(data.sublist(data.length - 16)),
      );
      return await _gcm.decrypt(
        box,
        secretKey: SecretKey(encKey),
        aad: utf8.encode(aad),
      );
    } on FormatException {
      return null;
    } on SecretBoxAuthenticationError {
      return null;
    }
  }

  static Future<String> fingerprint(List<int> publicKey) async =>
      _hex((await Sha256().hash(publicKey)).bytes);

  static Future<bool> verifyIdentity({
    required List<int> publicKey,
    required List<int> signature,
    required String nonce,
    required String expectedFingerprint,
    String? certificateSha256,
  }) async {
    if (await fingerprint(publicKey) != expectedFingerprint) return false;
    final signed = certificateSha256 == null
        ? nonce
        : '$nonce|$certificateSha256';
    return Ed25519().verify(
      utf8.encode('movieshelf-identity|$signed'),
      signature: Signature(
        signature,
        publicKey: SimplePublicKey(publicKey, type: KeyPairType.ed25519),
      ),
    );
  }

  static Uint8List fromBase64Url(String value) {
    final padded = value.padRight(
      value.length + (4 - value.length % 4) % 4,
      '=',
    );
    return base64Url.decode(padded);
  }

  static String _hex(List<int> bytes) =>
      bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
}
