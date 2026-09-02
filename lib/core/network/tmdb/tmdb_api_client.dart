import '../../constants/api_constants.dart';
import '../dio_client.dart';
import 'tmdb_models.dart';

class TmdbApiClient {
  TmdbApiClient(this._client);

  final DioClient _client;

  Future<List<TmdbSearchResult>> searchMovies(
    String query, {
    int page = 1,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/search/movie',
      queryParameters: {
        'query': query,
        'language': ApiConstants.tmdbLanguage,
        'region': ApiConstants.tmdbRegion,
        'include_adult': false,
        'page': page,
      },
    );
    final results = response.data?['results'] as List<dynamic>? ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(TmdbSearchResult.fromJson)
        .toList(growable: false);
  }

  Future<TmdbMovieDetails> getMovieDetails(int tmdbId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/movie/$tmdbId',
      queryParameters: {
        'language': ApiConstants.tmdbLanguage,
        'append_to_response': 'release_dates',
      },
    );
    var data = response.data ?? const {};

    if ((data['overview'] as String?)?.trim().isEmpty ?? true) {
      final fallback = await _client.get<Map<String, dynamic>>(
        '/movie/$tmdbId',
        queryParameters: {
          'language': ApiConstants.tmdbFallbackLanguage,
          'append_to_response': 'release_dates',
        },
      );
      final fallbackData = fallback.data;
      if (fallbackData != null) {
        data = {
          ...fallbackData,
          if ((data['title'] as String?)?.trim().isNotEmpty == true)
            'title': data['title'],
        };
      }
    }

    final certification = _extractGermanCertification(data['release_dates']);
    return TmdbMovieDetails.fromJson(data, certification: certification);
  }

  Future<TmdbCollectionDetails> getCollection(int collectionId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/collection/$collectionId',
      queryParameters: {'language': ApiConstants.tmdbLanguage},
    );
    return TmdbCollectionDetails.fromJson(response.data ?? const {});
  }

  Future<List<TmdbCollectionSearchResult>> searchCollections(
    String query, {
    int page = 1,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/search/collection',
      queryParameters: {
        'query': query,
        'language': ApiConstants.tmdbLanguage,
        'page': page,
      },
    );
    final results = response.data?['results'] as List<dynamic>? ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(TmdbCollectionSearchResult.fromJson)
        .toList(growable: false);
  }

  Future<List<TmdbTvSearchResult>> searchTv(
    String query, {
    int page = 1,
  }) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/search/tv',
      queryParameters: {
        'query': query,
        'language': ApiConstants.tmdbLanguage,
        'include_adult': false,
        'page': page,
      },
    );
    final results = response.data?['results'] as List<dynamic>? ?? const [];
    return results
        .whereType<Map<String, dynamic>>()
        .map(TmdbTvSearchResult.fromJson)
        .toList(growable: false);
  }

  Future<TmdbTvDetails> getTvDetails(int tmdbId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/tv/$tmdbId',
      queryParameters: {
        'language': ApiConstants.tmdbLanguage,
        'append_to_response': 'content_ratings',
      },
    );
    var data = response.data ?? const {};

    if ((data['overview'] as String?)?.trim().isEmpty ?? true) {
      final fallback = await _client.get<Map<String, dynamic>>(
        '/tv/$tmdbId',
        queryParameters: {
          'language': ApiConstants.tmdbFallbackLanguage,
          'append_to_response': 'content_ratings',
        },
      );
      final fallbackData = fallback.data;
      if (fallbackData != null) {
        data = {
          ...fallbackData,
          if ((data['name'] as String?)?.trim().isNotEmpty == true)
            'name': data['name'],
        };
      }
    }

    return TmdbTvDetails.fromJson(
      data,
      contentRating: _extractGermanTvRating(data['content_ratings']),
    );
  }

  String? _extractGermanTvRating(dynamic payload) {
    if (payload is! Map<String, dynamic>) return null;
    final results = payload['results'] as List<dynamic>? ?? const [];
    for (final entry in results) {
      if (entry is! Map<String, dynamic>) continue;
      if (entry['iso_3166_1'] != ApiConstants.tmdbCertificationCountry) {
        continue;
      }
      final rating = entry['rating'] as String?;
      if (rating != null && rating.trim().isNotEmpty) return rating;
    }
    return null;
  }

  String? _extractGermanCertification(dynamic releaseDatesPayload) {
    if (releaseDatesPayload is! Map<String, dynamic>) return null;
    final results =
        releaseDatesPayload['results'] as List<dynamic>? ?? const [];
    for (final entry in results) {
      if (entry is! Map<String, dynamic>) continue;
      if (entry['iso_3166_1'] != ApiConstants.tmdbCertificationCountry) {
        continue;
      }
      final dates = entry['release_dates'] as List<dynamic>? ?? const [];
      for (final date in dates) {
        if (date is! Map<String, dynamic>) continue;
        final cert = date['certification'] as String?;
        if (cert != null && cert.trim().isNotEmpty) return cert;
      }
    }
    return null;
  }
}
