import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/utils/season_format.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/movie_search_result_tile.dart';
import '../application/import_controller.dart';
import '../domain/import_models.dart';

class ImportScreen extends ConsumerWidget {
  const ImportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importControllerProvider);

    return PopScope(
      canPop: state.phase != ImportPhase.committing,
      child: Scaffold(
        appBar: AppBar(title: const Text('Importieren')),
        body: switch (state.phase) {
          ImportPhase.input => const _InputView(),
          ImportPhase.analyzing => const LoadingView(
            message: 'Titel werden mit TMDB abgeglichen…',
          ),
          ImportPhase.review => const _ReviewView(),
          ImportPhase.committing => const _CommitProgressView(),
          ImportPhase.done => const _DoneView(),
          ImportPhase.error => _ErrorView(
            message: state.errorMessage ?? 'Unbekannter Fehler',
          ),
        },
      ),
    );
  }
}

class _InputView extends ConsumerStatefulWidget {
  const _InputView();

  @override
  ConsumerState<_InputView> createState() => _InputViewState();
}

class _InputViewState extends ConsumerState<_InputView> {
  final _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['txt', 'csv'],
    );
    final path = result?.files.single.path;
    if (path == null) return;
    final content = await File(path).readAsString();
    if (!mounted) return;
    if (path.toLowerCase().endsWith('.csv')) {
      await ref.read(importControllerProvider.notifier).analyzeCsv(content);
    } else {
      await ref
          .read(importControllerProvider.notifier)
          .analyzePlainText(content);
    }
  }

  @override
  Widget build(BuildContext context) {
    final defaultStatus = ref.watch(importControllerProvider).defaultStatus;
    final notifier = ref.read(importControllerProvider.notifier);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          'Füge eine Liste mit Filmen oder Serien ein oder importiere eine TXT-/CSV-Datei. '
          'Unordentliche Listen mit Aufzählungszeichen, Checkboxen oder Nummerierungen werden automatisch bereinigt.',
          style: const TextStyle(color: AppColors.neutralGray),
        ),
        const SizedBox(height: 16),
        TextField(
          controller: _textController,
          maxLines: 10,
          decoration: const InputDecoration(
            hintText:
                'Harry Potter 1\nSupernatural Staffel 4\nSharknado Collector\'s Box',
            alignLabelWithHint: true,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Standardstatus für neue Einträge',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        SegmentedButton<CollectionStatus>(
          segments: CollectionStatus.values
              .map((s) => ButtonSegment(value: s, label: Text(s.germanLabel)))
              .toList(),
          selected: {defaultStatus},
          onSelectionChanged: (selection) =>
              notifier.setDefaultStatus(selection.first),
        ),
        const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: () {
            if (_textController.text.trim().isEmpty) return;
            notifier.analyzePlainText(_textController.text);
          },
          icon: const Icon(Icons.playlist_add_check),
          label: const Text('Liste analysieren'),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: _pickFile,
          icon: const Icon(Icons.upload_file_outlined),
          label: const Text('TXT- oder CSV-Datei auswählen'),
        ),
      ],
    );
  }
}

class _ReviewView extends ConsumerWidget {
  const _ReviewView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(importControllerProvider);
    final notifier = ref.read(importControllerProvider.notifier);
    final summary = state.summary;

    return Column(
      children: [
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _SummaryChip(
                label: 'Gesamt',
                value: summary.totalLines,
                color: AppColors.charcoal,
              ),
              const SizedBox(width: 8),
              _SummaryChip(
                label: 'Erkannt',
                value: summary.matchedAutomatically,
                color: AppColors.sage,
              ),
              const SizedBox(width: 8),
              _SummaryChip(
                label: 'Manuell zugeordnet',
                value: summary.matchedManually,
                color: AppColors.dustyRose,
              ),
              const SizedBox(width: 8),
              _SummaryChip(
                label: 'Unklar',
                value: summary.ambiguous,
                color: AppColors.amber,
              ),
              const SizedBox(width: 8),
              _SummaryChip(
                label: 'Nicht gefunden',
                value: summary.notFound,
                color: AppColors.errorRed,
              ),
              const SizedBox(width: 8),
              _SummaryChip(
                label: 'Übersprungen',
                value: summary.skipped,
                color: AppColors.neutralGray,
              ),
              const SizedBox(width: 8),
              _SummaryChip(
                label: 'Duplikate',
                value: summary.duplicates,
                color: AppColors.neutralGray,
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: state.rows.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final row = state.rows[index];
              return _ImportRowTile(row: row, notifier: notifier);
            },
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: FilledButton.icon(
              onPressed: () => notifier.commit(),
              icon: const Icon(Icons.save_outlined),
              label: const Text('Import starten'),
            ),
          ),
        ),
      ],
    );
  }
}

