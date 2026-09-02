class ApiConstants {
  ApiConstants._();

  static const String tmdbBaseUrl = 'https://api.themoviedb.org/3';
  static const String tmdbImageBaseUrl = 'https://image.tmdb.org/t/p';
  static const String posterSize = 'w500';
  static const String backdropSize = 'w780';

  static const String tmdbLanguage = 'de-DE';
  static const String tmdbRegion = 'DE';
  static const String tmdbFallbackLanguage = 'en-US';
  static const String tmdbCertificationCountry = 'DE';

  static const String upcItemDbTrialBaseUrl =
      'https://api.upcitemdb.com/prod/trial';
  static const String upcItemDbProBaseUrl = 'https://api.upcitemdb.com/prod/v1';

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 15);

  static String posterUrl(String? path) =>
      path == null || path.isEmpty ? '' : '$tmdbImageBaseUrl/$posterSize$path';

  static String backdropUrl(String? path) => path == null || path.isEmpty
      ? ''
      : '$tmdbImageBaseUrl/$backdropSize$path';
}
