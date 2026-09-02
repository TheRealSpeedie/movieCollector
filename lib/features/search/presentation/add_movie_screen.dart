import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/widgets/error_view.dart' show ErrorView, describeError;
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../movies/application/movie_providers.dart';
import '../application/search_providers.dart';

class AddMovieScreen extends ConsumerStatefulWidget {
  const AddMovieScreen({super.key, required this.tmdbId});

  final int tmdbId;

  @override
  ConsumerState<AddMovieScreen> createState() => _AddMovieScreenState();
}

class _AddMovieScreenState extends ConsumerState<AddMovieScreen> {
  CollectionStatus _status = CollectionStatus.owned;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    final detailsAsync = ref.watch(tmdbMovieDetailsProvider(widget.tmdbId));
    final existingAsync = ref.watch(movieByTmdbIdProvider(widget.tmdbId));

    return Scaffold(
      appBar: AppBar(title: const Text('Film hinzufügen')),
      body: detailsAsync.when(
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(error: error),
        data: (details) {
          final existing = existingAsync.valueOrNull;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 120,
                    child: PosterImage(posterPath: details.posterPath),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          details.title,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        if (details.originalTitle != null &&
                            details.originalTitle != details.title)
                          Text(
                            details.originalTitle!,
                            style: const TextStyle(
                              color: AppColors.neutralGray,
                            ),
                          ),
                        const SizedBox(height: 6),
                        Wrap(
                          spacing: 8,
                          runSpacing: 4,
                          children: [
                            if (details.releaseYear != null)
                              Text('${details.releaseYear}'),
                            if (details.runtime != null)
                              Text('${details.runtime} Min.'),
                            if (details.certification != null)
                              Text('FSK ${details.certification}'),
                          ],
                        ),
                        if (details.genres.isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text(
                            details.genres.map((g) => g.name).join(', '),
                            style: const TextStyle(
                              color: AppColors.neutralGray,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
              if (details.collection != null) ...[
                const SizedBox(height: 16),
                Card(
                  child: ListTile(
                    leading: const Icon(
                      Icons.collections_bookmark_outlined,
                      color: AppColors.dustyRose,
                    ),
                    title: Text('Teil der Reihe: ${details.collection!.name}'),
                    subtitle: const Text(
                      'Wird beim Speichern automatisch abgeglichen.',
                    ),
                  ),
                ),
              ],
              if (details.overview != null && details.overview!.isNotEmpty) ...[
                const SizedBox(height: 16),
                Text(details.overview!),
              ],
              const SizedBox(height: 24),
              if (existing != null) ...[
                Card(
                  color: AppColors.sage.withValues(alpha: 0.12),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Dieser Film ist bereits in deiner Sammlung.',
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 8),
                        StatusChip(status: existing.status),
                        const SizedBox(height: 12),
                        OutlinedButton(
                          onPressed: () =>
                              context.push('/movie/${existing.id}'),
                          child: const Text('Zu den Details'),
                        ),
                      ],
                    ),
                  ),
                ),
              ] else ...[
                Text('Status', style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 8),
                SegmentedButton<CollectionStatus>(
                  segments: CollectionStatus.values
                      .map(
                        (s) =>
                            ButtonSegment(value: s, label: Text(s.germanLabel)),
                      )
                      .toList(),
                  selected: {_status},
                  onSelectionChanged: (selection) =>
                      setState(() => _status = selection.first),
                ),
                const SizedBox(height: 24),
                FilledButton.icon(
                  onPressed: _saving ? null : () => _save(details.id),
                  icon: _saving
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.check),
                  label: const Text('Speichern'),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Future<void> _save(int tmdbId) async {
    setState(() => _saving = true);
    try {
      final movie = await ref
          .read(movieRepositoryProvider)
          .addFromTmdb(tmdbId, status: _status);
      if (!mounted) return;
      context.go('/movie/${movie.id}');
    } catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(describeError(error))));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
