import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'server_credentials.dart';

abstract class CredentialStore {
  Future<ServerCredentials?> load();
  Future<void> save(ServerCredentials credentials);
  Future<void> clear();
}

class SecureCredentialStore implements CredentialStore {
  SecureCredentialStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'movieshelf.server';

  final FlutterSecureStorage _storage;

  @override
  Future<ServerCredentials?> load() async =>
      ServerCredentials.decode(await _storage.read(key: _key));

  @override
  Future<void> save(ServerCredentials credentials) =>
      _storage.write(key: _key, value: credentials.encode());

  @override
  Future<void> clear() => _storage.delete(key: _key);
}
