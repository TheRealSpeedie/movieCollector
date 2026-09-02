import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/app_exception.dart';
import 'network_info.dart';

class DioClient {
  DioClient({required this.dio, required this.networkInfo});

  final Dio dio;
  final NetworkInfo networkInfo;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    if (!await networkInfo.isConnected) {
      throw const NoInternetException();
    }
    try {
      return await dio.get<T>(path, queryParameters: queryParameters);
    } on DioException catch (e) {
      throw mapDioException(e);
    }
  }

  static AppException mapDioException(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NoInternetException();
    }

    final statusCode = e.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return const InvalidApiConfigException();
    }
    if (statusCode == 404) {
      return const MovieNotFoundException();
    }
    if (statusCode == 429) {
      return RateLimitException(
        'Das Anfragelimit wurde erreicht. Bitte später erneut versuchen.',
        _retryAfter(e),
      );
    }
    if (statusCode != null && statusCode >= 500) {
      return const ApiUnavailableException();
    }
    return const UnknownAppException();
  }

  static Duration? _retryAfter(DioException e) {
    final raw = e.response?.headers.value('retry-after');
    if (raw == null) return null;
    final seconds = int.tryParse(raw.trim());
    if (seconds == null) return null;
    return Duration(seconds: seconds.clamp(1, 30));
  }
}

Dio buildTmdbDio(String accessToken) {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.tmdbBaseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        if (accessToken.isNotEmpty) 'Authorization': 'Bearer $accessToken',
        'Accept': 'application/json',
      },
    ),
  );
}

Dio buildUpcItemDbDio({
  required String baseUrl,
  String? userKey,
  String? keyType,
}) {
  return Dio(
    BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (userKey != null && userKey.isNotEmpty) 'user_key': userKey,
        if (keyType != null && keyType.isNotEmpty) 'key_type': keyType,
      },
    ),
  );
}
