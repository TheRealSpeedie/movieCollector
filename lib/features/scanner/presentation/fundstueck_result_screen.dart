import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'scan_insights_card.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/matching/media_title_parser.dart';
import '../../../core/network/tmdb/tmdb_models.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../core/utils/season_format.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/match_candidate.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/models/physical_edition.dart';
import '../../../shared/models/physical_edition_kind.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../../shared/widgets/status_chip.dart';
import '../../collections/application/collections_providers.dart';
import '../../collections/presentation/franchise_section.dart';
import '../../movies/application/movie_providers.dart';
import '../application/fundstueck_controller.dart';
import '../domain/barcode_lookup_result.dart';
import '../domain/barcode_search_context.dart';

class FundstueckResultScreen extends ConsumerStatefulWidget {
  const FundstueckResultScreen({super.key});

  @override
  ConsumerState<FundstueckResultScreen> createState() =>
      _FundstueckResultScreenState();
}

class _FundstueckResultScreenState
    extends ConsumerState<FundstueckResultScreen> {
  int _selectedIndex = 0;
  bool _showAlternatives = false;

  @override
  Widget build(BuildContext context) {
    final resultAsync = ref.watch(fundstueckControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Fundstück-Check')),
      body: SafeArea(
        child: resultAsync.when(
          loading: () => LoadingView(message: ref.watch(lookupStatusProvider)),
          error: (error, stack) =>
              ErrorView(error: error, onRetry: () => context.pop()),
          data: (result) {
            if (result == null) {
              return const Center(child: Text('Kein Ergebnis vorhanden.'));
            }
            return switch (result) {
              BarcodeKnownMovie() => KnownMovieView(movie: result.movie),
              BarcodeKnownEdition() => KnownEditionView(
                edition: result.edition,
              ),
              BarcodeNeedsConfirmation() => _buildNeedsConfirmation(result),
              BarcodeNeedsTvConfirmation() => TvConfirmationView(
                result: result,
              ),
              BarcodeNeedsMovieBundleConfirmation() =>
                MovieBundleConfirmationView(result: result),
              BarcodeNoMatch() => NoMatchView(
                productTitle: result.productTitle,
                searchQuery: result.productTitle,
              ),
              BarcodeUnresolvedOffline() => OfflineView(
                barcode: result.barcode,
              ),
              BarcodeNotAProductCode() => const NotAProductCodeView(),
              BarcodeProductUnknown() => ProductUnknownView(
                barcode: result.barcode,
              ),
              BarcodeLookupFailed() => LookupFailedView(
                message: result.message,
              ),
              BarcodeWeakMatch() => WeakMatchView(result: result),
            };
          },
        ),
      ),
    );
  }

  Widget _buildNeedsConfirmation(BarcodeNeedsConfirmation result) {
    if (result.candidates.isEmpty) {
      return NoMatchView(productTitle: result.productTitle);
    }
    final index = _selectedIndex < result.candidates.length
        ? _selectedIndex
        : 0;
    final selected = result.candidates[index];

    return Consumer(
      builder: (context, ref, _) {
        final existingAsync = ref.watch(
          movieByTmdbIdProvider(selected.result.id),
        );
        return existingAsync.when(
          loading: () => const LoadingView(),
          error: (error, stack) => ErrorView(error: error),
          data: (existing) {
            if (existing != null) {
              return KnownMovieView(
                movie: existing,
                barcodeToSave: result.barcode,
                productTitle: result.productTitle,
              );
            }
            return MissingMovieView(
              barcode: result.barcode,
              productTitle: result.productTitle,
              candidates: result.candidates,
              physicalFormat: result.physicalFormat,
              imdbId: result.imdbId,
              edition: result.edition,
              source: result.source,
              searchTitle: result.searchTitle,
              barcodeType: result.barcodeType,
              selected: selected,
              showAlternatives: _showAlternatives,
              onToggleAlternatives: () =>
                  setState(() => _showAlternatives = !_showAlternatives),
              onSelect: (i) => setState(() {
                _selectedIndex = i;
                _showAlternatives = false;
              }),
            );
          },
        );
      },
    );
  }
}

class KnownMovieView extends ConsumerWidget {
  const KnownMovieView({
    super.key,
    required this.movie,
    this.barcodeToSave,
    this.productTitle,
  });

