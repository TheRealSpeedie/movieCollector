import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/collections/data/collection_repository.dart';
import '../../features/editions/data/physical_edition_repository.dart';
import '../../features/import/data/import_repository.dart';
import '../../features/tv/data/tv_repository.dart';
import '../../features/movies/data/movie_repository.dart';
import '../../features/scanner/data/barcode_repository.dart';
import '../../features/scanner/domain/barcode_resolver.dart';
import 'core_providers.dart';

final collectionRepositoryProvider = Provider<CollectionRepository>((ref) {
  return CollectionRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(tmdbApiClientProvider),
  );
});

final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(tmdbApiClientProvider),
    ref.watch(collectionRepositoryProvider),
  );
});

final barcodeRepositoryProvider = Provider<BarcodeRepository>((ref) {
  return BarcodeRepository(ref.watch(appDatabaseProvider));
});

final barcodeResolverProvider = Provider<BarcodeResolver>((ref) {
  return BarcodeResolver(
    barcodeRepository: ref.watch(barcodeRepositoryProvider),
    barcodeProvider: ref.watch(barcodeProviderProvider),
    tmdbApiClient: ref.watch(tmdbApiClientProvider),
    networkInfo: ref.watch(networkInfoProvider),
    editionRepository: ref.watch(physicalEditionRepositoryProvider),
  );
});

final tvRepositoryProvider = Provider<TvRepository>((ref) {
  return TvRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(tmdbApiClientProvider),
  );
});

final physicalEditionRepositoryProvider = Provider<PhysicalEditionRepository>((
  ref,
) {
  return PhysicalEditionRepository(ref.watch(appDatabaseProvider));
});

final importRepositoryProvider = Provider<ImportRepository>((ref) {
  return ImportRepository(
    ref.watch(tmdbApiClientProvider),
    ref.watch(movieRepositoryProvider),
    database: ref.watch(appDatabaseProvider),
    collectionRepository: ref.watch(collectionRepositoryProvider),
    tvRepository: ref.watch(tvRepositoryProvider),
    editionRepository: ref.watch(physicalEditionRepositoryProvider),
  );
});
