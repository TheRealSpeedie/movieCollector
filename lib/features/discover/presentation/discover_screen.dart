import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/health/service_health.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/media_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shelf_row.dart';
import '../../../shared/widgets/status_view.dart';
import '../../collection/application/collection_filter_controller.dart';
import '../../collections/application/collections_providers.dart';
import '../../collections/application/franchise_gaps.dart';
import '../../movies/application/movie_providers.dart';
import '../../server/application/server_providers.dart';
import '../../watch/application/watch_providers.dart';
import '../application/gap_providers.dart';
import '../domain/watch_suggestions.dart';

/// Entdecken, by intention: what to watch, what is on the server or in the
/// subscriptions, what is wished for, and what is missing. Every section
/// says why it is empty instead of pretending all is complete.
class DiscoverScreen extends ConsumerWidget {
  const DiscoverScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final candidates =
        ref.watch(watchCandidatesProvider).valueOrNull ??
        const <WatchCandidate>[];
    final subscribed = ref.watch(subscribedIdsProvider);
    final connected = ref.watch(serverClientProvider) != null;
    final wishlist = [
      for (final m in ref.watch(allMoviesProvider).valueOrNull ?? const [])
        if (m.status == CollectionStatus.wishlist) m,
    ];

    final onServer = [
      for (final c in candidates)
        if (c.onServer && !c.watched) c,
    ];
    final inSubscriptions = [
      for (final c in candidates)
        if (!c.watched &&
            c.ownedFormats.isEmpty &&
            c.offers.any((o) => subscribed.contains(o.providerId)))
          c,
    ];
    const gap = SizedBox(height: AppSpacing.xl);

    void open(WatchCandidate c) {
      if (c.movieId != null) {
        context.push('/movie/${c.movieId}');
      } else if (c.serverTitleId != null) {
        context.push('/server/title/${c.serverTitleId}');
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Entdecken')),
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          const _WishField(),
          gap,
          if (connected && onServer.isNotEmpty) ...[
            ShelfRow(
              title: 'Auf deinem Server, noch nicht gesehen',
              onAction: () => context.push(
                '/discover/watch?sources=${SuggestionSource.server.name}',
              ),
              itemCount: onServer.length,
              itemBuilder: (context, i) => MediaCard(
                title: onServer[i].title,
                posterPath: onServer[i].posterPath,
                subtitle: onServer[i].year?.toString(),
                badge: const MediaBadge.playable(),
                onTap: () => open(onServer[i]),
              ),
            ),
            gap,
          ],
          if (inSubscriptions.isNotEmpty) ...[
            ShelfRow(
              title: 'Bei deinen Streamingdiensten',
              onAction: () => context.push(
                '/discover/watch?sources=${SuggestionSource.subscription.name}',
              ),
              itemCount: inSubscriptions.length,
              itemBuilder: (context, i) {
                final c = inSubscriptions[i];
                final offer = c.offers.firstWhere(
                  (o) => subscribed.contains(o.providerId),
                );
                return MediaCard(
                  title: c.title,
                  posterPath: c.posterPath,
                  subtitle: offer.providerName,
                  status: c.onWishlist ? CollectionStatus.wishlist : null,
                  onTap: () => open(c),
                );
              },
            ),
            gap,
          ] else if (subscribed.isEmpty) ...[
            StatusView.compact(
              kind: StatusKind.empty,
              icon: Icons.live_tv_outlined,
              title: 'Deine Streamingdienste',
              message:
                  'Gib an, welche Abos du hast, dann zeigt Speednema, was '
                  'du dort schauen kannst.',
              primary: StatusAction(
                'Abos auswählen',
                () => context.push('/settings/streaming'),
              ),
            ),
            gap,
          ],
          if (wishlist.isNotEmpty) ...[
            ShelfRow(
              title: 'Deine Wunschliste',
              onAction: () {
                ref
                    .read(collectionFilterControllerProvider.notifier)
                    .setStatusFilter(CollectionStatus.wishlist);
                context.go('/collection');
              },
              itemCount: wishlist.length,
              itemBuilder: (context, i) => MediaCard(
                title: wishlist[i].title,
                posterPath: wishlist[i].posterPath,
                subtitle: wishlist[i].releaseYear?.toString(),
                status: CollectionStatus.wishlist,
                onTap: () => context.push('/movie/${wishlist[i].id}'),
              ),
            ),
            gap,
          ],
          const _SeriesToComplete(),
          gap,
          const _MissingSeasons(),
        ],
      ),
    );
  }
}

