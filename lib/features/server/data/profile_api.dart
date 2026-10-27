import 'server_client.dart';
import 'server_credentials.dart';

class ServerProfile {
  const ServerProfile({
    required this.id,
    required this.name,
    required this.hasPin,
    required this.maxAgeRating,
    required this.current,
  });

  factory ServerProfile.fromJson(Map<String, dynamic> json) => ServerProfile(
    id: json['id'] as int,
    name: json['name'] as String,
    hasPin: json['hasPin'] as bool? ?? false,
    maxAgeRating: json['maxAgeRating'] as int?,
    current: json['current'] as bool? ?? false,
  );

  final int id;
  final String name;
  final bool hasPin;
  final int? maxAgeRating;
  final bool current;
}

/// Household profiles of the server. Switching moves this device to another
/// profile; the returned credentials replace the stored ones.
class ProfileApi {
  ProfileApi(this._client);

  final ServerClient _client;

  Future<List<ServerProfile>> profiles() async => [
    for (final p in await _client.get('/api/profiles') as List)
      ServerProfile.fromJson(p as Map<String, dynamic>),
  ];

  Future<ServerCredentials> switchTo(int profileId, {String? pin}) async {
    final response =
        await _client.post(
              '/api/profiles/$profileId/switch',
              body: {'pin': pin},
            )
            as Map<String, dynamic>;
    return _client.credentials.copyWith(
      refreshToken: response['refreshToken'] as String,
      userId: response['userId'] as int,
      username: response['username'] as String,
      role: response['role'] as String,
    );
  }
}
