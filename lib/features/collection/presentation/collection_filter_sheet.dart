import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/tokens.g.dart';
import '../../movies/application/movie_providers.dart';
import '../../settings/data/settings_repository.dart';
import '../application/collection_filter_controller.dart';

/// Sorting, view and the less frequent filters (genre, year) in one place,
/// so the app bar keeps only search and "+". Genres and years come from the
/// collection itself; there is nothing to pick that would show no film.
Future<void> showCollectionFilterSheet(BuildContext context) =>
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (_) => const _CollectionFilterSheet(),
    );

class _CollectionFilterSheet extends ConsumerWidget {
  const _CollectionFilterSheet();

  static const _sortLabels = {
    SortOption.recentlyAdded: 'Zuletzt hinzugefügt',
    SortOption.title: 'Titel',
    SortOption.releaseYear: 'Erscheinungsjahr',
    SortOption.status: 'Status',
  };

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(collectionFilterControllerProvider);
    final notifier = ref.read(collectionFilterControllerProvider.notifier);
    final movies = ref.watch(allMoviesProvider).valueOrNull ?? const [];
    final genres = {for (final m in movies) ...m.genres}.toList()..sort();
    final years = {
      for (final m in movies)
        if (m.releaseYear != null) m.releaseYear!,
    }.toList()..sort((a, b) => b.compareTo(a));
    final text = Theme.of(context).textTheme;

    Widget title(String label) => Padding(
      padding: const EdgeInsets.only(top: AppSpacing.l, bottom: AppSpacing.s),
      child: Semantics(
        header: true,
        child: Text(label, style: text.titleMedium),
      ),
    );

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.xl,
        0,
        AppSpacing.xl,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(child: Text('Filter & Ansicht', style: text.titleLarge)),
              if (filter.genreFilter != null || filter.yearFilter != null)
                TextButton(
                  onPressed: () {
                    notifier
                      ..setGenreFilter(null)
                      ..setYearFilter(null);
                  },
                  child: const Text('Zurücksetzen'),
                ),
            ],
          ),
          title('Ansicht'),
          SegmentedButton<CollectionViewMode>(
            segments: const [
              ButtonSegment(
                value: CollectionViewMode.grid,
                icon: Icon(Icons.grid_view),
                label: Text('Raster'),
              ),
              ButtonSegment(
                value: CollectionViewMode.list,
                icon: Icon(Icons.view_list),
                label: Text('Liste'),
              ),
            ],
            selected: {filter.viewMode},
            onSelectionChanged: (selection) {
              if (selection.single != filter.viewMode) {
                notifier.toggleViewMode();
              }
            },
          ),
          title('Sortieren nach'),
          Wrap(
            spacing: AppSpacing.s,
            runSpacing: AppSpacing.s,
            children: [
              for (final MapEntry(key: sort, value: label)
                  in _sortLabels.entries)
                ChoiceChip(
                  label: Text(label),
                  selected: filter.sort == sort,
                  onSelected: (_) => notifier.setSort(sort),
                ),
            ],
          ),
          if (genres.isNotEmpty) ...[
            title('Genre'),
            Wrap(
              spacing: AppSpacing.s,
              runSpacing: AppSpacing.s,
              children: [
                for (final genre in genres)
                  FilterChip(
                    label: Text(genre),
                    selected: filter.genreFilter == genre,
                    onSelected: (on) =>
                        notifier.setGenreFilter(on ? genre : null),
                  ),
              ],
            ),
          ],
          if (years.isNotEmpty) ...[
            title('Erscheinungsjahr'),
            DropdownMenu<int?>(
              initialSelection: filter.yearFilter,
              width: 220,
              label: const Text('Jahr'),
              onSelected: notifier.setYearFilter,
              dropdownMenuEntries: [
                const DropdownMenuEntry(value: null, label: 'Alle Jahre'),
                for (final y in years) DropdownMenuEntry(value: y, label: '$y'),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
