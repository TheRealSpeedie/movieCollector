import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/config/config_providers.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/health/service_health.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/media_card.dart';
import '../../../shared/widgets/movie_search_result_tile.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../shared/models/movie.dart';
import '../../movies/application/movie_providers.dart';
import '../../scanner/domain/barcode_search_context.dart';
import '../application/search_providers.dart';

class MovieSearchScreen extends ConsumerStatefulWidget {
  const MovieSearchScreen({
    super.key,
    this.scan = const BarcodeSearchContext(),
  });

  final BarcodeSearchContext scan;

  @override
  ConsumerState<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends ConsumerState<MovieSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    final query = widget.scan.query;
    if (query != null && query.isNotEmpty) {
      _controller.text = query;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        ref.read(movieSearchControllerProvider.notifier).search(query);
      });
    }
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
      ref.read(movieSearchControllerProvider.notifier).search(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final resultsAsync = ref.watch(movieSearchControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Filmtitel eingeben…',
            border: InputBorder.none,
          ),
          onChanged: _onChanged,
          onSubmitted: (value) =>
              ref.read(movieSearchControllerProvider.notifier).search(value),
        ),
      ),
      body: _Results(
        query: _controller.text.trim(),
        searchedQuery: ref
            .read(movieSearchControllerProvider.notifier)
            .lastQuery,
        results: resultsAsync,
        scan: widget.scan,
        onRetry: () => ref
            .read(movieSearchControllerProvider.notifier)
            .search(_controller.text),
      ),
    );
  }
}

/// Search results in two parts: what is already on the shelf (instant,
/// offline, works without TMDB) and what TMDB knows. A TMDB result already
/// in the collection says so and opens it instead of adding it again.
class _Results extends ConsumerWidget {
  const _Results({
    required this.query,
    required this.searchedQuery,
    required this.results,
    required this.scan,
    required this.onRetry,
  });

  final String query;

  /// The query the results belong to; differs from [query] while typing.
  final String searchedQuery;
  final AsyncValue<List<TmdbSearchResult>> results;
  final BarcodeSearchContext scan;
  final VoidCallback onRetry;

  static String _fold(String s) => s.toLowerCase().trim();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tmdbReady = ref.watch(tmdbConfiguredProvider);
    final movies = ref.watch(allMoviesProvider).valueOrNull ?? const <Movie>[];
    final byTmdbId = {
      for (final m in movies)
        if (m.tmdbId != null) m.tmdbId!: m,
    };

    if (query.isEmpty) {
      if (!tmdbReady) {
        // Say it before anyone types, not as "Keine Treffer" after.
        return const ErrorView(
          error: ServiceNotConfiguredException(ExternalService.tmdb),
        );
      }
      return const EmptyState(
        icon: Icons.search,
        title: 'Filmtitel suchen',
        message:
            'Speednema sucht in deiner Sammlung und bei TMDB, um neue Filme '
            'hinzuzufügen.',
      );
    }

    final needle = _fold(query);
    final own = [
      for (final m in movies)
        if (_fold(m.title).contains(needle) ||
            (m.originalTitle != null &&
                _fold(m.originalTitle!).contains(needle)))
          m,
    ].take(5).toList();
    // From the scanner, a film already owned still goes through adding, so
    // the barcode and edition are recorded.
    final openOwned = !scan.hasBarcode;

    final tmdb = !tmdbReady || searchedQuery != query
        ? null
        : results.when(
            loading: () => null,
            error: (e, _) => <Widget>[
              ErrorView.compact(error: e, onRetry: onRetry),
            ],
            data: (list) => [
              for (final r in list)
                MovieSearchResultTile.fromResult(
                  r,
                  trailing: byTmdbId.containsKey(r.id)
                      ? const _InCollectionChip()
                      : const Icon(Icons.chevron_right),
                  onTap: () {
                    final owned = byTmdbId[r.id];
                    if (owned != null && openOwned) {
                      context.push('/movie/${owned.id}');
                    } else {
                      context.push(
                        scan
                            .copyForAdd(r.id)
                            .location(path: '/search/add/${r.id}'),
                      );
                    }
                  },
                ),
            ],
          );

    final tmdbEmpty = tmdb != null && tmdb.isEmpty;
    if (own.isEmpty && tmdbEmpty) {
      return const EmptyState(
        icon: Icons.movie_filter_outlined,
        title: 'Keine Treffer',
        message:
            'Weder in deiner Sammlung noch bei TMDB. Versuche einen anderen Titel.',
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      children: [
        if (own.isNotEmpty) ...[
          const SectionHeader(title: 'In deiner Sammlung'),
          for (final m in own)
            MediaRow(
              title: m.title,
              posterPath: m.posterPath,
              subtitle: m.releaseYear?.toString(),
              status: m.status,
              onTap: () => context.push('/movie/${m.id}'),
            ),
          const SizedBox(height: AppSpacing.l),
        ],
        const SectionHeader(title: 'Neu hinzufügen'),
        const SizedBox(height: AppSpacing.s),
        if (!tmdbReady)
          const ErrorView.compact(
            error: ServiceNotConfiguredException(ExternalService.tmdb),
          )
        else if (tmdb == null)
          const Padding(
            padding: EdgeInsets.all(AppSpacing.xl),
            child: Center(child: CircularProgressIndicator()),
          )
        else if (tmdbEmpty)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: Text('Bei TMDB nichts gefunden.'),
          )
        else
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.m),
            child: Column(
              children: [
                for (final tile in tmdb) ...[
                  tile,
                  const SizedBox(height: AppSpacing.s + 2),
                ],
              ],
            ),
          ),
      ],
    );
  }
}

class _InCollectionChip extends StatelessWidget {
  const _InCollectionChip();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: 2,
      ),
      decoration: ShapeDecoration(
        color: colors.tint(colors.owned),
        shape: const StadiumBorder(),
      ),
      child: Text(
        'In deiner Sammlung',
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colors.owned,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
