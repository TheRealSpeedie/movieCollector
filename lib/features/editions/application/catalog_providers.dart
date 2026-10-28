import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../cloud/application/cloud_providers.dart';
import '../../server/application/server_providers.dart';
import '../data/edition_catalog.dart';

/// The edition catalog to ask: the own server when one is connected,
/// otherwise Movie Shelf Cloud when signed in. Without either, editions come
/// only from this device.
final editionCatalogProvider = Provider<EditionCatalog?>((ref) {
  final server = ref.watch(serverClientProvider);
  if (server != null) {
    return RemoteEditionCatalog(
      name: 'deinem Movie Shelf Server',
      get: (path, query) => server.get(path, query: query),
      post: (path, body) => server.post(path, body: body),
    );
  }
  final cloud = ref.watch(cloudClientProvider);
  if (cloud?.session != null) {
    return RemoteEditionCatalog(
      name: 'Movie Shelf Cloud',
      get: (path, query) => cloud!.get(path, query: query),
      post: (path, body) => cloud!.post(path, body: body),
    );
  }
  return null;
});

/// Catalog editions of a film. Empty without a catalog or connection; the
/// editions already on the device are shown anyway.
final catalogEditionsProvider = FutureProvider.autoDispose
    .family<List<CatalogEntry>, int>((ref, tmdbId) async {
      final catalog = ref.watch(editionCatalogProvider);
      if (catalog == null) return const [];
      try {
        return await catalog.forTitle('movie', tmdbId);
      } on Exception {
        return const [];
      }
    });
