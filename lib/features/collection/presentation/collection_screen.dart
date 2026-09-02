import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/models/tv_series_with_seasons.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../settings/data/settings_repository.dart';
import '../../tv/application/tv_providers.dart';
import '../application/collection_filter_controller.dart';

class CollectionScreen extends ConsumerStatefulWidget {
  const CollectionScreen({super.key});

  @override
  ConsumerState<CollectionScreen> createState() => _CollectionScreenState();
}

class _CollectionScreenState extends ConsumerState<CollectionScreen> {
  bool _searching = false;
  bool _showTv = false;
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final moviesAsync = ref.watch(filteredMoviesProvider);
    final filter = ref.watch(collectionFilterControllerProvider);
    final notifier = ref.read(collectionFilterControllerProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: _searching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Titel suchen…',
                  border: InputBorder.none,
                ),
                onChanged: notifier.setQuery,
              )
            : const Text('Sammlung'),
        actions: [
          IconButton(
            icon: Icon(_searching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() => _searching = !_searching);
              if (!_searching) {
                _searchController.clear();
                notifier.setQuery('');
              }
            },
          ),
          IconButton(
            icon: Icon(
              filter.viewMode == CollectionViewMode.grid
                  ? Icons.view_list
                  : Icons.grid_view,
            ),
            onPressed: notifier.toggleViewMode,
          ),
          PopupMenuButton<SortOption>(
            icon: const Icon(Icons.sort),
            onSelected: notifier.setSort,
            itemBuilder: (context) => const [
              PopupMenuItem(
                value: SortOption.recentlyAdded,
                child: Text('Zuletzt hinzugefügt'),
              ),
              PopupMenuItem(value: SortOption.title, child: Text('Titel')),
              PopupMenuItem(
                value: SortOption.releaseYear,
                child: Text('Erscheinungsjahr'),
              ),
              PopupMenuItem(value: SortOption.status, child: Text('Status')),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
            child: SegmentedButton<bool>(
              segments: const [
                ButtonSegment(value: false, label: Text('Filme')),
                ButtonSegment(value: true, label: Text('Serien')),
              ],
              selected: {_showTv},
              onSelectionChanged: (value) =>
                  setState(() => _showTv = value.first),
            ),
          ),
          _StatusFilterRow(filter: filter, notifier: notifier),
          const Divider(height: 1),
          Expanded(
            child: _showTv
                ? _TvCollectionBody(filter: filter)
                : moviesAsync.when(
                    loading: () => const LoadingView(),
                    error: (error, stack) =>
                        ErrorView(error: error, onRetry: () {}),
                    data: (movies) {
                      if (movies.isEmpty) {
                        return EmptyState(
                          icon: Icons.movie_filter_outlined,
                          title:
                              filter.query.isNotEmpty || filter.hasActiveFilters
                              ? 'Keine Filme gefunden'
                              : 'Deine Sammlung ist noch leer',
                          message:
                              filter.query.isNotEmpty || filter.hasActiveFilters
                              ? 'Passe deine Suche oder Filter an.'
                              : 'Füge deinen ersten Film über Suche oder Fundstück-Check hinzu.',
                          action:
                              (filter.query.isEmpty && !filter.hasActiveFilters)
                              ? FilledButton.icon(
                                  onPressed: () => context.push('/search'),
                                  icon: const Icon(Icons.search),
                                  label: const Text('Film suchen'),
                                )
                              : null,
                        );
                      }
                      return filter.viewMode == CollectionViewMode.grid
                          ? _MovieGrid(movies: movies)
                          : _MovieList(movies: movies);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class _StatusFilterRow extends StatelessWidget {
  const _StatusFilterRow({required this.filter, required this.notifier});

  final CollectionFilterState filter;
  final CollectionFilterController notifier;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Wrap(
        spacing: 8,
        children: [
          ChoiceChip(
            label: const Text('Alle'),
            selected: filter.statusFilter == null,
            onSelected: (_) => notifier.setStatusFilter(null),
          ),
          for (final status in CollectionStatus.values)
            ChoiceChip(
              label: Text(status.germanLabel),
              selected: filter.statusFilter == status,
              onSelected: (_) => notifier.setStatusFilter(
                filter.statusFilter == status ? null : status,
              ),
            ),
        ],
      ),
    );
  }
}

class _MovieGrid extends StatelessWidget {
  const _MovieGrid({required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.58,
      ),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return GestureDetector(
          onTap: () => context.push('/movie/${movie.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: PosterImage(posterPath: movie.posterPath)),
              const SizedBox(height: 6),
              Text(
                movie.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: [
                  if (movie.releaseYear != null)
                    Text(
                      '${movie.releaseYear}',
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.neutralGray,
                      ),
                    ),
                  const Spacer(),
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: colorForStatus(movie.status),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _MovieList extends StatelessWidget {
  const _MovieList({required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: movies.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final movie = movies[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/movie/${movie.id}'),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: PosterImage(
                      posterPath: movie.posterPath,
                      borderRadius: 10,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          movie.title,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (movie.releaseYear != null)
                          Text(
                            '${movie.releaseYear}',
                            style: const TextStyle(
                              color: AppColors.neutralGray,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 6),
                        StatusChip(status: movie.status, compact: true),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TvCollectionBody extends ConsumerWidget {
  const _TvCollectionBody({required this.filter});

  final CollectionFilterState filter;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(filteredTvSeriesProvider);
    return seriesAsync.when(
      loading: () => const LoadingView(),
      error: (error, stack) => ErrorView(error: error, onRetry: () {}),
      data: (series) {
        if (series.isEmpty) {
          return EmptyState(
            icon: Icons.tv_outlined,
            title: filter.query.isNotEmpty || filter.hasActiveFilters
                ? 'Keine Serien gefunden'
                : 'Noch keine Serien gespeichert',
            message: filter.query.isNotEmpty || filter.hasActiveFilters
                ? 'Passe deine Suche oder Filter an.'
                : 'Füge Serien über Import oder Fundstück-Check hinzu.',
          );
        }
        return filter.viewMode == CollectionViewMode.grid
            ? _TvGrid(series: series)
            : _TvList(series: series);
      },
    );
  }
}

class _TvGrid extends StatelessWidget {
  const _TvGrid({required this.series});

  final List<TvSeriesWithSeasons> series;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(12),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.52,
      ),
      itemCount: series.length,
      itemBuilder: (context, index) {
        final entry = series[index];
        return GestureDetector(
          onTap: () => context.push('/series/${entry.series.id}'),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: PosterImage(posterPath: entry.series.posterPath)),
              const SizedBox(height: 6),
              Text(
                entry.series.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              Text(
                entry.progressLabel,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.neutralGray,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _TvList extends StatelessWidget {
  const _TvList({required this.series});

  final List<TvSeriesWithSeasons> series;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: series.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final entry = series[index];
        return Card(
          child: InkWell(
            borderRadius: BorderRadius.circular(16),
            onTap: () => context.push('/series/${entry.series.id}'),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  SizedBox(
                    width: 56,
                    child: PosterImage(
                      posterPath: entry.series.posterPath,
                      borderRadius: 10,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.series.name,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        if (entry.series.firstAirYear != null)
                          Text(
                            '${entry.series.firstAirYear}',
                            style: const TextStyle(
                              color: AppColors.neutralGray,
                              fontSize: 12,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Text(
                          entry.progressLabel,
                          style: const TextStyle(
                            color: AppColors.neutralGray,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
