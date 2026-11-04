import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/movie.dart';
import '../../../shared/widgets/confirm_dialog.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../../shared/widgets/status_view.dart';
import '../../collections/presentation/franchise_section.dart';
import '../../editions/presentation/copies_section.dart';
import '../../editions/presentation/known_editions_section.dart';
import '../../movies/application/movie_providers.dart';
import '../../personal/data/personal_state_repository.dart';
import '../../personal/presentation/personal_section.dart';
import '../../scanner/application/barcode_providers.dart';
import '../../sync/application/sync_providers.dart';
import '../../sync/presentation/digital_section.dart';
import '../../watch/application/watch_providers.dart';
import '../../watch/presentation/where_to_watch_section.dart';

/// A film: a hero with its artwork and facts, the actions people come for
/// (play, status), then everything about it in order of how often it
/// matters. Technical details sit behind a disclosure.
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
    return movieAsync.when(
      loading: () =>
          Scaffold(appBar: AppBar(), body: const SkeletonList(rows: 4)),
      error: (error, stack) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(
          error: error,
          onRetry: () => ref.invalidate(movieByIdProvider(widget.movieId)),
        ),
      ),
      data: (movie) => movie == null
          ? Scaffold(
              appBar: AppBar(),
              body: const StatusView(
                kind: StatusKind.empty,
                icon: Icons.movie_filter_outlined,
                title: 'Diesen Film gibt es nicht mehr',
                message:
                    'Er wurde entfernt, vielleicht auf einem anderen Gerät.',
              ),
            )
          : _buildContent(context, movie),
    );
  }

  Widget _buildContent(BuildContext context, Movie movie) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final serverTitle = movie.tmdbId == null
        ? null
        : (ref.watch(serverMoviesProvider).valueOrNull ?? const [])
              .where((t) => t.tmdbId == movie.tmdbId && !t.isSeries)
              .firstOrNull;
    final facts = [
      if (movie.releaseYear != null) '${movie.releaseYear}',
      if (movie.runtime != null) '${movie.runtime} Min.',
      if (movie.certification != null) 'FSK ${movie.certification}',
    ].join(' · ');
    final backdrop = ApiConstants.backdropUrl(movie.backdropPath);
    final heroHeight = (MediaQuery.sizeOf(context).width * 9 / 16).clamp(
      200.0,
      360.0,
    );
    const section = SizedBox(height: AppSpacing.xl);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Artwork earns a hero; without it the page starts plainly with
          // poster and title instead of an empty band.
          if (backdrop.isEmpty)
            SliverAppBar(
              pinned: true,
              backgroundColor: colors.background,
              surfaceTintColor: Colors.transparent,
              actions: [_menu(context, movie)],
            )
          else
            SliverAppBar(
              pinned: true,
              expandedHeight: heroHeight,
              foregroundColor: colors.onMedia,
              backgroundColor: colors.background,
              surfaceTintColor: Colors.transparent,
              actions: [_menu(context, movie)],
              flexibleSpace: FlexibleSpaceBar(
                collapseMode: CollapseMode.parallax,
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    CachedNetworkImage(
                      imageUrl: backdrop,
                      fit: BoxFit.cover,
                      placeholder: (_, _) => ColoredBox(color: colors.surface),
                      errorWidget: (_, _, _) =>
                          ColoredBox(color: colors.surface),
                    ),
                    // The one gradient: legibility for the bar over artwork,
                    // and a soft edge into the page.
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colors.scrim,
                            Colors.transparent,
                            colors.background,
                          ],
                          stops: const [0, 0.45, 1],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.l,
                backdrop.isEmpty ? AppSpacing.s : 0,
                AppSpacing.l,
                AppSpacing.xxl,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(
                        width: 104,
                        child: PosterImage(
                          posterPath: movie.posterPath,
                          borderRadius: AppRadii.poster,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.l),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Semantics(
                              header: true,
                              child: Text(
                                movie.title,
                                style: text.headlineSmall,
                              ),
                            ),
                            if (movie.originalTitle != null &&
                                movie.originalTitle != movie.title)
                              Text(
                                movie.originalTitle!,
                                style: text.bodyMedium?.copyWith(
                                  color: colors.textSecondary,
                                ),
                              ),
                            if (facts.isNotEmpty) ...[
                              const SizedBox(height: AppSpacing.xs),
                              Text(facts, style: text.bodyMedium),
                            ],
                            if (movie.genres.isNotEmpty)
                              Text(
                                movie.genres.join(' · '),
                                style: text.bodySmall,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.l),
                  if (serverTitle != null) ...[
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: () =>
                            context.push('/server/title/${serverTitle.id}'),
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Abspielen'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.m),
                  ],
                  Text('In meiner Sammlung als', style: text.bodySmall),
                  const SizedBox(height: AppSpacing.xs),
                  SizedBox(
                    width: double.infinity,
                    child: SegmentedButton<CollectionStatus>(
                      showSelectedIcon: false,
                      segments: [
                        for (final s in CollectionStatus.values)
                          // Words only: three icons and labels do not fit a
                          // phone without breaking "Wunschliste".
                          ButtonSegment(value: s, label: Text(s.germanLabel)),
                      ],
                      selected: {movie.status},
                      onSelectionChanged: (selection) =>
                          _changeStatus(selection.first, movie),
                    ),
                  ),
                  if (movie.overview != null && movie.overview!.isNotEmpty) ...[
                    section,
                    const SectionHeader(
                      title: 'Handlung',
                      padding: EdgeInsets.zero,
                    ),
                    const SizedBox(height: AppSpacing.s),
                    _Overview(text: movie.overview!),
                  ],
                  section,
                  CopiesSection(movieId: movie.id),
                  if (movie.tmdbId != null) ...[
                    section,
                    WhereToWatchSection(
                      mediaType: 'movie',
                      tmdbId: movie.tmdbId!,
                      onServer: serverTitle != null,
                      ownedFormats:
                          ref
                              .watch(ownedFormatsProvider)
                              .valueOrNull?[movie.id] ??
                          const [],
                    ),
                    DigitalSection(tmdbId: movie.tmdbId!),
                  ],
                  section,
                  PersonalSection(
                    subject: movieSubject(movie.id),
                    onWishlist: movie.status == CollectionStatus.wishlist,
                    editions:
                        ref
                            .watch(movieEditionsProvider(movie.id))
                            .valueOrNull ??
                        const [],
                  ),
                  if (movie.tmdbId != null) ...[
                    section,
                    FranchiseSection(tmdbMovieId: movie.tmdbId!),
                    KnownEditionsSection(
                      movieId: movie.id,
                      tmdbId: movie.tmdbId!,
                    ),
                  ],
                  section,
                  _TechnicalDetails(
                    movie: movie,
                    onAddBarcode: () => _addBarcode(context, movie),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _menu(BuildContext context, Movie movie) => PopupMenuButton<String>(
    tooltip: 'Weitere Aktionen',
    onSelected: (value) {
      switch (value) {
        case 'refresh':
          _refresh(context);
        case 'barcode':
          _addBarcode(context, movie);
        case 'delete':
          _confirmDelete(context);
      }
    },
    itemBuilder: (context) => [
      PopupMenuItem(
        value: 'refresh',
        enabled: !_refreshing,
        child: const ListTile(
          leading: Icon(Icons.refresh),
          title: Text('Filminfos aktualisieren'),
        ),
      ),
      const PopupMenuItem(
        value: 'barcode',
        child: ListTile(
          leading: Icon(Icons.qr_code),
          title: Text('Barcode hinzufügen'),
        ),
      ),
      PopupMenuItem(
        value: 'delete',
        child: ListTile(
          leading: Icon(Icons.delete_outline, color: context.colors.error),
          title: Text(
            'Aus Sammlung entfernen',
            style: TextStyle(color: context.colors.error),
          ),
        ),
      ),
    ],
  );

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
          const SnackBar(content: Text('Filminfos aktualisiert.')),
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
    if (!confirmed || !context.mounted) return;
    final messenger = ScaffoldMessenger.of(context);
    final removed = await ref
        .read(movieRepositoryProvider)
        .deleteMovie(widget.movieId);
    if (!removed) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text(
            'Deine Exemplare sind entfernt. Der Film bleibt, weil andere im '
            'Haushalt ihn besitzen.',
          ),
        ),
      );
      return;
    }
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

