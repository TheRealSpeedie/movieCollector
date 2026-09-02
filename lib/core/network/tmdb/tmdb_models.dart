import '../../utils/date_parsing.dart';

class TmdbGenre {
  const TmdbGenre({required this.id, required this.name});

  final int id;
  final String name;

  factory TmdbGenre.fromJson(Map<String, dynamic> json) {
    return TmdbGenre(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
    );
  }
}

class TmdbCollectionRef {
  const TmdbCollectionRef({
    required this.id,
    required this.name,
    this.posterPath,
    this.backdropPath,
  });

  final int id;
  final String name;
  final String? posterPath;
  final String? backdropPath;

  factory TmdbCollectionRef.fromJson(Map<String, dynamic> json) {
    return TmdbCollectionRef(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? '',
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );
  }
}

class TmdbSearchResult {
  const TmdbSearchResult({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.posterPath,
    this.originalLanguage,
  });

  final int id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final DateTime? releaseDate;
  final String? posterPath;
  final String? originalLanguage;

  int? get releaseYear => releaseDate?.year;

  factory TmdbSearchResult.fromJson(Map<String, dynamic> json) {
    return TmdbSearchResult(
      id: json['id'] as int? ?? 0,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? json['title'] as String
          : (json['original_title'] as String? ?? 'Unbekannter Titel'),
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      releaseDate: parseIsoDate(json['release_date'] as String?),
      posterPath: json['poster_path'] as String?,
      originalLanguage: json['original_language'] as String?,
    );
  }
}

class TmdbMovieDetails {
  const TmdbMovieDetails({
    required this.id,
    required this.title,
    this.originalTitle,
    this.overview,
    this.releaseDate,
    this.runtime,
    this.posterPath,
    this.backdropPath,
    this.originalLanguage,
    this.genres = const [],
    this.collection,
    this.certification,
  });

  final int id;
  final String title;
  final String? originalTitle;
  final String? overview;
  final DateTime? releaseDate;
  final int? runtime;
  final String? posterPath;
  final String? backdropPath;
  final String? originalLanguage;
  final List<TmdbGenre> genres;
  final TmdbCollectionRef? collection;
  final String? certification;

  int? get releaseYear => releaseDate?.year;

  factory TmdbMovieDetails.fromJson(
    Map<String, dynamic> json, {
    String? certification,
  }) {
    final belongsTo = json['belongs_to_collection'];
    final genresJson = json['genres'] as List<dynamic>? ?? const [];
    return TmdbMovieDetails(
      id: json['id'] as int? ?? 0,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? json['title'] as String
          : (json['original_title'] as String? ?? 'Unbekannter Titel'),
      originalTitle: json['original_title'] as String?,
      overview: json['overview'] as String?,
      releaseDate: parseIsoDate(json['release_date'] as String?),
      runtime: json['runtime'] as int?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      originalLanguage: json['original_language'] as String?,
      genres: genresJson
          .whereType<Map<String, dynamic>>()
          .map(TmdbGenre.fromJson)
          .toList(growable: false),
      collection: belongsTo is Map<String, dynamic>
          ? TmdbCollectionRef.fromJson(belongsTo)
          : null,
      certification: certification,
    );
  }
}

class TmdbCollectionMovieRef {
  const TmdbCollectionMovieRef({
    required this.id,
    required this.title,
    this.originalTitle,
    this.posterPath,
    this.releaseDate,
  });

  final int id;
  final String title;
  final String? originalTitle;
  final String? posterPath;
  final DateTime? releaseDate;

  factory TmdbCollectionMovieRef.fromJson(Map<String, dynamic> json) {
    return TmdbCollectionMovieRef(
      id: json['id'] as int? ?? 0,
      title: (json['title'] as String?)?.trim().isNotEmpty == true
          ? json['title'] as String
          : (json['original_title'] as String? ?? 'Unbekannter Titel'),
      originalTitle: json['original_title'] as String?,
      posterPath: json['poster_path'] as String?,
      releaseDate: parseIsoDate(json['release_date'] as String?),
    );
  }
}

class TmdbCollectionDetails {
  const TmdbCollectionDetails({
    required this.id,
    required this.name,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.parts = const [],
  });

  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final List<TmdbCollectionMovieRef> parts;

  factory TmdbCollectionDetails.fromJson(Map<String, dynamic> json) {
    final partsJson = json['parts'] as List<dynamic>? ?? const [];
    return TmdbCollectionDetails(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unbekannte Reihe',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      parts: partsJson
          .whereType<Map<String, dynamic>>()
          .map(TmdbCollectionMovieRef.fromJson)
          .toList(growable: false),
    );
  }
}