  final Movie movie;
  final String? barcodeToSave;
  final String? productTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final banner = switch (movie.status) {
      CollectionStatus.owned => (
        '✓ Bereits in deiner Sammlung',
        AppColors.sage,
      ),
      CollectionStatus.wishlist => (
        '♡ Auf deiner Wunschliste',
        AppColors.dustyRose,
      ),
      CollectionStatus.open => ('Als offen gespeichert', AppColors.amber),
    };

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (movie.tmdbId != null)
          ScanInsightsCard(
            request: (
              editionId: null,
              tmdbId: movie.tmdbId,
              tmdbCollectionId: movie.tmdbCollectionId,
              format: null,
              // A barcode that is already mapped identifies the release.
              exact: barcodeToSave == null,
            ),
          ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: banner.$2.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: Text(
            banner.$1,
            style: TextStyle(
              color: banner.$2,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: PosterImage(posterPath: movie.posterPath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (movie.releaseYear != null)
                    Text(
                      '${movie.releaseYear}',
                      style: const TextStyle(color: AppColors.neutralGray),
                    ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 6,
                    runSpacing: 4,
                    children: [
                      if (movie.runtime != null)
                        Chip(label: Text('${movie.runtime} Min.')),
                      if (movie.certification != null)
                        Chip(label: Text('FSK ${movie.certification}')),
                    ],
                  ),
                  const SizedBox(height: 8),
                  StatusChip(status: movie.status),
                ],
              ),
            ),
          ],
        ),
        if (movie.genres.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(
            movie.genres.join(', '),
            style: const TextStyle(color: AppColors.neutralGray),
          ),
        ],
        if (movie.overview != null && movie.overview!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(movie.overview!),
        ],
        if (barcodeToSave != null && barcodeToSave!.isNotEmpty) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () async {
              await ref
                  .read(fundstueckControllerProvider.notifier)
                  .confirmAndSave(
                    candidate: TmdbSearchResult(
                      id: movie.tmdbId ?? 0,
                      title: movie.title,
                    ),
                    status: movie.status,
                    barcode: barcodeToSave,
                  );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Barcode gespeichert.')),
                );
              }
            },
            icon: const Icon(Icons.qr_code),
            label: const Text('Diesen Barcode merken'),
          ),
        ],
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => context.push('/movie/${movie.id}'),
                child: const Text('Details öffnen'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Weiter scannen'),
              ),
            ),
          ],
        ),
        if (movie.tmdbId != null) ...[
          const SizedBox(height: 20),
          FranchiseSection(tmdbMovieId: movie.tmdbId!),
        ],
      ],
    );
  }
}

class MissingMovieView extends ConsumerWidget {
  const MissingMovieView({
    super.key,
    required this.barcode,
    required this.productTitle,
    required this.candidates,
    required this.selected,
    required this.showAlternatives,
    required this.onToggleAlternatives,
    required this.onSelect,
    this.physicalFormat,
    this.imdbId,
    this.edition,
    this.source,
    this.searchTitle,
    this.barcodeType = 'EAN',
  });