/// The plot, folded to a few lines when long.
class _Overview extends StatefulWidget {
  const _Overview({required this.text});

  final String text;

  @override
  State<_Overview> createState() => _OverviewState();
}

class _OverviewState extends State<_Overview> {
  bool _open = false;

  @override
  Widget build(BuildContext context) {
    final long = widget.text.length > 280;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.text,
          maxLines: !long || _open ? null : 5,
          overflow: !long || _open ? null : TextOverflow.fade,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        if (long)
          TextButton(
            style: TextButton.styleFrom(padding: EdgeInsets.zero),
            onPressed: () => setState(() => _open = !_open),
            child: Text(_open ? 'Weniger' : 'Mehr lesen'),
          ),
      ],
    );
  }
}

/// Barcodes and how fresh the film information is: useful when something
/// is wrong, not every day.
class _TechnicalDetails extends ConsumerWidget {
  const _TechnicalDetails({required this.movie, required this.onAddBarcode});

  final Movie movie;
  final VoidCallback onAddBarcode;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final barcodes = ref.watch(barcodesForMovieProvider(movie.id));
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: EdgeInsets.zero,
        expandedCrossAxisAlignment: CrossAxisAlignment.start,
        title: Text(
          'Technische Details',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        children: [
          barcodes.when(
            loading: () => const SizedBox.shrink(),
            error: (error, _) => ErrorView.compact(
              error: error,
              onRetry: () => ref.invalidate(barcodesForMovieProvider(movie.id)),
            ),
            data: (list) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (list.isEmpty)
                  Text(
                    'Noch keine Barcodes hinterlegt.',
                    style: TextStyle(color: colors.textSecondary),
                  ),
                for (final b in list)
                  ListTile(
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
                TextButton.icon(
                  style: TextButton.styleFrom(padding: EdgeInsets.zero),
                  onPressed: onAddBarcode,
                  icon: const Icon(Icons.add),
                  label: const Text('Barcode hinzufügen'),
                ),
              ],
            ),
          ),
          if (movie.lastMetadataSyncAt != null)
            Padding(
              padding: const EdgeInsets.only(top: AppSpacing.s),
              child: Text(
                'Filminfos zuletzt aktualisiert: '
                '${DateFormat('dd.MM.yyyy, HH:mm').format(movie.lastMetadataSyncAt!)}',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
        ],
      ),
    );
  }
}
