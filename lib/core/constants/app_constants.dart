class AppConstants {
  AppConstants._();

  static const String appName = 'Movie Shelf';
  static const String databaseFileName = 'movie_shelf.sqlite';

  static const Duration metadataStaleAfter = Duration(days: 14);
  static const Duration collectionStaleAfter = Duration(days: 7);

  static const double defaultMatchConfidenceThreshold = 0.82;
  static const double minAcceptableConfidence = 0.55;
}