  final String barcode;
  final String productTitle;
  final List<MatchCandidate> candidates;
  final String? physicalFormat;
  final String? imdbId;
  final String? edition;
  final String? source;
  final String? searchTitle;
  final String barcodeType;
  final MatchCandidate selected;
  final bool showAlternatives;
  final VoidCallback onToggleAlternatives;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movie = selected.result;
    final isConfident = selected.confidence >= 0.82;
    final franchise = ref.watch(franchiseProvider(movie.id));
    final franchiseInfo = franchise.asData?.value;
    final hasFranchise =
        franchiseInfo != null && franchiseInfo.parts.isNotEmpty;
    final showSingleStatus =
        franchise.hasError || (franchise.hasValue && !hasFranchise);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ScanInsightsCard(
          request: (
            editionId: null,
            tmdbId: movie.id,
            tmdbCollectionId: null,
            format: physicalFormat,
            exact: false,
          ),
        ),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.neutralGray.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(14),
          ),
          alignment: Alignment.center,
          child: const Text(
            'Diese Veröffentlichung wurde gefunden.',
            style: TextStyle(
              color: AppColors.charcoal,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Erkannt von: „$productTitle“',
          style: const TextStyle(color: AppColors.neutralGray, fontSize: 12),
        ),
        if (physicalFormat != null)
          Text(
            _formatLabel(physicalFormat!),
            style: const TextStyle(color: AppColors.neutralGray, fontSize: 12),
          ),
        if (kDebugMode && source != null)
          Text(
            'Quelle: $source',
            style: const TextStyle(color: AppColors.neutralGray, fontSize: 12),
          ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 120,
              child: PosterImage(posterPath: movie.posterPath),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  if (movie.releaseYear != null)
                    Text(
                      '${movie.releaseYear}',
                      style: const TextStyle(color: AppColors.neutralGray),
                    ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: (isConfident ? AppColors.sage : AppColors.amber)
                          .withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      isConfident ? 'Hohe Übereinstimmung' : 'Bitte bestätigen',
                      style: TextStyle(
                        color: isConfident ? AppColors.sage : AppColors.amber,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (movie.overview != null && movie.overview!.isNotEmpty) ...[
          const SizedBox(height: 12),
          Text(movie.overview!, maxLines: 4, overflow: TextOverflow.ellipsis),
        ],
        if (candidates.length > 1) ...[
          const SizedBox(height: 12),
          TextButton(
            onPressed: onToggleAlternatives,
            child: Text(
              showAlternatives
                  ? 'Alternativen ausblenden'
                  : 'Anderen Film wählen',
            ),
          ),
          if (showAlternatives)
            for (var i = 0; i < candidates.length; i++)
              if (candidates[i].result.id != movie.id)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: SizedBox(
                    width: 40,
                    child: PosterImage(
                      posterPath: candidates[i].result.posterPath,
                      borderRadius: 6,
                    ),
                  ),
                  title: Text(candidates[i].result.title),
                  subtitle: candidates[i].result.releaseYear != null
                      ? Text('${candidates[i].result.releaseYear}')
                      : null,
                  onTap: () => onSelect(i),
                ),
        ],
        const SizedBox(height: 20),
        FranchiseSection(
          tmdbMovieId: movie.id,
          pendingConfirmation: true,
          onCommitScanned: (status) => _confirm(ref, status),
        ),
        if (hasFranchise)
          Align(
            alignment: Alignment.centerLeft,
            child: TextButton(
              onPressed: () => _openManualSearch(context),
              child: const Text('Falscher Film? Manuell suchen'),
            ),
          )
        else if (showSingleStatus) ...[
          const SizedBox(height: 20),
          Text(
            'Wie möchtest du diesen Film speichern?',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          ActionButton(
            label: 'Als gekauft speichern',
            icon: Icons.check_circle_outline,
            color: AppColors.sage,
            onTap: () => _save(context, ref, CollectionStatus.owned),
          ),
          const SizedBox(height: 8),
          ActionButton(
            label: 'Zur Wunschliste',
            icon: Icons.favorite_border,
            color: AppColors.dustyRose,
            onTap: () => _save(context, ref, CollectionStatus.wishlist),
          ),
          const SizedBox(height: 8),
          ActionButton(
            label: 'Als offen speichern',
            icon: Icons.hourglass_bottom,
            color: AppColors.amber,
            onTap: () => _save(context, ref, CollectionStatus.open),
          ),
          const SizedBox(height: 8),
          OutlinedButton.icon(
            onPressed: () => _openManualSearch(context),
            icon: const Icon(Icons.search),
            label: const Text('Manuell suchen'),
          ),
        ],
      ],
    );
  }

  void _openManualSearch(BuildContext context) {
    context.push(
      BarcodeSearchContext(
        query: searchTitle ?? productTitle,
        barcode: barcode,
        barcodeType: barcodeType,
        productTitle: productTitle,
        physicalFormat: physicalFormat,
        imdbId: imdbId,
        edition: edition,
      ).location(),
    );
  }

  Future<void> _save(
    BuildContext context,
    WidgetRef ref,
    CollectionStatus status,
  ) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      await _confirm(ref, status);
    } catch (error) {
      messenger.showSnackBar(SnackBar(content: Text(describeError(error))));
    }
  }

  Future<void> _confirm(WidgetRef ref, CollectionStatus status) {
    return ref
        .read(fundstueckControllerProvider.notifier)
        .confirmAndSave(
          candidate: selected.result,
          status: status,
          barcode: barcode.isEmpty ? null : barcode,
          barcodeType: barcodeType,
          physicalFormat: physicalFormat,
          imdbId: imdbId,
          edition: edition,
        );
  }
}

String _formatLabel(String raw) {
  return switch (raw) {
    'uhd_4k' => '4K UHD',
    'blu_ray' => 'Blu-ray',
    'dvd' => 'DVD',
    _ => raw,
  };
}

class NoMatchView extends StatelessWidget {
  const NoMatchView({super.key, this.productTitle, this.searchQuery});

  final String? productTitle;
  final String? searchQuery;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.help_outline,
              size: 48,
              color: AppColors.neutralGray,
            ),
            const SizedBox(height: 16),
            const Text(
              'Es wurde kein passender Film gefunden.',
              textAlign: TextAlign.center,
            ),
            if (productTitle != null) ...[
              const SizedBox(height: 8),
              Text(
                'Erkanntes Produkt: „$productTitle“',
                style: const TextStyle(color: AppColors.neutralGray),
              ),
            ],
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.push(
                BarcodeSearchContext(
                  query: searchQuery ?? productTitle,
                ).location(),
              ),
              icon: const Icon(Icons.search),
              label: const Text('Manuell suchen'),
            ),
          ],
        ),
      ),
    );
  }
}