/// The entry to "Was soll ich schauen?": looks like a field, opens the
/// suggestions with their filters and reasons.
class _WishField extends StatelessWidget {
  const _WishField();

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    // A field, not a banner: it keeps a field's width on wide screens.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.l,
            AppSpacing.s,
            AppSpacing.l,
            0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                header: true,
                child: Text('Was soll ich schauen?', style: text.titleLarge),
              ),
              const SizedBox(height: AppSpacing.s),
              Semantics(
                button: true,
                label: 'Vorschläge öffnen: Worauf hast du Lust?',
                excludeSemantics: true,
                child: Material(
                  color: colors.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadii.control),
                    side: BorderSide(color: colors.outline),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(AppRadii.control),
                    onTap: () => context.push('/discover/watch'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.l,
                        vertical: AppSpacing.m + 2,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.auto_awesome_outlined,
                            color: colors.attention,
                          ),
                          const SizedBox(width: AppSpacing.m),
                          Expanded(
                            child: Text(
                              'Worauf hast du Lust?',
                              style: text.bodyLarge?.copyWith(
                                color: colors.textSecondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'Vorschläge aus Regal, Server und deinen Abos, mit Begründung.',
                style: text.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Missing parts of film series, or why there are none to show.
class _SeriesToComplete extends ConsumerWidget {
  const _SeriesToComplete();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(franchiseGapsProvider);
    final groups = ref.watch(missingMoviesProvider).valueOrNull ?? const [];
    final missing = [
      for (final g in groups)
        for (final e in g.missingEntries) (group: g, entry: e),
    ];

    if (state is FranchiseGapsMissing && missing.isNotEmpty) {
      return ShelfRow(
        title: 'Reihen vervollständigen',
        actionLabel: 'Alle',
        onAction: () => context.push('/missing'),
        itemCount: missing.length,
        itemBuilder: (context, i) {
          final m = missing[i];
          return MediaCard(
            title: m.entry.title,
            posterPath: m.entry.posterPath,
            subtitle: m.group.collection.name,
            onTap: () => context.push('/collections/${m.group.collection.id}'),
          );
        },
      );
    }

    final header = SectionHeader(
      title: 'Reihen vervollständigen',
      actionLabel: state is FranchiseGapsComplete ? 'Alle Reihen' : null,
      onAction: () => context.push('/collections'),
    );
    final status = switch (state) {
      FranchiseGapsLoading() => null,
      FranchiseGapsFailed(:final error) => ErrorView.compact(
        error: error,
        onRetry: () => ref.invalidate(allCollectionsProvider),
      ),
      FranchiseGapsNotConfigured() => const ErrorView.compact(
        error: ServiceNotConfiguredException(ExternalService.tmdb),
      ),
      FranchiseGapsComplete() => StatusView.compact(
        kind: StatusKind.empty,
        icon: Icons.check_circle_outline,
        title: franchiseGapsSummary(state),
      ),
      FranchiseGapsNoMovies() ||
      FranchiseGapsNoSeries() ||
      FranchiseGapsMissing() => StatusView.compact(
        kind: StatusKind.empty,
        icon: Icons.collections_bookmark_outlined,
        title: franchiseGapsSummary(state),
        message:
            'Sobald ein Film zu einer Reihe gehört, siehst du hier, '
            'welche Teile dir fehlen.',
      ),
    };
    if (status == null) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [header, status],
    );
  }
}

class _MissingSeasons extends ConsumerWidget {
  const _MissingSeasons();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gaps = ref.watch(seasonGapsProvider).valueOrNull ?? const [];
    if (gaps.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'Fehlende Staffeln'),
        for (final gap in gaps)
          MediaRow(
            title: gap.entry.series.name,
            posterPath: gap.entry.series.posterPath,
            subtitle: gap.message,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/series/${gap.entry.series.id}'),
          ),
      ],
    );
  }
}