class _SummaryChip extends StatelessWidget {
  const _SummaryChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(color: color, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _ImportRowTile extends StatelessWidget {
  const _ImportRowTile({required this.row, required this.notifier});

  final ImportRow row;
  final ImportController notifier;

  static const _statusStyle = {
    ImportRowStatus.matchedAutomatically: ('Erkannt', AppColors.sage),
    ImportRowStatus.matchedManually: (
      'Manuell zugeordnet',
      AppColors.dustyRose,
    ),
    ImportRowStatus.ambiguous: ('Nicht eindeutig erkannt', AppColors.amber),
    ImportRowStatus.notFound: (
      'Kein passender Titel erkannt',
      AppColors.errorRed,
    ),
    ImportRowStatus.duplicate: ('Bereits vorhanden', AppColors.neutralGray),
    ImportRowStatus.skipped: ('Ohne Zuordnung', AppColors.neutralGray),
  };

  void _openManualSearch(BuildContext context, {bool tv = false}) {
    final media = tv ? 'tv' : 'movie';
    context.push('/import/movie-search/${row.index}?media=$media');
  }

  void _openSelection(BuildContext context) {
    final target = row.target;
    final collectionId = switch (target) {
      ImportTargetMovieBundle(:final collection) => collection.id,
      _ => null,
    };
    final seriesId = switch (target) {
      ImportTargetSingleTvSeason(:final series) => series.id,
      ImportTargetTvSeasonBundle(:final series) => series.id,
      ImportTargetCompleteTvSeries(:final series) => series.id,
      _ => null,
    };
    final params = <String>[];
    if (collectionId != null) params.add('collectionId=$collectionId');
    if (seriesId != null) params.add('seriesId=$seriesId');
    context.push(
      '/import/selection/${row.index}${params.isEmpty ? '' : '?${params.join('&')}'}',
    );
  }

  @override
  Widget build(BuildContext context) {
    final target = row.target;
    final chipLabel =
        target != null &&
            target.isBundle &&
            row.status != ImportRowStatus.skipped
        ? target.kindLabel
        : _statusStyle[row.status]!.$1;
    final color = _statusStyle[row.status]!.$2;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    row.rawLine,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    chipLabel,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            if (target is ImportTargetSingleMovie)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '→ ${target.movie.title} (${target.movie.releaseYear ?? '–'})',
                  style: const TextStyle(color: AppColors.neutralGray),
                ),
              ),
            if (target is ImportTargetMovieBundle) ...[
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${target.collection.name}\n'
                  '${target.selectedTmdbIds.length} Filme ausgewählt',
                  style: const TextStyle(color: AppColors.neutralGray),
                ),
              ),
              for (final part
                  in target.collection.parts
                      .where((p) => target.selectedTmdbIds.contains(p.id))
                      .take(8))
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text('✓ ${part.title}'),
                ),
              TextButton(
                onPressed: () => _openSelection(context),
                child: const Text('Auswahl bearbeiten'),
              ),
            ],
            if (target is ImportTargetCompleteTvSeries ||
                target is ImportTargetTvSeasonBundle ||
                target is ImportTargetSingleTvSeason) ...[
              Builder(
                builder: (context) {
                  final seriesName = switch (target) {
                    ImportTargetCompleteTvSeries(:final series) => series.name,
                    ImportTargetTvSeasonBundle(:final series) => series.name,
                    ImportTargetSingleTvSeason(:final series) => series.name,
                    _ => '',
                  };
                  final selected = switch (target) {
                    ImportTargetCompleteTvSeries(
                      :final selectedSeasonNumbers,
                    ) =>
                      selectedSeasonNumbers,
                    ImportTargetTvSeasonBundle(:final selectedSeasonNumbers) =>
                      selectedSeasonNumbers,
                    ImportTargetSingleTvSeason(:final seasonNumber) => [
                      seasonNumber,
                    ],
                    _ => const <int>[],
                  };
                  final total = switch (target) {
                    ImportTargetCompleteTvSeries(:final details) =>
                      details.regularSeasons.length,
                    ImportTargetTvSeasonBundle(:final details) =>
                      details.regularSeasons.length,
                    ImportTargetSingleTvSeason(:final details) =>
                      details.regularSeasons.length,
                    _ => selected.length,
                  };
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          seriesName,
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          '${selected.where((n) => n > 0).length} / $total Staffeln ausgewählt',
                          style: const TextStyle(color: AppColors.neutralGray),
                        ),
                        const SizedBox(height: 4),
                        Text(formatSeasonSelection(selected)),
                        if (selected.length <= 8)
                          for (final number in selected)
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text('✓ ${seasonLabel(number)}'),
                            ),
                        TextButton(
                          onPressed: () => _openSelection(context),
                          child: const Text('Auswahl bearbeiten'),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
            if ((row.status == ImportRowStatus.matchedAutomatically ||
                    row.status == ImportRowStatus.matchedManually) &&
                row.selectedCandidate != null &&
                target is! ImportTargetSingleMovie)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  '→ ${row.selectedCandidate!.title} (${row.selectedCandidate!.releaseYear ?? '–'})',
                  style: const TextStyle(color: AppColors.neutralGray),
                ),
              ),
            if (row.status == ImportRowStatus.duplicate &&
                row.existingLocalMovie != null)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Text(
                  'Bereits in Sammlung: ${row.existingLocalMovie!.title}',
                  style: const TextStyle(color: AppColors.neutralGray),
                ),
              ),
            if (row.status == ImportRowStatus.skipped)
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Wird beim Import nicht berücksichtigt.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.neutralGray,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () => _openManualSearch(context),
                      child: const Text('Zuordnen'),
                    ),
                  ],
                ),
              ),
            if (row.status == ImportRowStatus.ambiguous &&
                row.target == null) ...[
              const SizedBox(height: 10),
              for (final candidate in row.candidates.take(4))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MovieSearchResultTile.fromResult(
                    candidate.result,
                    trailing: const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.dustyRose,
                    ),
                    onTap: () =>
                        notifier.selectCandidate(row.index, candidate.result),
                  ),
                ),
              for (final candidate in row.tvCandidates.take(4))
                Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: MovieSearchResultTile.fromTvResult(
                    candidate.result,
                    trailing: const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.dustyRose,
                    ),
                    onTap: () => context.push(
                      '/import/selection/${row.index}?seriesId=${candidate.result.id}',
                    ),
                  ),
                ),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _openManualSearch(
                        context,
                        tv: row.tvCandidates.isNotEmpty,
                      ),
                      child: const Text('Weitere Ergebnisse'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextButton(
                      onPressed: () => notifier.skipRow(row.index),
                      child: const Text('Ohne Zuordnung fortfahren'),
                    ),
                  ),
                ],
              ),
            ],
            if (row.status == ImportRowStatus.notFound) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _openManualSearch(context),
                      child: const Text('Film suchen'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton.tonal(
                      onPressed: () => _openManualSearch(context, tv: true),
                      child: const Text('Serie suchen'),
                    ),
                  ),
                ],
              ),
              TextButton(
                onPressed: () => notifier.skipRow(row.index),
                child: const Text('Ohne Zuordnung fortfahren'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CommitProgressView extends ConsumerWidget {
  const _CommitProgressView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progress = ref.watch(importControllerProvider).progress;
    final processed = progress?.processed ?? 0;
    final total = progress?.total ?? 0;
    final fraction = progress?.fraction ?? 0;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          Text(
            'Filme werden gespeichert',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 16),
          Text(
            '$processed / $total verarbeitet',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 16),
          LinearProgressIndicator(
            value: total == 0 ? null : fraction,
            minHeight: 10,
            borderRadius: BorderRadius.circular(8),
          ),
          if (progress?.currentTitle != null) ...[
            const SizedBox(height: 24),
            const Text(
              'Aktuell:',
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.neutralGray),
            ),
            const SizedBox(height: 4),
            Text(
              progress!.currentTitle!,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ],
          const SizedBox(height: 32),
          if ((progress?.moviesAdded ?? 0) > 0 ||
              (progress?.seasonsAdded ?? 0) > 0)
            Text(
              [
                if ((progress?.moviesAdded ?? 0) > 0)
                  '${progress!.moviesAdded} hinzugefügt',
                if ((progress?.seasonsAdded ?? 0) > 0)
                  '${progress!.seasonsAdded} Staffeln hinzugefügt',
              ].join('\n'),
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.sage),
            ),
          if ((progress?.alreadyExisted ?? 0) > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${progress!.alreadyExisted} bereits vorhanden',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.neutralGray),
            ),
          ],
          if ((progress?.skipped ?? 0) > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${progress!.skipped} übersprungen',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.neutralGray),
            ),
          ],
          if ((progress?.failed ?? 0) > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${progress!.failed} fehlgeschlagen',
              textAlign: TextAlign.center,
              style: const TextStyle(color: AppColors.errorRed),
            ),
          ],
        ],
      ),
    );
  }
}

