import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/settings/application/settings_providers.dart';
import '../../features/editions/application/catalog_providers.dart';
import '../../features/collections/data/collection_repository.dart';
import '../../features/editions/data/physical_edition_repository.dart';
import '../../features/import/data/import_repository.dart';
import '../../features/tv/data/tv_repository.dart';
import '../../features/movies/data/movie_repository.dart';
import '../../features/scanner/data/barcode_lookup_cache_repository.dart';
import '../../features/scanner/data/barcode_repository.dart';
import '../../features/scanner/domain/barcode_lookup_service.dart';
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
    defaultFormat: () => _preferredFormat(ref),
  );
});

final barcodeRepositoryProvider = Provider<BarcodeRepository>((ref) {
  return BarcodeRepository(ref.watch(appDatabaseProvider));
});

final barcodeLookupCacheRepositoryProvider =
    Provider<BarcodeLookupCacheRepository>((ref) {
      return BarcodeLookupCacheRepository(ref.watch(appDatabaseProvider));
    });

final barcodeLookupServiceProvider = Provider<BarcodeLookupService>((ref) {
  return BarcodeLookupService(
    upcItemDb: ref.watch(barcodeProviderProvider),
    upcmdb: ref.watch(upcmdbClientProvider),
    cache: ref.watch(barcodeLookupCacheRepositoryProvider),
    catalog: ref.watch(editionCatalogProvider),
  );
});

final barcodeResolverProvider = Provider<BarcodeResolver>((ref) {
  return BarcodeResolver(
    barcodeRepository: ref.watch(barcodeRepositoryProvider),
    barcodeProvider: ref.watch(barcodeProviderProvider),
    tmdbApiClient: ref.watch(tmdbApiClientProvider),
    networkInfo: ref.watch(networkInfoProvider),
    editionRepository: ref.watch(physicalEditionRepositoryProvider),
    lookupService: ref.watch(barcodeLookupServiceProvider),
  );
});

final tvRepositoryProvider = Provider<TvRepository>((ref) {
  return TvRepository(
    ref.watch(appDatabaseProvider),
    ref.watch(tmdbApiClientProvider),
    defaultFormat: () => _preferredFormat(ref),
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

/// The person's first preferred format, read when it is used, so changing
/// it in Einstellungen applies at once. A convenience only: if preferences
/// cannot be read, the film is still added, with an unknown format.
String? _preferredFormat(Ref ref) {
  try {
    return ref.read(userPreferencesProvider).preferredFormats.firstOrNull;
  } catch (_) {
    return null;
  }
}
