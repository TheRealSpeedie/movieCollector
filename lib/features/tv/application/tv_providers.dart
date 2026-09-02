import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/tv_series_with_seasons.dart';
import '../../collection/application/collection_filter_controller.dart';

final allTvSeriesProvider = StreamProvider<List<TvSeriesWithSeasons>>((ref) {
  return ref.watch(tvRepositoryProvider).watchAllSeries();
});

final tvSeriesByIdProvider = StreamProvider.family<TvSeriesWithSeasons?, int>((
  ref,
  id,
) {
  return ref.watch(tvRepositoryProvider).watchSeries(id);
});

final filteredTvSeriesProvider =
    Provider<AsyncValue<List<TvSeriesWithSeasons>>>((ref) {
      final seriesAsync = ref.watch(allTvSeriesProvider);
      final filter = ref.watch(collectionFilterControllerProvider);

      return seriesAsync.whenData((series) {
        var result = series.where((entry) {
          final query = filter.query.toLowerCase();
          if (query.isNotEmpty &&
              !entry.series.name.toLowerCase().contains(query) &&
              !(entry.series.originalName ?? '').toLowerCase().contains(
                query,
              )) {
            return false;
          }
          if (filter.statusFilter != null &&
              !entry.seasons.any((s) => s.status == filter.statusFilter)) {
            return false;
          }
          return true;
        }).toList();

        switch (filter.sort) {
          case SortOption.title:
            result.sort(
              (a, b) => a.series.name.toLowerCase().compareTo(
                b.series.name.toLowerCase(),
              ),
            );
          case SortOption.recentlyAdded:
            result.sort(
              (a, b) => b.series.createdAt.compareTo(a.series.createdAt),
            );
          case SortOption.releaseYear:
            result.sort(
              (a, b) => (b.series.firstAirYear ?? 0).compareTo(
                a.series.firstAirYear ?? 0,
              ),
            );
          case SortOption.status:
            result.sort(
              (a, b) => b.ownedRegularCount.compareTo(a.ownedRegularCount),
            );
        }
        return result;
      });
    });
