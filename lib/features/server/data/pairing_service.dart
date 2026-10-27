import 'dart:async';
import 'dart:convert';

import 'package:dio/dio.dart';

import '../../../core/errors/app_exception.dart';
import 'pairing_crypto.dart';
import 'pairing_link.dart';
import 'server_credentials.dart';
import 'server_identity.dart';

enum PairingProgress { verifying, claiming, waitingForApproval }

class PairingService {
  PairingService({
    required this.dio,
    this.pollInterval = const Duration(seconds: 2),
    this.patience = const Duration(minutes: 3),
  });

  final Dio dio;
  final Duration pollInterval;
  final Duration patience;

  Future<ServerCredentials> pair(
    PairingLink link, {
    required String deviceName,
    String? username,
    String? password,
    void Function(PairingProgress progress)? onProgress,
    bool Function()? isCancelled,
  }) async {
    onProgress?.call(PairingProgress.verifying);
    link.pinCertificate();
    final identity = await verifyServerIdentity(
      dio,
      link.baseUrl,
      link.fingerprint,
    );
    if (link.serverId.isNotEmpty && identity.serverId != link.serverId) {
      throw const PairingFailedException(
        'Die Server-Kennung stimmt nicht mit dem Kopplungscode überein.',
      );
    }

    final keys = await PairingCrypto.derive(link.secret);
    final sessionId = link.sessionId;
    final sealedLogin = username == null || username.isEmpty
        ? null
        : await PairingCrypto.seal(
            keys.encKey,
            utf8.encode(
              jsonEncode({'username': username, 'password': password ?? ''}),
            ),
            'login|$sessionId',
          );

    onProgress?.call(PairingProgress.claiming);
    var result = await _claim(
      link,
      keys,
      deviceName: deviceName,
      sealedLogin: sealedLogin,
    );

    final deadline = DateTime.now().add(patience);
    while (result.status == 'waiting') {
      onProgress?.call(PairingProgress.waitingForApproval);
      if ((isCancelled?.call() ?? false) || DateTime.now().isAfter(deadline)) {
        throw const PairingFailedException(
          'Die Kopplung wurde nicht rechtzeitig bestätigt. Erzeuge im Dashboard einen neuen Code.',
        );
      }
      await Future<void>.delayed(pollInterval);
      result = await _poll(link, keys);
    }

    if (result.status == 'denied') {
      throw const PairingFailedException(
        'Die Kopplung wurde im Dashboard abgelehnt.',
      );
    }
    return _credentials(link, keys, result);
  }

  Future<TvPairing> startTv(
    String baseUrl,
    String deviceName, {
    String? fingerprint,
  }) async {
    final identity = await verifyServerIdentity(dio, baseUrl, fingerprint);
    try {
      final response = await dio.post<Map<String, dynamic>>(
        '$baseUrl/api/pairing/tv-sessions',
        data: {'deviceName': deviceName},
      );
      final data = response.data!;
      final link = PairingLink.parse(data['link'] as String);
      // This link arrived over plain HTTP; its certificate is only trusted
      // when the signed identity response names the same one.
      if (link.certificateSha256 != identity.certificateSha256) {
        throw const PairingFailedException(
          'Das Zertifikat des Servers stimmt nicht mit seiner Kennung überein.',
        );
      }
      link.pinCertificate();
      if (link.fingerprint != identity.fingerprint) {
        throw const PairingFailedException(
          'Die Server-Kennung stimmt nicht mit dem Kopplungscode überein.',
        );
      }
      return TvPairing(
        link: link,
        keys: await PairingCrypto.derive(link.secret),
        shortCode: data['shortCode'] as String,
        uri: data['link'] as String,
      );
    } on DioException catch (e) {
      throw e.response?.statusCode == 429
          ? const PairingFailedException(
              'Zu viele Fernseher warten auf eine Kopplung. Versuche es in ein paar Minuten erneut.',
            )
          : const ServerUnreachableException();
    }
  }

