import 'dart:convert';

class ServerCredentials {
  const ServerCredentials({
    required this.serverId,
    required this.serverName,
    required this.host,
    required this.port,
    required this.tls,
    required this.fingerprint,
    required this.deviceId,
    required this.refreshToken,
    required this.userId,
    required this.username,
    required this.role,
    this.securePort,
    this.certificateSha256,
  });

  final String serverId;
  final String serverName;
  final String host;
  final int port;
  final bool tls;
  final String fingerprint;
  final String deviceId;
  final String refreshToken;
  final int userId;
  final String username;
  final String role;

  /// HTTPS port and certificate SHA-256 of the server; with both known all
  /// traffic is encrypted and the certificate is pinned (CertificatePins).
  final int? securePort;
  final String? certificateSha256;

  bool get secure => securePort != null && certificateSha256 != null;

  String get baseUrl =>
      secure ? 'https://$host:$securePort' : 'http://$host:$port';

  ServerCredentials copyWith({
    String? host,
    int? port,
    String? refreshToken,
    int? securePort,
    String? certificateSha256,
    int? userId,
    String? username,
    String? role,
  }) => ServerCredentials(
    serverId: serverId,
    serverName: serverName,
    host: host ?? this.host,
    port: port ?? this.port,
    tls: tls,
    fingerprint: fingerprint,
    deviceId: deviceId,
    refreshToken: refreshToken ?? this.refreshToken,
    userId: userId ?? this.userId,
    username: username ?? this.username,
    role: role ?? this.role,
    securePort: securePort ?? this.securePort,
    certificateSha256: certificateSha256 ?? this.certificateSha256,
  );

  String encode() => jsonEncode({
    'serverId': serverId,
    'serverName': serverName,
    'host': host,
    'port': port,
    'tls': tls,
    'fingerprint': fingerprint,
    'deviceId': deviceId,
    'refreshToken': refreshToken,
    'userId': userId,
    'username': username,
    'role': role,
    'securePort': securePort,
    'certificateSha256': certificateSha256,
  });

  static ServerCredentials? decode(String? raw) {
    if (raw == null) return null;
    try {
      final json = jsonDecode(raw) as Map<String, dynamic>;
      return ServerCredentials(
        serverId: json['serverId'] as String,
        serverName: json['serverName'] as String,
        host: json['host'] as String,
        port: json['port'] as int,
        tls: json['tls'] as bool,
        fingerprint: json['fingerprint'] as String,
        deviceId: json['deviceId'] as String,
        refreshToken: json['refreshToken'] as String,
        userId: json['userId'] as int,
        username: json['username'] as String,
        role: json['role'] as String,
        securePort: json['securePort'] as int?,
        certificateSha256: json['certificateSha256'] as String?,
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
