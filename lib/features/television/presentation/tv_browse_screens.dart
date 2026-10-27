import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../server/application/server_providers.dart';
import '../../server/data/library_repository.dart';
import '../../server/domain/server_models.dart';
import '../application/tv_providers.dart';
import 'tv_focusable.dart';
import 'tv_home_screen.dart';

/// All films or all series as a poster grid.
class TvLibraryScreen extends ConsumerWidget {
  const TvLibraryScreen({super.key, required this.kind});

  /// Movie or Series.
  final String kind;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final titles = ref.watch(tvTitlesProvider(kind));
    return TvPage(
      child: titles.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(tvTitlesProvider(kind)),
        ),
        data: (items) => _PosterGrid(
          title: kind == 'Movie' ? 'Filme' : 'Serien',
          empty: kind == 'Movie'
              ? 'Noch keine Filme auf dem Server.'
              : 'Noch keine Serien auf dem Server.',
          titles: items,
        ),
      ),
    );
  }
}

/// Everything started but not finished, and the next episodes.
class TvContinueScreen extends ConsumerWidget {
  const TvContinueScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(serverHomeProvider);
    return TvPage(
      child: home.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(serverHomeProvider),
        ),
        data: (data) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weiterschauen',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (data.resume.isEmpty)
              const Text(
                'Nichts angefangen. Was du schaust, erscheint hier.',
                style: TextStyle(color: AppColors.neutralGray),
              )
            else
              Expanded(
                child: GridView.extent(
                  maxCrossAxisExtent: 360,
                  childAspectRatio: 16 / 11,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  padding: const EdgeInsets.all(8),
                  children: [
                    for (final (i, item) in data.resume.indexed)
                      TvResumeTile(item: item, autofocus: i == 0),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

final _searchProvider = FutureProvider.autoDispose
    .family<List<ServerTitle>, String>((ref, query) async {
      if (query.trim().length < 2) return const [];
      final page = await ref
          .watch(libraryRepositoryProvider)!
          .titles(TitleQuery(search: query), limit: 60);
      return page.items;
    });

/// Search the server library with the TV keyboard.
class TvSearchScreen extends ConsumerStatefulWidget {
  const TvSearchScreen({super.key});

  @override
  ConsumerState<TvSearchScreen> createState() => _TvSearchScreenState();
}

class _TvSearchScreenState extends ConsumerState<TvSearchScreen> {
  var _query = '';
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final results = ref.watch(_searchProvider(_query));
    return TvPage(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            autofocus: true,
            style: const TextStyle(fontSize: 22),
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: 'Film oder Serie suchen',
            ),
            onChanged: (value) {
              _debounce?.cancel();
              _debounce = Timer(
                const Duration(milliseconds: 400),
                () => setState(() => _query = value),
              );
            },
          ),
          const SizedBox(height: 16),
          Expanded(
            child: results.when(
              loading: () => const LoadingView(),
              error: (error, _) => ErrorView(error: error),
              data: (items) => _query.trim().length < 2
                  ? const SizedBox.shrink()
                  : _PosterGrid(
                      title: null,
                      empty: 'Nichts gefunden.',
                      titles: items,
                      autofocus: false,
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PosterGrid extends StatelessWidget {
  const _PosterGrid({
    required this.title,
    required this.empty,
    required this.titles,
    this.autofocus = true,
  });

  final String? title;
  final String empty;
  final List<ServerTitle> titles;
  final bool autofocus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title != null) ...[
          Text(title!, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
        ],
        if (titles.isEmpty)
          Text(empty, style: const TextStyle(color: AppColors.neutralGray))
        else
          Expanded(
            child: GridView.extent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 2 / 3.6,
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              padding: const EdgeInsets.all(8),
              children: [
                for (final (i, item) in titles.indexed)
                  TvPosterTile(title: item, autofocus: autofocus && i == 0),
              ],
            ),
          ),
      ],
    );
  }
}
