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

  String get baseUrl => '${tls ? 'https' : 'http'}://$host:$port';

  ServerCredentials copyWith({String? host, int? port, String? refreshToken}) =>
      ServerCredentials(
        serverId: serverId,
        serverName: serverName,
        host: host ?? this.host,
        port: port ?? this.port,
        tls: tls,
        fingerprint: fingerprint,
        deviceId: deviceId,
        refreshToken: refreshToken ?? this.refreshToken,
        userId: userId,
        username: username,
        role: role,
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
      );
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }
}