class OfflineView extends ConsumerWidget {
  const OfflineView({super.key, required this.barcode});

  final String barcode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.wifi_off, size: 48, color: AppColors.neutralGray),
            const SizedBox(height: 16),
            const Text(
              'Dieser Barcode ist auf diesem Gerät noch nicht bekannt. '
              'Er ist gespeichert und wird erkannt, sobald du wieder online bist. '
              'Du kannst den Film auch gleich von Hand hinzufügen.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => ref
                  .read(fundstueckControllerProvider.notifier)
                  .scanBarcode(barcode),
              icon: const Icon(Icons.refresh),
              label: const Text('Erneut versuchen'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () => context.push('/search'),
              icon: const Icon(Icons.search),
              label: const Text('Manuell suchen'),
            ),
          ],
        ),
      ),
    );
  }
}

class KnownEditionView extends StatelessWidget {
  const KnownEditionView({super.key, required this.edition});

  final PhysicalEditionContents edition;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (edition.id != 0)
          ScanInsightsCard(
            request: (
              editionId: edition.id,
              tmdbId: null,
              tmdbCollectionId: null,
              format: null,
              exact: true,
            ),
          )
        else if (edition.movies.firstOrNull?.tmdbId != null)
          ScanInsightsCard(
            request: (
              editionId: null,
              tmdbId: edition.movies.first.tmdbId,
              tmdbCollectionId: edition.movies.first.tmdbCollectionId,
              format: null,
              exact: true,
            ),
          ),
        Text(
          edition.productTitle ?? edition.series?.name ?? 'Box Set',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (edition.movies.isNotEmpty)
          Text('${edition.movies.length} Filme enthalten'),
        if (edition.seasons.isNotEmpty)
          Text('${edition.seasons.length} Staffeln enthalten'),
        const SizedBox(height: 12),
        for (final movie in edition.movies)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: SizedBox(
              width: 40,
              child: PosterImage(posterPath: movie.posterPath, borderRadius: 6),
            ),
            title: Text(movie.title),
            trailing: StatusChip(status: movie.status, compact: true),
          ),
        for (final season in edition.seasons)
          ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(seasonLabel(season.seasonNumber)),
            trailing: season.status == null
                ? const MissingChip()
                : StatusChip(status: season.status!, compact: true),
          ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: () => context.pop(),
          child: const Text('Weiter scannen'),
        ),
      ],
    );
  }
}

class MovieBundleConfirmationView extends ConsumerWidget {
  const MovieBundleConfirmationView({super.key, required this.result});

  final BarcodeNeedsMovieBundleConfirmation result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FutureBuilder(
      future: Future.wait(
        result.selectedTmdbIds.map(
          (id) => ref.read(movieRepositoryProvider).getMovieByTmdbId(id),
        ),
      ),
      builder: (context, snapshot) {
        final existing = snapshot.data ?? const <Movie?>[];
        final ownedCount = existing
            .where((m) => m?.status == CollectionStatus.owned)
            .length;
        final missing = result.collection.parts.length - ownedCount;
        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              result.productTitle.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text('${result.collection.parts.length} Filme enthalten'),
            Text(
              'Du besitzt bereits: $ownedCount / ${result.collection.parts.length}',
            ),
            Text('Neu für deine Sammlung: $missing Filme'),
            const SizedBox(height: 12),
            for (final part in result.collection.parts)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(
                  '${existing.where((m) => m?.tmdbId == part.id).firstOrNull?.status == CollectionStatus.owned ? '✓' : '+'} ${part.title}',
                ),
              ),
            const SizedBox(height: 16),
            ActionButton(
              label: 'Als gekauft speichern',
              icon: Icons.check_circle_outline,
              color: AppColors.sage,
              onTap: () => ref
                  .read(fundstueckControllerProvider.notifier)
                  .confirmMovieBundle(
                    collection: result.collection,
                    selectedTmdbIds: result.selectedTmdbIds,
                    status: CollectionStatus.owned,
                    productTitle: result.productTitle,
                    barcode: result.barcode.isEmpty ? null : result.barcode,
                  ),
            ),
          ],
        );
      },
    );
  }
}

class TvConfirmationView extends ConsumerWidget {
  const TvConfirmationView({super.key, required this.result});

  final BarcodeNeedsTvConfirmation result;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final details = result.details;
    final selected = result.selectedSeasonNumbers;
    final series = result.candidates.isEmpty
        ? null
        : result.candidates.first.result;

