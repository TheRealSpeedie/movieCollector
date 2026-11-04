import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_shell.dart';
import '../../add/presentation/add_sheet.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/models/tv_series_with_seasons.dart';
import '../../../shared/widgets/media_card.dart';
import '../../../shared/widgets/poster_grid.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../../app/theme/tokens.g.dart';
import '../../movies/application/movie_providers.dart';
import '../../server/application/server_providers.dart';
import '../../server/presentation/title_card.dart';
import '../../settings/data/settings_repository.dart';
import '../../sync/application/sync_providers.dart';
import '../../tv/application/tv_providers.dart';
import '../application/collection_filter_controller.dart';
import 'collection_filter_sheet.dart';

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
    final connected = ref.watch(serverClientProvider) != null;

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
          if (MediaQuery.sizeOf(context).width < Breakpoints.medium)
            const AddButton(),
          IconButton(
            tooltip: _searching ? 'Suche schließen' : 'Sammlung durchsuchen',
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
            tooltip: 'Filter & Ansicht',
            icon: Badge(
              isLabelVisible:
                  filter.genreFilter != null || filter.yearFilter != null,
              smallSize: 8,
              child: const Icon(Icons.tune),
            ),
            onPressed: () => showCollectionFilterSheet(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.l,
              AppSpacing.s,
              AppSpacing.l,
              0,
            ),
            child: Align(
              alignment: AlignmentDirectional.centerStart,
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
          ),
          _StatusFilterRow(filter: filter, notifier: notifier),
          if (connected && !_showTv)
            _AvailabilityRow(filter: filter, notifier: notifier),
          const Divider(height: 1),
          Expanded(
            child: _showTv
                ? _TvCollectionBody(filter: filter)
                : connected && filter.availability == Availability.digital
                ? _DigitalOnlyGrid(query: filter.query)
                : moviesAsync.when(
                    loading: () => const SkeletonPosterGrid(),
                    error: (error, stack) => ErrorView(
                      error: error,
                      onRetry: () => ref.invalidate(allMoviesProvider),
                    ),
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
                              : 'Scanne einen Barcode, suche einen Titel oder importiere eine Liste.',
                          action:
                              (filter.query.isEmpty && !filter.hasActiveFilters)
                              ? FilledButton.icon(
                                  onPressed: () => showAddSheet(context),
                                  icon: const Icon(Icons.add),
                                  label: const Text('Ersten Film hinzufügen'),
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
    // One line that scrolls, aligned with the grid, instead of wrapping.
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.s,
      ),
      child: Wrap(
        spacing: AppSpacing.s,
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

class _AvailabilityRow extends StatelessWidget {
  const _AvailabilityRow({required this.filter, required this.notifier});

  final CollectionFilterState filter;
  final CollectionFilterController notifier;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        0,
        AppSpacing.l,
        AppSpacing.s,
      ),
      child: Wrap(
        spacing: AppSpacing.s,
        children: [
          for (final availability in Availability.values)
            ChoiceChip(
              label: Text(availability.label),
              selected: filter.availability == availability,
              onSelected: (_) => notifier.setAvailability(availability),
            ),
        ],
      ),
    );
  }
}

class _DigitalOnlyGrid extends ConsumerWidget {
  const _DigitalOnlyGrid({required this.query});

  final String query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final library = ref.watch(serverMoviesProvider);
    final owned = {
      for (final movie in ref.watch(allMoviesProvider).valueOrNull ?? [])
        movie.tmdbId,
    };
    return library.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(serverMoviesProvider),
      ),
      data: (titles) {
        final digitalOnly = titles
            .where(
              (t) =>
                  !owned.contains(t.tmdbId) &&
                  t.name.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
        if (digitalOnly.isEmpty) {
          return const EmptyState(
            icon: Icons.play_circle_outline,
            title: 'Keine rein digitalen Filme',
            message:
                'Hier erscheinen Filme aus deiner Server-Bibliothek, die nicht in deiner Sammlung liegen.',
          );
        }
        return GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 130,
            childAspectRatio: 0.52,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: digitalOnly.length,
          itemBuilder: (context, index) => TitleCard(title: digitalOnly[index]),
        );
      },
    );
  }
}

class _MovieGrid extends StatelessWidget {
  const _MovieGrid({required this.movies});

  final List<Movie> movies;

  @override
  Widget build(BuildContext context) {
    return PosterGrid(
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MediaCard(
          key: ValueKey(movie.id),
          title: movie.title,
          posterPath: movie.posterPath,
          subtitle: movie.releaseYear?.toString(),
          status: movie.status,
          onTap: () => context.push('/movie/${movie.id}'),
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
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      itemCount: movies.length,
      itemBuilder: (context, index) {
        final movie = movies[index];
        return MediaRow(
          key: ValueKey(movie.id),
          title: movie.title,
          posterPath: movie.posterPath,
          subtitle: movie.releaseYear?.toString(),
          status: movie.status,
          onTap: () => context.push('/movie/${movie.id}'),
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
      loading: () => const SkeletonPosterGrid(),
      error: (error, stack) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(allTvSeriesProvider),
      ),
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
    return PosterGrid(
      itemCount: series.length,
      itemBuilder: (context, index) {
        final entry = series[index];
        return MediaCard(
          key: ValueKey(entry.series.id),
          title: entry.series.name,
          posterPath: entry.series.posterPath,
          subtitle: entry.progressLabel,
          onTap: () => context.push('/series/${entry.series.id}'),
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
    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      itemCount: series.length,
      itemBuilder: (context, index) {
        final entry = series[index];
        return MediaRow(
          key: ValueKey(entry.series.id),
          title: entry.series.name,
          posterPath: entry.series.posterPath,
          subtitle: [
            if (entry.series.firstAirYear != null)
              '${entry.series.firstAirYear}',
            entry.progressLabel,
          ].join(' · '),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => context.push('/series/${entry.series.id}'),
        );
      },
    );
  }
}
