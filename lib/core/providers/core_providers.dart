import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/env.dart';
import '../constants/api_constants.dart';
import '../database/app_database.dart';
import '../network/dio_client.dart';
import '../network/network_info.dart';
import '../network/tmdb/tmdb_api_client.dart';
import '../network/upcitemdb/upcitemdb_client.dart';

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(db.close);
  return db;
});

final networkInfoProvider = Provider<NetworkInfo>((ref) => NetworkInfoImpl());

final tmdbDioProvider = Provider<Dio>(
  (ref) => buildTmdbDio(Env.tmdbAccessToken),
);

final tmdbDioClientProvider = Provider<DioClient>((ref) {
  return DioClient(
    dio: ref.watch(tmdbDioProvider),
    networkInfo: ref.watch(networkInfoProvider),
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
  );
});

final barcodeProviderProvider = Provider<BarcodeProvider>((ref) {
  return UpcItemDbClient(ref.watch(upcItemDbDioClientProvider));
});
