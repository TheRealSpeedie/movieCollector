import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/shared_preferences_provider.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/movie.dart';
import '../../movies/application/movie_providers.dart';
import '../../settings/data/settings_repository.dart';

enum SortOption { title, recentlyAdded, releaseYear, status }

class CollectionFilterState {
  const CollectionFilterState({
    this.query = '',
    this.statusFilter,
    this.genreFilter,
    this.yearFilter,
    this.sort = SortOption.recentlyAdded,
    this.viewMode = CollectionViewMode.grid,
  });

  final String query;
  final CollectionStatus? statusFilter;
  final String? genreFilter;
  final int? yearFilter;
  final SortOption sort;
  final CollectionViewMode viewMode;

  bool get hasActiveFilters =>
      statusFilter != null || genreFilter != null || yearFilter != null;

  CollectionFilterState copyWith({
    String? query,
    CollectionStatus? statusFilter,
    bool clearStatusFilter = false,
    String? genreFilter,
    bool clearGenreFilter = false,
    int? yearFilter,
    bool clearYearFilter = false,
    SortOption? sort,
    CollectionViewMode? viewMode,
  }) {
    return CollectionFilterState(
      query: query ?? this.query,
      statusFilter: clearStatusFilter
          ? null
          : (statusFilter ?? this.statusFilter),
      genreFilter: clearGenreFilter ? null : (genreFilter ?? this.genreFilter),
      yearFilter: clearYearFilter ? null : (yearFilter ?? this.yearFilter),
      sort: sort ?? this.sort,
      viewMode: viewMode ?? this.viewMode,
    );
  }
}

class CollectionFilterController extends StateNotifier<CollectionFilterState> {
  CollectionFilterController(this._settingsRepository)
    : super(CollectionFilterState(viewMode: _settingsRepository.getViewMode()));

  final SettingsRepository _settingsRepository;

  void setQuery(String query) => state = state.copyWith(query: query);

  void setStatusFilter(CollectionStatus? status) {
    state = status == null
        ? state.copyWith(clearStatusFilter: true)
        : state.copyWith(statusFilter: status);
  }

  void setGenreFilter(String? genre) {
    state = genre == null
        ? state.copyWith(clearGenreFilter: true)
        : state.copyWith(genreFilter: genre);
  }

  void setYearFilter(int? year) {
    state = year == null
        ? state.copyWith(clearYearFilter: true)
        : state.copyWith(yearFilter: year);
  }

  void setSort(SortOption sort) => state = state.copyWith(sort: sort);

  void clearFilters() => state = state.copyWith(
    clearStatusFilter: true,
    clearGenreFilter: true,
    clearYearFilter: true,
  );

  Future<void> toggleViewMode() async {
    final next = state.viewMode == CollectionViewMode.grid
        ? CollectionViewMode.list
        : CollectionViewMode.grid;
    state = state.copyWith(viewMode: next);
    await _settingsRepository.setViewMode(next);
  }
}

final collectionFilterControllerProvider =
    StateNotifierProvider<CollectionFilterController, CollectionFilterState>((
      ref,
    ) {
      return CollectionFilterController(
        SettingsRepository(ref.watch(sharedPreferencesProvider)),
      );
    });

final filteredMoviesProvider = Provider<AsyncValue<List<Movie>>>((ref) {
  final moviesAsync = ref.watch(allMoviesProvider);
  final filter = ref.watch(collectionFilterControllerProvider);

  return moviesAsync.whenData((movies) {
    var result = movies.where((movie) {
      if (filter.query.isNotEmpty &&
          !movie.title.toLowerCase().contains(filter.query.toLowerCase()) &&
          !(movie.originalTitle ?? '').toLowerCase().contains(
            filter.query.toLowerCase(),
          )) {
        return false;
      }
      if (filter.statusFilter != null && movie.status != filter.statusFilter) {
        return false;
      }
      if (filter.genreFilter != null &&
          !movie.genres.contains(filter.genreFilter)) {
        return false;
      }
      if (filter.yearFilter != null && movie.releaseYear != filter.yearFilter) {
        return false;
      }
      return true;
    }).toList();

    switch (filter.sort) {
      case SortOption.title:
        result.sort(
          (a, b) => a.title.toLowerCase().compareTo(b.title.toLowerCase()),
        );
        break;
      case SortOption.recentlyAdded:
        result.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.releaseYear:
        result.sort(
          (a, b) => (b.releaseYear ?? 0).compareTo(a.releaseYear ?? 0),
        );
        break;
      case SortOption.status:
        result.sort((a, b) => a.status.index.compareTo(b.status.index));
        break;
    }
    return result;
  });
});