class TmdbCollectionSearchResult {
  const TmdbCollectionSearchResult({
    required this.id,
    required this.name,
    this.overview,
    this.posterPath,
    this.backdropPath,
  });

  final int id;
  final String name;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;

  factory TmdbCollectionSearchResult.fromJson(Map<String, dynamic> json) {
    return TmdbCollectionSearchResult(
      id: json['id'] as int? ?? 0,
      name: json['name'] as String? ?? 'Unbekannte Reihe',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
    );
  }
}

class TmdbTvSearchResult {
  const TmdbTvSearchResult({
    required this.id,
    required this.name,
    this.originalName,
    this.overview,
    this.firstAirDate,
    this.posterPath,
    this.originalLanguage,
  });

  final int id;
  final String name;
  final String? originalName;
  final String? overview;
  final DateTime? firstAirDate;
  final String? posterPath;
  final String? originalLanguage;

  int? get firstAirYear => firstAirDate?.year;

  factory TmdbTvSearchResult.fromJson(Map<String, dynamic> json) {
    return TmdbTvSearchResult(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : (json['original_name'] as String? ?? 'Unbekannter Titel'),
      originalName: json['original_name'] as String?,
      overview: json['overview'] as String?,
      firstAirDate: parseIsoDate(json['first_air_date'] as String?),
      posterPath: json['poster_path'] as String?,
      originalLanguage: json['original_language'] as String?,
    );
  }
}

class TmdbTvSeason {
  const TmdbTvSeason({
    required this.id,
    required this.seasonNumber,
    required this.name,
    this.overview,
    this.posterPath,
    this.airDate,
    this.episodeCount,
  });

  final int id;
  final int seasonNumber;
  final String name;
  final String? overview;
  final String? posterPath;
  final DateTime? airDate;
  final int? episodeCount;

  bool get isSpecials => seasonNumber <= 0;

  factory TmdbTvSeason.fromJson(Map<String, dynamic> json) {
    return TmdbTvSeason(
      id: json['id'] as int? ?? 0,
      seasonNumber: json['season_number'] as int? ?? 0,
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : 'Staffel ${json['season_number'] ?? 0}',
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      airDate: parseIsoDate(json['air_date'] as String?),
      episodeCount: json['episode_count'] as int?,
    );
  }
}

class TmdbTvDetails {
  const TmdbTvDetails({
    required this.id,
    required this.name,
    this.originalName,
    this.overview,
    this.posterPath,
    this.backdropPath,
    this.firstAirDate,
    this.lastAirDate,
    this.numberOfSeasons,
    this.status,
    this.originalLanguage,
    this.contentRating,
    this.genres = const [],
    this.seasons = const [],
  });

  final int id;
  final String name;
  final String? originalName;
  final String? overview;
  final String? posterPath;
  final String? backdropPath;
  final DateTime? firstAirDate;
  final DateTime? lastAirDate;
  final int? numberOfSeasons;
  final String? status;
  final String? originalLanguage;
  final String? contentRating;
  final List<TmdbGenre> genres;
  final List<TmdbTvSeason> seasons;

  int? get firstAirYear => firstAirDate?.year;

  List<TmdbTvSeason> get regularSeasons =>
      seasons.where((s) => s.seasonNumber > 0).toList();

  TmdbTvSeason? get specials =>
      seasons.where((s) => s.seasonNumber <= 0).firstOrNull;

  factory TmdbTvDetails.fromJson(
    Map<String, dynamic> json, {
    String? contentRating,
  }) {
    final genresJson = json['genres'] as List<dynamic>? ?? const [];
    final seasonsJson = json['seasons'] as List<dynamic>? ?? const [];
    return TmdbTvDetails(
      id: json['id'] as int? ?? 0,
      name: (json['name'] as String?)?.trim().isNotEmpty == true
          ? json['name'] as String
          : (json['original_name'] as String? ?? 'Unbekannter Titel'),
      originalName: json['original_name'] as String?,
      overview: json['overview'] as String?,
      posterPath: json['poster_path'] as String?,
      backdropPath: json['backdrop_path'] as String?,
      firstAirDate: parseIsoDate(json['first_air_date'] as String?),
      lastAirDate: parseIsoDate(json['last_air_date'] as String?),
      numberOfSeasons: json['number_of_seasons'] as int?,
      status: json['status'] as String?,
      originalLanguage: json['original_language'] as String?,
      contentRating: contentRating,
      genres: genresJson
          .whereType<Map<String, dynamic>>()
          .map(TmdbGenre.fromJson)
          .toList(growable: false),
      seasons: seasonsJson
          .whereType<Map<String, dynamic>>()
          .map(TmdbTvSeason.fromJson)
          .toList(growable: false),
    );
  }
}
