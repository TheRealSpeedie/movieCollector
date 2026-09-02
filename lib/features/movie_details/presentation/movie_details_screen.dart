import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/widgets/collection_completeness_view.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../collections/application/collections_providers.dart';
import '../../movies/application/movie_providers.dart';
import '../../scanner/application/barcode_providers.dart';

class MovieDetailsScreen extends ConsumerStatefulWidget {
  const MovieDetailsScreen({super.key, required this.movieId});

  final int movieId;

  @override
  ConsumerState<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends ConsumerState<MovieDetailsScreen> {
  bool _refreshing = false;

  @override
  Widget build(BuildContext context) {
    final movieAsync = ref.watch(movieByIdProvider(widget.movieId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Filmdetails'),
        actions: [
          IconButton(
            icon: _refreshing
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.refresh),
            tooltip: 'Metadaten aktualisieren',
            onPressed: _refreshing ? null : () => _refresh(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            tooltip: 'Aus Sammlung entfernen',
            onPressed: () => _confirmDelete(context),
          ),
        ],
      ),
      body: movieAsync.when(
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(error: error),
        data: (movie) {
          if (movie == null) {
            return const Center(
              child: Text('Dieser Film wurde nicht gefunden.'),
            );
          }
          return _buildContent(context, movie);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Movie movie) {
    final barcodesAsync = ref.watch(barcodesForMovieProvider(movie.id));

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: SizedBox(
            width: 200,
            child: PosterImage(posterPath: movie.posterPath),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          movie.title,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        if (movie.originalTitle != null && movie.originalTitle != movie.title)
          Center(
            child: Text(
              movie.originalTitle!,
              style: const TextStyle(color: AppColors.neutralGray),
              textAlign: TextAlign.center,
            ),
          ),
        const SizedBox(height: 12),
        Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (movie.releaseYear != null)
                Chip(label: Text('${movie.releaseYear}')),
              if (movie.runtime != null)
                Chip(label: Text('${movie.runtime} Min.')),
              if (movie.certification != null)
                Chip(label: Text('FSK ${movie.certification}')),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Center(child: StatusChip(status: movie.status)),
        if (movie.genres.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            movie.genres.join(' · '),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.neutralGray),
          ),
        ],
        if (movie.overview != null && movie.overview!.isNotEmpty) ...[
          const SizedBox(height: 20),
          Text('Beschreibung', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(movie.overview!),
        ],
        const SizedBox(height: 24),
        Text('Status ändern', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 8),
        SegmentedButton<CollectionStatus>(
          segments: CollectionStatus.values
              .map((s) => ButtonSegment(value: s, label: Text(s.germanLabel)))
              .toList(),
          selected: {movie.status},
          onSelectionChanged: (selection) =>
              _changeStatus(selection.first, movie),
        ),
        if (movie.tmdbCollectionId != null) ...[
          const SizedBox(height: 24),
          Consumer(
            builder: (context, ref, _) {
              final collectionAsync = ref.watch(
                collectionByTmdbIdProvider(movie.tmdbCollectionId!),
              );
              return collectionAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (error, stack) => const SizedBox.shrink(),
                data: (collection) {
                  if (collection == null) return const SizedBox.shrink();
                  return GestureDetector(
                    onTap: () => context.push('/collections/${collection.id}'),
                    child: CollectionCompletenessView(
                      collection: collection,
                      highlightTmdbMovieId: movie.tmdbId,
                    ),
                  );
                },
              );
            },
          ),
        ],
        const SizedBox(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Barcode-Ausgaben',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            TextButton.icon(
              onPressed: () => _addBarcode(context, movie),
              icon: const Icon(Icons.add),
              label: const Text('Hinzufügen'),
            ),
          ],
        ),
        barcodesAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (error, stack) => const SizedBox.shrink(),
          data: (barcodes) {
            if (barcodes.isEmpty) {
              return const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Noch keine Barcodes hinterlegt.',
                  style: TextStyle(color: AppColors.neutralGray),
                ),
              );
            }
            return Column(
              children: barcodes
                  .map(
                    (b) => ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.qr_code),
                      title: Text(b.barcode),
                      subtitle: Text(
                        [
                          b.barcodeType,
                          if (b.editionName != null) b.editionName!,
                        ].join(' · '),
                      ),
                    ),
                  )
                  .toList(),
            );
          },
        ),
        const SizedBox(height: 24),
        if (movie.lastMetadataSyncAt != null)
          Text(
            'Metadaten zuletzt aktualisiert: ${DateFormat('dd.MM.yyyy, HH:mm').format(movie.lastMetadataSyncAt!)}',
            style: const TextStyle(color: AppColors.neutralGray, fontSize: 12),
          ),
      ],
    );
  }

  Future<void> _changeStatus(CollectionStatus status, Movie movie) async {
    if (status == movie.status) return;
    await ref.read(movieRepositoryProvider).updateStatus(movie.id, status);
  }

  Future<void> _refresh(BuildContext context) async {
    setState(() => _refreshing = true);
    try {
      await ref.read(movieRepositoryProvider).refreshMetadata(widget.movieId);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Metadaten aktualisiert.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(describeError(error))));
      }
    } finally {
      if (mounted) setState(() => _refreshing = false);
    }
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await showConfirmDialog(
      context,
      title: 'Film entfernen',
      message:
          'Möchtest du diesen Film wirklich aus deiner Sammlung entfernen? Diese Aktion kann nicht rückgängig gemacht werden.',
      confirmLabel: 'Entfernen',
      destructive: true,
    );
    if (!confirmed) return;
    await ref.read(movieRepositoryProvider).deleteMovie(widget.movieId);
    if (context.mounted) context.pop();
  }

  Future<void> _addBarcode(BuildContext context, Movie movie) async {
    final barcodeController = TextEditingController();
    final editionController = TextEditingController();
    final result = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Barcode hinzufügen',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: barcodeController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Barcode (EAN/UPC)'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: editionController,
              decoration: const InputDecoration(
                labelText: 'Ausgabe (optional, z. B. Steelbook)',
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Speichern'),
              ),
            ),
          ],
        ),
      ),
    );
    if (result != true) return;
    final barcode = barcodeController.text.trim();
    if (barcode.isEmpty) return;
    try {
      await ref
          .read(barcodeRepositoryProvider)
          .saveMapping(
            barcode: barcode,
            barcodeType: 'EAN',
            movieId: movie.id,
            editionName: editionController.text.trim().isEmpty
                ? null
                : editionController.text.trim(),
            allowRemap: true,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Barcode gespeichert.')));
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(describeError(error))));
      }
    }
  }
}
