import 'dart:io';

import 'package:crypto/crypto.dart';

/// Pins the self-signed HTTPS certificate of each paired Movie Shelf server.
///
/// Installed as [HttpOverrides.global] by both app entry points, so every
/// dart:io connection (the API client, SignalR, artwork) accepts a server
/// certificate only when its SHA-256 matches the one learned from the pairing
/// QR code or the signed identity response. Every other host keeps the
/// normal certificate checks.
class CertificatePins extends HttpOverrides {
  CertificatePins._();

  static final instance = CertificatePins._();

  final _pins = <String, String>{};

  static void install() => HttpOverrides.global = instance;

  void pin(String host, int port, String sha256Hex) =>
      _pins['$host:$port'] = sha256Hex.toLowerCase();

  bool matches(X509Certificate certificate, String host, int port) {
    final expected = _pins['$host:$port'];
    return expected != null &&
        sha256.convert(certificate.der).toString() == expected;
  }

  @override
  HttpClient createHttpClient(SecurityContext? context) =>
      super.createHttpClient(context)..badCertificateCallback = matches;
}
