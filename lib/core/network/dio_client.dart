import 'package:dio/dio.dart';

import '../constants/api_constants.dart';
import '../errors/app_exception.dart';
import '../health/service_health.dart';
import 'network_info.dart';

class DioClient {
  DioClient({
    required this.dio,
    required this.networkInfo,
    this.service,
    this.credential,
    this.onHealth,
  });

  final Dio dio;
  final NetworkInfo networkInfo;

  /// The service behind [dio], when it is one Speednema reports health for.
  final ExternalService? service;

  /// The key this service needs. When given and empty, requests fail with
  /// [ServiceNotConfiguredException] without being sent.
  final String Function()? credential;

  /// Told about every outcome, so the app knows whether the service works.
  final void Function(ServiceHealth health)? onHealth;

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final service = this.service;
    if (service != null && credential != null && credential!().isEmpty) {
      onHealth?.call(const HealthNotConfigured());
      throw ServiceNotConfiguredException(service);
    }
    if (!await networkInfo.isConnected) {
      onHealth?.call(const HealthOffline());
      throw const NoInternetException();
    }
    try {
      final response = await dio.get<T>(path, queryParameters: queryParameters);
      onHealth?.call(HealthOk(DateTime.now()));
      return response;
    } on DioException catch (e) {
      final error = mapDioException(e, service: service);
      final health = healthFor(error);
      if (health != null) onHealth?.call(health);
      throw error;
    }
  }

  /// The health a failed request reveals, or null when it says nothing
  /// about the service (e.g. a title that does not exist).
  static ServiceHealth? healthFor(AppException error) => switch (error) {
    ServiceCredentialsInvalidException() => const HealthInvalidCredentials(),
    NoInternetException() => const HealthOffline(),
    RateLimitException(:final retryAfter) => HealthRateLimited(
      retryAfter: retryAfter,
    ),
    ApiUnavailableException() ||
    UnknownAppException() => const HealthUnavailable(),
    _ => null,
  };

  static AppException mapDioException(
    DioException e, {
    ExternalService? service,
  }) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return const NoInternetException();
    }

    final statusCode = e.response?.statusCode;
    if (statusCode == 401 || statusCode == 403) {
      return service == null
          ? const InvalidApiConfigException()
          : ServiceCredentialsInvalidException(service);
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

Dio buildUpcmdbDio(String apiKey) {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.upcmdbBaseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      headers: {
        'Accept': 'application/json',
        if (apiKey.isNotEmpty) 'x-api-key': apiKey,
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