class _DoneView extends ConsumerWidget {
  const _DoneView();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final report = ref.watch(importControllerProvider).commitReport;
    final failed = report?.failedSourceRows ?? 0;
    final processed = report?.processedSourceRows ?? 0;
    final successful = report?.successfulSourceRows ?? 0;
    final grouped = report?.failedOutcomesByCategory ?? {};
    final failedOutcomes =
        report?.outcomes
            .where((o) => o.kind == ImportRowOutcomeKind.failed)
            .toList() ??
        const [];

    final complete = failed == 0;
    final partial = report?.isPartialSuccess ?? false;

    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        Icon(
          complete ? Icons.check_circle_outline : Icons.error_outline,
          size: 56,
          color: complete
              ? AppColors.sage
              : partial
              ? AppColors.amber
              : AppColors.errorRed,
        ),
        const SizedBox(height: 16),
        Text(
          complete
              ? 'Import abgeschlossen'
              : partial
              ? 'Import teilweise abgeschlossen'
              : 'Import nicht vollständig',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 12),
        Text(
          complete
              ? '$processed Einträge verarbeitet'
              : '$successful von $processed Einträgen erfolgreich',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        if ((report?.importedMovies ?? 0) > 0) ...[
          const SizedBox(height: 12),
          Text(
            '${report!.importedMovies} Filme hinzugefügt',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.neutralGray),
          ),
        ],
        if ((report?.importedSeasons ?? 0) > 0) ...[
          const SizedBox(height: 8),
          Text(
            '${report!.importedSeasons} Staffeln hinzugefügt',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.neutralGray),
          ),
        ],
        if ((report?.alreadyExisted ?? 0) > 0) ...[
          const SizedBox(height: 8),
          Text(
            '${report!.alreadyExisted} bereits vorhanden',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.neutralGray),
          ),
        ],
        if ((report?.updated ?? 0) > 0) ...[
          const SizedBox(height: 8),
          Text(
            '${report!.updated} aktualisiert',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.neutralGray),
          ),
        ],
        if ((report?.skipped ?? 0) > 0) ...[
          const SizedBox(height: 8),
          Text(
            '${report!.skipped} übersprungen',
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.neutralGray),
          ),
        ],
        if (complete) ...[
          const SizedBox(height: 16),
          const Text(
            '✓ Alles gespeichert',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.sage,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
        if (failed > 0) ...[
          const SizedBox(height: 24),
          Text(
            '$failed Einträge konnten nicht gespeichert werden',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: AppColors.errorRed,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          for (final entry in grouped.entries)
            Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(
                '${entry.value.first.failure?.categoryLabel ?? 'Fehler'} · ${entry.value.length}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: AppColors.errorRed),
              ),
            ),
          const SizedBox(height: 20),
          Text(
            'Betroffene Titel',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          for (final outcome in failedOutcomes)
            _FailedEntryTile(outcome: outcome),
        ],
        const SizedBox(height: 24),
        if (failed > 0)
          FilledButton.icon(
            onPressed: () =>
                ref.read(importControllerProvider.notifier).retryFailed(),
            icon: const Icon(Icons.refresh),
            label: const Text('Fehlgeschlagene erneut versuchen'),
          ),
        if (failed > 0) const SizedBox(height: 8),
        FilledButton(
          onPressed: () => context.go('/collection'),
          child: const Text('Zur Sammlung'),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: () => ref.read(importControllerProvider.notifier).reset(),
          child: const Text('Weitere Einträge importieren'),
        ),
      ],
    );
  }
}

class _FailedEntryTile extends StatelessWidget {
  const _FailedEntryTile({required this.outcome});

  final ImportRowOutcome outcome;

  @override
  Widget build(BuildContext context) {
    final failure = outcome.failure;
    return Card(
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 12),
        childrenPadding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
        title: Text(outcome.sourceText),
        subtitle: Text(
          failure?.categoryLabel ?? 'Konnte nicht gespeichert werden.',
          style: const TextStyle(color: AppColors.errorRed, fontSize: 13),
        ),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              failure?.detailMessage ??
                  'Der Eintrag konnte nicht gespeichert werden.',
              style: const TextStyle(color: AppColors.neutralGray),
            ),
          ),
        ],
      ),
    );
  }
}

class _ErrorView extends ConsumerWidget {
  const _ErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 48,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: 16),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(
              onPressed: () =>
                  ref.read(importControllerProvider.notifier).reset(),
              child: const Text('Erneut versuchen'),
            ),
          ],
        ),
      ),
    );
  }
}
