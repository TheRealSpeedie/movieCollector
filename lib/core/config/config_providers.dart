import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'env.dart';

/// Keeps a TMDB key the user entered, for builds without one or when the
/// built-in key stops working. Stored like the server credentials.
class TmdbTokenStore {
  TmdbTokenStore([FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _key = 'speednema.tmdb';
  final FlutterSecureStorage _storage;

  Future<String?> read() async {
    final value = await _storage.read(key: _key);
    return value == null || value.trim().isEmpty ? null : value.trim();
  }

  Future<void> write(String? token) async {
    final value = token?.trim() ?? '';
    if (value.isEmpty) {
      await _storage.delete(key: _key);
    } else {
      await _storage.write(key: _key, value: value);
    }
  }
}

final tmdbTokenStoreProvider = Provider<TmdbTokenStore>(
  (ref) => TmdbTokenStore(),
);

/// The key the user entered, loaded once at startup (see main.dart).
/// Null when none was entered.
final tmdbUserTokenProvider = StateProvider<String?>((ref) => null);

/// Where the TMDB key in use comes from.
enum TmdbKeySource { user, build, none }

final tmdbKeySourceProvider = Provider<TmdbKeySource>((ref) {
  if (ref.watch(tmdbUserTokenProvider)?.trim().isNotEmpty ?? false) {
    return TmdbKeySource.user;
  }
  return Env.tmdbAccessToken.trim().isNotEmpty
      ? TmdbKeySource.build
      : TmdbKeySource.none;
});

/// The TMDB key requests use: the user's own, else the built-in one.
final tmdbTokenProvider = Provider<String>((ref) {
  final user = ref.watch(tmdbUserTokenProvider)?.trim() ?? '';
  return user.isNotEmpty ? user : Env.tmdbAccessToken.trim();
});

/// Whether this build can ask TMDB for movie information.
final tmdbConfiguredProvider = Provider<bool>(
  (ref) => ref.watch(tmdbTokenProvider).isNotEmpty,
);
