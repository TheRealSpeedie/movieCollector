import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/matching/item_selection.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/providers/core_providers.dart';
import '../../../core/utils/season_format.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/selectable_item_list.dart';
import '../application/import_controller.dart';
import '../domain/import_models.dart';

enum _TvAssignMode { single, range, complete }

class ImportSelectionScreen extends ConsumerStatefulWidget {
  const ImportSelectionScreen({
    super.key,
    required this.rowIndex,
    this.tmdbSeriesId,
    this.tmdbCollectionId,
    this.closeSearchOnConfirm = false,
  });

  final int rowIndex;
  final int? tmdbSeriesId;
  final int? tmdbCollectionId;
  final bool closeSearchOnConfirm;

  @override
  ConsumerState<ImportSelectionScreen> createState() =>
      _ImportSelectionScreenState();
}

class _ImportSelectionScreenState extends ConsumerState<ImportSelectionScreen> {
  TmdbCollectionDetails? _collection;
  TmdbTvDetails? _tvDetails;
  TmdbTvSearchResult? _series;
  late ItemSelection _selection;
  _TvAssignMode _tvMode = _TvAssignMode.range;
  Object? _error;
  bool _loading = true;

  ImportRow? get _row {
    for (final row in ref.read(importControllerProvider).rows) {
      if (row.index == widget.rowIndex) return row;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _selection = ItemSelection();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final row = _row;
    final tmdb = ref.read(tmdbApiClientProvider);
    try {
      final collectionId =
          widget.tmdbCollectionId ??
          switch (row?.target) {
            ImportTargetMovieBundle(:final collection) => collection.id,
            _ => null,
          };
      final seriesId =
          widget.tmdbSeriesId ??
          switch (row?.target) {
            ImportTargetSingleTvSeason(:final series) => series.id,
            ImportTargetTvSeasonBundle(:final series) => series.id,
            ImportTargetCompleteTvSeries(:final series) => series.id,
            _ => null,
          };

      if (collectionId != null) {
        final details = await tmdb.getCollection(collectionId);
        final preselected = switch (row?.target) {
          ImportTargetMovieBundle(:final selectedTmdbIds) => selectedTmdbIds,
          _ => details.parts.map((p) => p.id).toList(),
        };
        if (!mounted) return;
        setState(() {
          _collection = details;
          _selection = ItemSelection(preselected);
          _loading = false;
        });
        return;
      }

      if (seriesId != null) {
        final details = await tmdb.getTvDetails(seriesId);
        final series =
            switch (row?.target) {
              ImportTargetSingleTvSeason(:final series) => series,
              ImportTargetTvSeasonBundle(:final series) => series,
              ImportTargetCompleteTvSeries(:final series) => series,
              _ => null,
            } ??
            TmdbTvSearchResult(
              id: details.id,
              name: details.name,
              originalName: details.originalName,
              overview: details.overview,
              firstAirDate: details.firstAirDate,
              posterPath: details.posterPath,
              originalLanguage: details.originalLanguage,
            );
        final target = row?.target;
        final preselected = switch (target) {
          ImportTargetSingleTvSeason(:final seasonNumber) => [seasonNumber],
          ImportTargetTvSeasonBundle(:final selectedSeasonNumbers) =>
            selectedSeasonNumbers,
          ImportTargetCompleteTvSeries(:final selectedSeasonNumbers) =>
            selectedSeasonNumbers,
          _ =>
            row?.parsedSeasonNumbers.isNotEmpty == true
                ? row!.parsedSeasonNumbers
                : details.regularSeasons.map((s) => s.seasonNumber).toList(),
        };
        final mode = switch (target) {
          ImportTargetSingleTvSeason() => _TvAssignMode.single,
          ImportTargetCompleteTvSeries() => _TvAssignMode.complete,
          _ =>
            preselected.length <= 1
                ? _TvAssignMode.single
                : preselected.length == details.regularSeasons.length
                ? _TvAssignMode.complete
                : _TvAssignMode.range,
        };
        if (!mounted) return;
        setState(() {
          _tvDetails = details;
          _series = series;
          _selection = ItemSelection(preselected);
          _tvMode = mode;
          _loading = false;
        });
        return;
      }

      if (!mounted) return;
      setState(() {
        _error = 'Keine Auswahl verfügbar.';
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error;
        _loading = false;
      });
    }
  }

  void _confirm() {
    final row = _row;
    if (row == null) return;
    final collection = _collection;
    final details = _tvDetails;
    final series = _series;
    late ImportTarget target;
    if (collection != null) {
      target = ImportTarget.movieBundle(
        collection: collection,
        selectedTmdbIds: _selection.selected.toList(),
      );
    } else if (details != null && series != null) {
      final selected = _selection.selected.toList()..sort();
      target = switch (_tvMode) {
        _TvAssignMode.single => ImportTarget.singleTvSeason(
          series: series,
          details: details,
          seasonNumber: selected.isEmpty ? 1 : selected.first,
        ),
        _TvAssignMode.complete => ImportTarget.completeTvSeries(
          series: series,
          details: details,
          selectedSeasonNumbers: selected,
        ),
        _TvAssignMode.range => ImportTarget.tvSeasonBundle(
          series: series,
          details: details,
          selectedSeasonNumbers: selected,
        ),
      };
    } else {
      return;
    }
    ref.read(importControllerProvider.notifier).applyTarget(row.index, target);
    if (mounted) {
      context.pop();
      if (widget.closeSearchOnConfirm && context.canPop()) context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _collection != null ? 'Filme auswählen' : 'Staffeln auswählen',
        ),
      ),
      body: _loading
          ? const LoadingView()
          : _error != null
          ? ErrorView(error: _error!, onRetry: _load)
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                if (_collection != null) ...[
                  Text(
                    _collection!.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  SelectableItemList(
                    items: [
                      for (final part in _collection!.parts)
                        SelectableListItem(
                          id: part.id,
                          title: part.title,
                          subtitle: part.releaseDate?.year.toString(),
                        ),
                    ],
                    selection: _selection,
                    onChanged: () => setState(() {}),
                  ),
                ],
                if (_tvDetails != null) ...[
                  Text(
                    _tvDetails!.name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 12),
                  SegmentedButton<_TvAssignMode>(
                    segments: const [
                      ButtonSegment(
                        value: _TvAssignMode.single,
                        label: Text('Einzelne Staffel'),
                      ),
                      ButtonSegment(
                        value: _TvAssignMode.range,
                        label: Text('Mehrere Staffeln'),
                      ),
                      ButtonSegment(
                        value: _TvAssignMode.complete,
                        label: Text('Komplette Serie'),
                      ),
                    ],
                    selected: {_tvMode},
                    onSelectionChanged: (value) {
                      final mode = value.first;
                      setState(() {
                        _tvMode = mode;
                        final regular = _tvDetails!.regularSeasons.map(
                          (s) => s.seasonNumber,
                        );
                        if (mode == _TvAssignMode.complete) {
                          _selection.selectRegular(regular);
                        } else if (mode == _TvAssignMode.single &&
                            _selection.count != 1) {
                          _selection.selectAll(
                            regular.isEmpty ? const <int>[] : [regular.first],
                          );
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  SelectableItemList(
                    items: [
                      for (final season in _tvDetails!.regularSeasons)
                        SelectableListItem(
                          id: season.seasonNumber,
                          title: seasonLabel(season.seasonNumber),
                          subtitle:
                              season.name == seasonLabel(season.seasonNumber)
                              ? null
                              : season.name,
                        ),
                    ],
                    selection: _selection,
                    singleSelect: _tvMode == _TvAssignMode.single,
                    showRegularSeasonsAction: true,
                    onChanged: () => setState(() {}),
                  ),
                  if (_tvDetails!.specials != null) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Optional:',
                      style: TextStyle(color: AppColors.neutralGray),
                    ),
                    CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      value: _selection.contains(
                        _tvDetails!.specials!.seasonNumber,
                      ),
                      title: const Text('Specials'),
                      controlAffinity: ListTileControlAffinity.leading,
                      onChanged: _tvMode == _TvAssignMode.single
                          ? null
                          : (_) {
                              _selection.toggle(
                                _tvDetails!.specials!.seasonNumber,
                              );
                              setState(() {});
                            },
                    ),
                  ],
                ],
              ],
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton(
            onPressed: _selection.count == 0 ? null : _confirm,
            child: const Text('Auswahl übernehmen'),
          ),
        ),
      ),
    );
  }
}
