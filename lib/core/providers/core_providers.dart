import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config_providers.dart';
import '../config/env.dart';
import '../constants/api_constants.dart';
import '../database/app_database.dart';
import '../health/health_providers.dart';
import '../health/service_health.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../network/tmdb/tmdb_api_client.dart';
import '../network/upcmdb/upcmdb_client.dart';
import '../network/upcitemdb/upcitemdb_client.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

final tmdbDioProvider = Provider<Dio>(
  (ref) => buildTmdbDio(ref.watch(tmdbTokenProvider)),
);

final tmdbDioClientProvider = Provider<DioClient>((ref) {
  final token = ref.watch(tmdbTokenProvider);
  return DioClient(
    dio: ref.watch(tmdbDioProvider),
    networkInfo: ref.watch(networkInfoProvider),
    service: ExternalService.tmdb,
    credential: () => token,
    onHealth: ref
        .read(serviceHealthProvider(ExternalService.tmdb).notifier)
        .report,
  );
});

final tmdbApiClientProvider = Provider<TmdbApiClient>((ref) {
  return TmdbApiClient(ref.watch(tmdbDioClientProvider));
});

final upcItemDbDioProvider = Provider<Dio>((ref) {
  return buildUpcItemDbDio(
    baseUrl: Env.isUpcItemDbProConfigured
        ? ApiConstants.upcItemDbProBaseUrl
        : ApiConstants.upcItemDbTrialBaseUrl,
    userKey: Env.upcItemDbUserKey,
    keyType: Env.upcItemDbKeyType,
  );
});

final upcItemDbDioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    dio: ref.watch(upcItemDbDioProvider),
    networkInfo: ref.watch(networkInfoProvider),
    service: ExternalService.upcItemDb,
    onHealth: ref
        .read(serviceHealthProvider(ExternalService.upcItemDb).notifier)
        .report,
  );
});

final barcodeProviderProvider = Provider<BarcodeProvider>((ref) {
  return UpcItemDbClient(ref.watch(upcItemDbDioClientProvider));
});

final upcmdbDioProvider = Provider<Dio>((ref) {
  return buildUpcmdbDio(Env.upcmdbApiKey);
});

final upcmdbDioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    dio: ref.watch(upcmdbDioProvider),
    networkInfo: ref.watch(networkInfoProvider),
    service: ExternalService.upcmdb,
    credential: () => Env.upcmdbApiKey.trim(),
    onHealth: ref
        .read(serviceHealthProvider(ExternalService.upcmdb).notifier)
        .report,
  );
});

final upcmdbClientProvider = Provider<UpcmdbClient?>((ref) {
  if (!Env.isUpcmdbConfigured) return null;
  return UpcmdbClient(ref.watch(upcmdbDioClientProvider));
});
