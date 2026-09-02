import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/providers/core_providers.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/movie_search_result_tile.dart';
import '../application/import_controller.dart';
import '../application/import_movie_search_controller.dart';
import '../domain/import_models.dart';

class ImportMovieSearchScreen extends ConsumerStatefulWidget {
  const ImportMovieSearchScreen({
    super.key,
    required this.rowIndex,
    this.initialMedia = ImportSearchMedia.movie,
  });

  final int rowIndex;
  final ImportSearchMedia initialMedia;

  @override
  ConsumerState<ImportMovieSearchScreen> createState() =>
      _ImportMovieSearchScreenState();
}

class _ImportMovieSearchScreenState
    extends ConsumerState<ImportMovieSearchScreen> {
  late final TextEditingController _controller;
  Timer? _debounce;

  ImportRow? get _row {
    for (final row in ref.read(importControllerProvider).rows) {
      if (row.index == widget.rowIndex) return row;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    final prefill = _row?.parsedTitle ?? '';
    _controller = TextEditingController(text: prefill);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final search = ref.read(importMovieSearchControllerProvider.notifier);
      if (widget.initialMedia == ImportSearchMedia.tv) {
        await search.setMedia(ImportSearchMedia.tv);
      }
      if (prefill.trim().isNotEmpty) await search.search(prefill);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(importMovieSearchControllerProvider.notifier).search(value);
    });
  }

  void _submit(String value) {
    _debounce?.cancel();
    ref.read(importMovieSearchControllerProvider.notifier).search(value);
  }

  void _selectMovie(TmdbSearchResult movie) {
    ref
        .read(importControllerProvider.notifier)
        .selectCandidate(widget.rowIndex, movie);
    if (mounted) context.pop();
  }

  Future<void> _assignMovieBundle(TmdbSearchResult movie) async {
    try {
      final details = await ref
          .read(tmdbApiClientProvider)
          .getMovieDetails(movie.id);
      final collectionId = details.collection?.id;
      if (!mounted) return;
      if (collectionId == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Dieser Film gehört zu keiner bekannten Filmreihe.'),
          ),
        );
        return;
      }
      context.push(
        '/import/selection/${widget.rowIndex}?collectionId=$collectionId&closeSearch=1',
      );
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$error')));
    }
  }

  void _selectTv(TmdbTvSearchResult series) {
    context.push(
      '/import/selection/${widget.rowIndex}?seriesId=${series.id}&closeSearch=1',
    );
  }

  void _continueWithoutMovie() {
    ref.read(importControllerProvider.notifier).skipRow(widget.rowIndex);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final row = _row;
    final searchState = ref.watch(importMovieSearchControllerProvider);
    final media = searchState.valueOrNull?.media ?? widget.initialMedia;
    final isTv = media == ImportSearchMedia.tv;

    return Scaffold(
      appBar: AppBar(title: Text(isTv ? 'Serie zuordnen' : 'Film zuordnen')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (row != null) ...[
                  const Text(
                    'Importierter Titel',
                    style: TextStyle(
                      color: AppColors.neutralGray,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '„${row.rawLine}“',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 12),
                ],
                SegmentedButton<ImportSearchMedia>(
                  segments: const [
                    ButtonSegment(
                      value: ImportSearchMedia.movie,
                      label: Text('Filme'),
                    ),
                    ButtonSegment(
                      value: ImportSearchMedia.tv,
                      label: Text('Serien'),
                    ),
                  ],
                  selected: {media},
                  onSelectionChanged: (value) {
                    ref
                        .read(importMovieSearchControllerProvider.notifier)
                        .setMedia(value.first);
                    if (_controller.text.trim().isNotEmpty) {
                      ref
                          .read(importMovieSearchControllerProvider.notifier)
                          .search(_controller.text);
                    }
                  },
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: isTv
                        ? 'Serientitel suchen…'
                        : 'Filmtitel suchen…',
                    prefixIcon: const Icon(Icons.search),
                  ),
                  onChanged: _onChanged,
                  onSubmitted: _submit,
                ),
              ],
            ),
          ),
          Expanded(
            child: searchState.when(
              loading: () => const LoadingView(),
              error: (error, stack) => ErrorView(
                error: error,
                onRetry: () => _submit(_controller.text),
              ),
              data: (data) {
                if (_controller.text.trim().isEmpty) {
                  return EmptyState(
                    icon: Icons.search,
                    title: isTv ? 'Serie suchen' : 'Film suchen',
                    message: isTv
                        ? 'Gib einen Serientitel ein, um bei TMDB zu suchen.'
                        : 'Gib einen Filmtitel ein, um bei TMDB zu suchen.',
                  );
                }
                if (isTv) {
                  if (data.tvResults.isEmpty) {
                    return const EmptyState(
                      icon: Icons.tv_outlined,
                      title: 'Keine Treffer',
                      message: 'Versuche einen anderen Suchbegriff.',
                    );
                  }
                  return ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemCount: data.tvResults.length + (data.hasMore ? 1 : 0),
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (context, index) {
                      if (index >= data.tvResults.length) {
                        return _LoadMore(isLoading: data.isLoadingMore);
                      }
                      final series = data.tvResults[index];
                      return MovieSearchResultTile.fromTvResult(
                        series,
                        onTap: () => _selectTv(series),
                      );
                    },
                  );
                }
                if (data.results.isEmpty) {
                  return const EmptyState(
                    icon: Icons.movie_filter_outlined,
                    title: 'Keine Treffer',
                    message: 'Versuche einen anderen Suchbegriff.',
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  itemCount: data.results.length + (data.hasMore ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    if (index >= data.results.length) {
                      return _LoadMore(isLoading: data.isLoadingMore);
                    }
                    final movie = data.results[index];
                    return Column(
                      children: [
                        MovieSearchResultTile.fromResult(
                          movie,
                          onTap: () => _selectMovie(movie),
                        ),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () => _assignMovieBundle(movie),
                            child: const Text(
                              'Als Filmreihe / Box Set zuordnen',
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: OutlinedButton(
                onPressed: _continueWithoutMovie,
                child: const Text('Ohne Zuordnung fortfahren'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadMore extends ConsumerWidget {
  const _LoadMore({required this.isLoading});

  final bool isLoading;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: isLoading
            ? const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : OutlinedButton(
                onPressed: () => ref
                    .read(importMovieSearchControllerProvider.notifier)
                    .loadMore(),
                child: const Text('Mehr laden'),
              ),
      ),
    );
  }
}
