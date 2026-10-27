import '../../../core/errors/app_exception.dart';
import 'certificate_pins.dart';
import 'pairing_crypto.dart';

class PairingLink {
  const PairingLink({
    required this.mode,
    required this.sessionId,
    required this.secret,
    required this.host,
    required this.port,
    required this.tls,
    required this.fingerprint,
    required this.serverId,
    required this.serverName,
    this.securePort,
    this.certificateSha256,
  });

  final String mode;
  final String sessionId;
  final List<int> secret;
  final String host;
  final int port;
  final bool tls;
  final String fingerprint;
  final String serverId;
  final String serverName;

  /// HTTPS port and certificate from the QR code, which is the trusted
  /// channel: pairing already runs encrypted when they are present.
  final int? securePort;
  final String? certificateSha256;

  bool get secure => securePort != null && certificateSha256 != null;

  String get baseUrl =>
      secure ? 'https://$host:$securePort' : 'http://$host:$port';

  /// Trusts the certificate named in the QR code for this server.
  void pinCertificate() {
    if (secure) {
      CertificatePins.instance.pin(host, securePort!, certificateSha256!);
    }
  }

  static bool looksLikePairingLink(String value) =>
      value.trim().startsWith('movieshelf://pair');

  static PairingLink parse(String value) {
    final uri = Uri.tryParse(value.trim());
    final query = uri?.queryParameters ?? const {};
    if (uri == null ||
        uri.scheme != 'movieshelf' ||
        uri.host != 'pair' ||
        query['v'] != '1') {
      throw const PairingFailedException(
        'Das ist kein Movie-Shelf-Kopplungscode.',
      );
    }
    final port = int.tryParse(query['p'] ?? '');
    final sessionId = query['sid'];
    final secret = query['s'];
    final host = query['h'];
    final fingerprint = query['fp'];
    if (port == null ||
        sessionId == null ||
        secret == null ||
        host == null ||
        host.isEmpty ||
        fingerprint == null) {
      throw const PairingFailedException(
        'Der Kopplungscode ist unvollständig. Erzeuge im Dashboard einen neuen.',
      );
    }
    try {
      return PairingLink(
        mode: query['m'] ?? 'mobile',
        sessionId: sessionId,
        secret: PairingCrypto.fromBase64Url(secret),
        host: host,
        port: port,
        tls: query['tls'] == '1',
        fingerprint: fingerprint,
        serverId: query['id'] ?? '',
        serverName: query['n'] ?? 'Movie Shelf',
        securePort: int.tryParse(query['sp'] ?? ''),
        certificateSha256: query['cfp'],
      );
    } on FormatException {
      throw const PairingFailedException(
        'Der Kopplungscode ist beschädigt. Erzeuge im Dashboard einen neuen.',
      );
    }
  }
}
