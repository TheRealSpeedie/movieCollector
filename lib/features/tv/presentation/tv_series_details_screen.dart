import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/utils/season_format.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/tv_season.dart';
import '../../../shared/models/tv_series_with_seasons.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../../shared/widgets/status_chip.dart';
import '../application/tv_providers.dart';

class TvSeriesDetailsScreen extends ConsumerWidget {
  const TvSeriesDetailsScreen({super.key, required this.seriesId});

  final int seriesId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final seriesAsync = ref.watch(tvSeriesByIdProvider(seriesId));

    return Scaffold(
      appBar: AppBar(title: const Text('Serie')),
      body: seriesAsync.when(
        loading: () => const LoadingView(),
        error: (error, stack) => ErrorView(error: error),
        data: (data) {
          if (data == null) {
            return const Center(
              child: Text('Diese Serie wurde nicht gefunden.'),
            );
          }
          return _SeriesBody(data: data);
        },
      ),
    );
  }
}

class _SeriesBody extends ConsumerWidget {
  const _SeriesBody({required this.data});

  final TvSeriesWithSeasons data;

  Future<void> _setAll(
    BuildContext context,
    WidgetRef ref,
    CollectionStatus status,
  ) async {
    final confirmed = await showConfirmDialog(
      context,
      title: status == CollectionStatus.owned
          ? 'Alle als gekauft markieren?'
          : 'Alle zur Wunschliste?',
      message: status == CollectionStatus.owned
          ? 'Alle regulären Staffeln von ${data.series.name} werden als gekauft gespeichert. Specials bleiben unverändert.'
          : 'Alle regulären Staffeln von ${data.series.name} werden auf die Wunschliste gesetzt. Specials bleiben unverändert.',
      confirmLabel: 'Übernehmen',
    );
    if (!confirmed) return;
    await ref
        .read(tvRepositoryProvider)
        .setRegularSeasonsStatus(data.series.id, status);
  }

  Future<void> _setSeason(
    WidgetRef ref,
    TvSeason season,
    CollectionStatus? status,
  ) {
    return ref.read(tvRepositoryProvider).setSeasonStatus(season.id, status);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final series = data.series;
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Center(
          child: SizedBox(
            width: 200,
            child: PosterImage(posterPath: series.posterPath),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          series.name,
          style: Theme.of(context).textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        if (series.originalName != null && series.originalName != series.name)
          Center(
            child: Text(
              series.originalName!,
              style: const TextStyle(color: AppColors.neutralGray),
            ),
          ),
        const SizedBox(height: 12),
        Center(
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              if (series.firstAirYear != null)
                Chip(label: Text('${series.firstAirYear}')),
              if (series.contentRating != null)
                Chip(label: Text('FSK ${series.contentRating}')),
            ],
          ),
        ),
        if (series.genres.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            series.genres.join(' · '),
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.neutralGray),
          ),
        ],
        const SizedBox(height: 16),
        Text(
          data.progressLabel,
          textAlign: TextAlign.center,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        if (series.overview != null && series.overview!.isNotEmpty) ...[
          const SizedBox(height: 16),
          Text(series.overview!),
        ],
        const SizedBox(height: 20),
        FilledButton.tonal(
          onPressed: () => _setAll(context, ref, CollectionStatus.owned),
          child: const Text('Alle als gekauft markieren'),
        ),
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: () => _setAll(context, ref, CollectionStatus.wishlist),
          child: const Text('Alle zur Wunschliste'),
        ),
        const SizedBox(height: 20),
        for (final season in data.seasons)
          Card(
            child: ListTile(
              leading: SizedBox(
                width: 48,
                child: PosterImage(
                  posterPath: season.posterPath ?? series.posterPath,
                  borderRadius: 8,
                ),
              ),
              title: Text(seasonLabel(season.seasonNumber)),
              subtitle: Text(
                [
                  if (season.airDate != null) '${season.airDate!.year}',
                  if (season.episodeCount != null)
                    '${season.episodeCount} Folgen',
                ].join(' · '),
              ),
              trailing: season.status == null
                  ? const MissingChip()
                  : StatusChip(status: season.status!, compact: true),
              onTap: () => _pickStatus(context, ref, season),
            ),
          ),
      ],
    );
  }

  Future<void> _pickStatus(
    BuildContext context,
    WidgetRef ref,
    TvSeason season,
  ) async {
    final selected = await showModalBottomSheet<String>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(seasonLabel(season.seasonNumber)),
              subtitle: const Text('Status wählen'),
            ),
            for (final status in CollectionStatus.values)
              ListTile(
                leading: Icon(
                  iconForStatus(status),
                  color: colorForStatus(status),
                ),
                title: Text(status.germanLabel),
                onTap: () => Navigator.pop(context, status.name),
              ),
            ListTile(
              leading: const Icon(Icons.remove_circle_outline),
              title: const Text('Fehlt'),
              onTap: () => Navigator.pop(context, 'missing'),
            ),
          ],
        ),
      ),
    );
    if (selected == null) return;
    await _setSeason(
      ref,
      season,
      selected == 'missing' ? null : CollectionStatus.fromName(selected),
    );
  }
}
