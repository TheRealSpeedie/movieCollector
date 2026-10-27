class Env {
  Env._();

  static const String tmdbAccessToken = String.fromEnvironment(
    'TMDB_ACCESS_TOKEN',
  );
  static const String upcItemDbUserKey = String.fromEnvironment(
    'UPCITEMDB_USER_KEY',
  );
  static const String upcItemDbKeyType = String.fromEnvironment(
    'UPCITEMDB_KEY_TYPE',
    defaultValue: '3scale',
  );
  static const String upcmdbApiKey = String.fromEnvironment('UPCMDB_API_KEY');

  /// Address of Movie Shelf Cloud, for example https://cloud.example.org.
  /// Builds without it offer only local storage and the own server.
  static const String cloudUrl = String.fromEnvironment('CLOUD_URL');

  static bool get isTmdbConfigured => tmdbAccessToken.trim().isNotEmpty;
  static bool get isUpcItemDbProConfigured =>
      upcItemDbUserKey.trim().isNotEmpty;
  static bool get isUpcmdbConfigured => upcmdbApiKey.trim().isNotEmpty;
  static bool get isCloudConfigured => cloudUrl.trim().isNotEmpty;
}