  Future<ServerCredentials?> pollTv(TvPairing pairing) async {
    final result = await _poll(pairing.link, pairing.keys);
    if (result.status == 'waiting') return null;
    if (result.status == 'denied') {
      throw const PairingFailedException('Die Kopplung wurde abgelehnt.');
    }
    return _credentials(pairing.link, pairing.keys, result);
  }

  Future<ServerCredentials> _credentials(
    PairingLink link,
    PairingKeys keys,
    _Result result,
  ) async {
    final sealed = result.sealedCredential;
    if (result.status != 'approved' || sealed == null) {
      throw const PairingFailedException(
        'Dieser Kopplungscode ist abgelaufen oder wurde schon verwendet.',
      );
    }

    final plain = await PairingCrypto.open(
      keys.encKey,
      sealed,
      'credential|${link.sessionId}',
    );
    if (plain == null) {
      throw const PairingFailedException(
        'Die Zugangsdaten konnten nicht entschlüsselt werden.',
      );
    }
    final bundle = jsonDecode(utf8.decode(plain)) as Map<String, dynamic>;
    return ServerCredentials(
      serverId: bundle['serverId'] as String,
      serverName: bundle['serverName'] as String,
      host: link.host,
      port: link.port,
      tls: link.tls,
      fingerprint: bundle['fingerprint'] as String,
      deviceId: bundle['deviceId'] as String,
      refreshToken: bundle['refreshToken'] as String,
      userId: bundle['userId'] as int,
      username: bundle['username'] as String,
      role: bundle['role'] as String,
      securePort: link.securePort,
      certificateSha256: link.certificateSha256,
    );
  }

  Future<_Result> _claim(
    PairingLink link,
    PairingKeys keys, {
    required String deviceName,
    required String? sealedLogin,
  }) async {
    final proof = await PairingCrypto.proof(
      keys.authKey,
      'claim|${link.sessionId}|$deviceName|phone',
    );
    return _call(
      () => dio.post<Map<String, dynamic>>(
        '${link.baseUrl}/api/pairing/claim',
        data: {
          'sessionId': link.sessionId,
          'deviceName': deviceName,
          'deviceType': 'phone',
          'proof': proof,
          'sealedLogin': sealedLogin,
        },
      ),
    );
  }

  Future<_Result> _poll(PairingLink link, PairingKeys keys) async {
    final proof = await PairingCrypto.proof(
      keys.authKey,
      'poll|${link.sessionId}',
    );
    return _call(
      () => dio.get<Map<String, dynamic>>(
        '${link.baseUrl}/api/pairing/sessions/${link.sessionId}/result',
        queryParameters: {'proof': proof},
      ),
    );
  }

  Future<_Result> _call(
    Future<Response<Map<String, dynamic>>> Function() request,
  ) async {
    try {
      final data = (await request()).data!;
      return _Result(
        data['status'] as String,
        data['sealedCredential'] as String?,
      );
    } on DioException catch (e) {
      throw switch (e.response?.statusCode) {
        401 => const PairingFailedException(
          'Benutzername oder Passwort ist falsch.',
        ),
        403 => const PairingFailedException(
          'Die Kopplungsanfrage konnte nicht bestätigt werden.',
        ),
        409 => const PairingFailedException(
          'Dieser Kopplungscode wurde schon verwendet.',
        ),
        410 => const PairingFailedException(
          'Dieser Kopplungscode ist abgelaufen. Erzeuge im Dashboard einen neuen.',
        ),
        429 => const PairingFailedException(
          'Zu viele Versuche. Warte einen Moment und versuche es erneut.',
        ),
        _ => const ServerUnreachableException(),
      };
    }
  }
}

class TvPairing {
  const TvPairing({
    required this.link,
    required this.keys,
    required this.shortCode,
    required this.uri,
  });

  final String uri;
  final PairingLink link;
  final PairingKeys keys;
  final String shortCode;
}

class _Result {
  const _Result(this.status, this.sealedCredential);

  final String status;
  final String? sealedCredential;
}
