import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_with_entries.dart';

final allCollectionsProvider = StreamProvider<List<CollectionWithEntries>>((
  ref,
) {
  return ref.watch(collectionRepositoryProvider).watchAllCollections();
});

final collectionByIdProvider =
    StreamProvider.family<CollectionWithEntries?, int>((ref, id) {
      return ref.watch(collectionRepositoryProvider).watchCollection(id);
    });

final collectionByTmdbIdProvider =
    StreamProvider.family<CollectionWithEntries?, int>((ref, tmdbCollectionId) {
      return ref
          .watch(collectionRepositoryProvider)
          .watchCollectionByTmdbId(tmdbCollectionId);
    });

class MissingGroup {
  const MissingGroup({required this.collection, required this.missingEntries});

  final CollectionWithEntries collection;
  final List<CollectionEntry> missingEntries;
}

final missingMoviesProvider = Provider<AsyncValue<List<MissingGroup>>>((ref) {
  final collections = ref.watch(allCollectionsProvider);
  return collections.whenData((list) {
    final groups = <MissingGroup>[];
    for (final collection in list) {
      final missing = collection.entries
          .where((e) => e.localMovie == null)
          .toList();
      if (missing.isNotEmpty) {
        groups.add(
          MissingGroup(collection: collection, missingEntries: missing),
        );
      }
    }
    return groups;
  });
});

final totalMissingCountProvider = Provider<AsyncValue<int>>((ref) {
  final groups = ref.watch(missingMoviesProvider);
  return groups.whenData(
    (list) => list.fold<int>(0, (sum, g) => sum + g.missingEntries.length),
  );
});