    return FutureBuilder(
      future: details == null
          ? Future<dynamic>.value(null)
          : ref
                .read(tvRepositoryProvider)
                .getSeriesWithSeasonsByTmdbId(details.id),
      builder: (context, snapshot) {
        final local = snapshot.data;
        final owned = <int>{};
        if (local != null) {
          for (final season in local.seasons) {
            if (season.status == CollectionStatus.owned) {
              owned.add(season.seasonNumber);
            }
          }
        }
        final already = selected.where(owned.contains).length;
        final missing = selected.length - already;
        final totalRegular = details?.regularSeasons.length ?? selected.length;
        final ownedRegular = local?.ownedRegularCount ?? already;
        final highlighted = selected.length == 1 ? selected.first : null;

        return ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              result.productTitle.toUpperCase(),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (result.kindHint == MediaKindHint.completeTvSeries) ...[
              Text('${selected.where((n) => n > 0).length} Staffeln enthalten'),
              Text('Du besitzt bereits: $ownedRegular / $totalRegular'),
              Text('Diese Box würde $missing fehlende Staffeln ergänzen.'),
            ] else if (highlighted != null) ...[
              Text(
                missing > 0
                    ? 'Diese Staffel fehlt dir.'
                    : 'Diese Staffel ist bereits gespeichert.',
              ),
              if (series != null) Text(series.name),
              Text('$ownedRegular / $totalRegular Staffeln gekauft'),
            ] else ...[
              Text('${selected.length} Staffeln enthalten'),
              Text('Du besitzt bereits: $already / ${selected.length}'),
            ],
            const SizedBox(height: 12),
            if (details != null)
              for (final season in details.seasons)
                if (season.seasonNumber > 0)
                  Text(
                    '${owned.contains(season.seasonNumber)
                        ? '✓'
                        : selected.contains(season.seasonNumber)
                        ? '→'
                        : '○'} ${seasonLabel(season.seasonNumber)}'
                    '${selected.contains(season.seasonNumber) && highlighted == season.seasonNumber ? ' – dieser Scan' : ''}',
                  ),
            const SizedBox(height: 16),
            if (details != null)
              ActionButton(
                label: 'Als gekauft speichern',
                icon: Icons.check_circle_outline,
                color: AppColors.sage,
                onTap: () => ref
                    .read(fundstueckControllerProvider.notifier)
                    .confirmTvSeasons(
                      details: details,
                      selectedSeasonNumbers: selected,
                      status: CollectionStatus.owned,
                      productTitle: result.productTitle,
                      kind: result.kindHint == MediaKindHint.completeTvSeries
                          ? PhysicalEditionKind.completeTvSeries
                          : selected.length == 1
                          ? PhysicalEditionKind.singleTvSeason
                          : PhysicalEditionKind.tvSeasonBundle,
                      barcode: result.barcode.isEmpty ? null : result.barcode,
                    ),
              ),
          ],
        );
      },
    );
  }
}

class NotAProductCodeView extends StatelessWidget {
  const NotAProductCodeView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Text(
          'Dieser QR-Code enthält keinen Produktbarcode. Scanne den gestreiften EAN/UPC-Barcode auf der Rückseite der Hülle.',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class ProductUnknownView extends StatelessWidget {
  const ProductUnknownView({super.key, required this.barcode});

  final String barcode;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Keine Produktdatenbank kennt diesen Barcode derzeit.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text('EAN: $barcode'),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.push(
                BarcodeSearchContext(barcode: barcode).location(),
              ),
              icon: const Icon(Icons.search),
              label: const Text('Titel manuell suchen'),
            ),
          ],
        ),
      ),
    );
  }
}

class LookupFailedView extends StatelessWidget {
  const LookupFailedView({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Text(message, textAlign: TextAlign.center),
      ),
    );
  }
}

class WeakMatchView extends StatelessWidget {
  const WeakMatchView({super.key, required this.result});

  final BarcodeWeakMatch result;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Wir haben diese Veröffentlichung gefunden:\n\n${result.productTitle}\n\nkonnten sie aber keinem Film oder keiner Serie sicher zuordnen.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: () => context.push(
                BarcodeSearchContext(
                  query: result.searchTitle,
                  barcode: result.barcode,
                  barcodeType: result.barcodeType,
                  productTitle: result.productTitle,
                  physicalFormat: result.physicalFormat,
                  imdbId: result.imdbId,
                  edition: result.edition,
                ).location(),
              ),
              icon: const Icon(Icons.search),
              label: const Text('Bei TMDB suchen'),
            ),
          ],
        ),
      ),
    );
  }
}
