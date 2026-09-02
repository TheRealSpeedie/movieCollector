import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/movie_search_result_tile.dart';
import '../application/search_providers.dart';

class MovieSearchScreen extends ConsumerStatefulWidget {
  const MovieSearchScreen({super.key});

  @override
  ConsumerState<MovieSearchScreen> createState() => _MovieSearchScreenState();
}

class _MovieSearchScreenState extends ConsumerState<MovieSearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

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
      body: resultsAsync.when(
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(
          error: error,
          onRetry: () => ref
              .read(movieSearchControllerProvider.notifier)
              .search(_controller.text),
        ),
        data: (results) {
          if (_controller.text.trim().isEmpty) {
            return const EmptyState(
              icon: Icons.search,
              title: 'Filmtitel suchen',
              message:
                  'Gib den Titel eines Films ein, um ihn bei TMDB zu finden.',
            );
          }
          if (results.isEmpty) {
            return const EmptyState(
              icon: Icons.movie_filter_outlined,
              title: 'Keine Treffer',
              message: 'Versuche einen anderen Suchbegriff.',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: results.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final result = results[index];
              return MovieSearchResultTile.fromResult(
                result,
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => context.push('/search/add/${result.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
