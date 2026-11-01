import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_shell.dart';
import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';
import '../../../core/config/config_providers.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/dismissed_notices.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/inline_notice.dart';
import '../../../shared/widgets/media_card.dart';
import '../../../shared/widgets/section_header.dart';
import '../../../shared/widgets/shelf_row.dart';
import '../../../shared/widgets/skeleton.dart';
import '../../../shared/widgets/status_view.dart';
import '../../add/presentation/add_sheet.dart';
import '../../collections/application/collections_providers.dart';
import '../../discover/domain/watch_suggestions.dart';
import '../../movies/application/movie_providers.dart';
import '../../server/application/server_connection.dart';
import '../../server/application/server_providers.dart';
import '../../server/domain/server_models.dart';
import '../../server/presentation/server_screen.dart';
import '../../sync/application/sync_providers.dart';
import '../../watch/application/watch_providers.dart';
import 'empty_shelf.dart';

/// Home follows the person's actual state: a welcome while the shelf is
/// empty, otherwise what to watch next and what is new. Sections appear only
/// when they have something to show; problems are notes above the content,
/// never instead of it.
class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(allMoviesProvider);
    final narrow = MediaQuery.sizeOf(context).width < Breakpoints.medium;

    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConstants.appName),
        actions: [
          // On wider layouts the navigation rail carries "+".
          if (narrow) const AddButton(),
        ],
      ),
      body: movies.when(
        skipLoadingOnReload: true,
        loading: () => ListView(
          children: const [
            SizedBox(height: AppSpacing.l),
            SkeletonShelfRow(),
            SizedBox(height: AppSpacing.xl),
            SkeletonShelfRow(),
          ],
        ),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(allMoviesProvider),
        ),
        data: (list) =>
            list.isEmpty ? const _Welcome() : _Populated(total: list.length),
      ),
    );
  }
}

/// The first impression: what Speednema is for, and one way to start.
class _Welcome extends ConsumerWidget {
  const _Welcome();

  static const _tmdbNotice = 'tmdb:notConfigured';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final showTmdb =
        !ref.watch(tmdbConfiguredProvider) &&
        !ref.watch(dismissedNoticesProvider).contains(_tmdbNotice);

    Widget capability(IconData icon, String line) => Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.s),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colors.textSecondary),
          const SizedBox(width: AppSpacing.m),
          Expanded(child: Text(line, style: text.bodyLarge)),
        ],
      ),
    );

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 460),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showTmdb) ...[
                InlineNotice(
                  kind: StatusKind.notConfigured,
                  title: 'Filminfos sind noch nicht eingerichtet',
                  message:
                      'Ohne sie findet die Suche nur, was schon in deiner '
                      'Sammlung ist.',
                  action: StatusAction(
                    'Einrichten',
                    () => context.push('/settings/metadata'),
                  ),
                  onDismiss: () => ref
                      .read(dismissedNoticesProvider.notifier)
                      .dismiss(_tmdbNotice),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
              const Center(child: EmptyShelf()),
              const SizedBox(height: AppSpacing.xl),
              Semantics(
                header: true,
                child: Text(
                  'Dein Regal ist noch leer.',
                  style: text.displaySmall,
                ),
              ),
              const SizedBox(height: AppSpacing.s),
              Text(
                'Erfasse Filme und Serien, die du besitzt oder sehen '
                'möchtest – auf Disc oder digital.',
                style: text.bodyLarge?.copyWith(color: colors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.xl),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => showAddSheet(context),
                  icon: const Icon(Icons.add),
                  label: const Text('Ersten Film hinzufügen'),
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              capability(
                Icons.qr_code_scanner,
                'Barcode scannen und sofort wissen, ob du einen Film schon hast',
              ),
              capability(
                Icons.collections_bookmark_outlined,
                'Wunschliste und fehlende Teile deiner Reihen im Blick',
              ),
              capability(
                Icons.dns_outlined,
                'Mit eigenem Server Filme streamen und mit dem Haushalt teilen',
              ),
              const SizedBox(height: AppSpacing.m),
              TextButton(
                onPressed: () => context.push('/server/connect'),
                child: const Text('Eigenen Server verbinden (optional)'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Populated extends ConsumerWidget {
  const _Populated({required this.total});

  final int total;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final counts = ref.watch(collectionCountsProvider).valueOrNull ?? const {};
    final wishlist = counts[CollectionStatus.wishlist] ?? 0;
    final connection = ref.watch(serverConnectionProvider);
    final conflicts = ref.watch(syncConflictsProvider).valueOrNull?.length ?? 0;
    final resume = ref.watch(serverClientProvider) == null
        ? const <ResumeItem>[]
        : ref.watch(serverHomeProvider).valueOrNull?.resume ??
              const <ResumeItem>[];
    ref.watch(wishlistOfferWatcherProvider);
    final insights = ref.watch(collectionInsightsProvider).valueOrNull;
    final candidates =
        ref.watch(watchCandidatesProvider).valueOrNull ??
        const <WatchCandidate>[];
    // Unwatched titles you can actually watch tonight: on the shelf or on
    // the server.
    final tonight = [
      for (final c in candidates)
        if (!c.watched &&
            c.movieId != null &&
            (c.ownedFormats.isNotEmpty || c.onServer))
          c,
    ].take(12).toList();
    final inSubscription = insights?.wishlistInSubscription ?? const [];
    final recent =
        ref.watch(recentlyAddedMoviesProvider).valueOrNull ?? const [];
    final gaps = ref.watch(missingMoviesProvider).valueOrNull ?? const [];

    final films = total == 1 ? '1 Film' : '$total Filme';
    final summary = wishlist == 0
        ? films
        : '$films · $wishlist auf der Wunschliste';

    Widget notice(Widget child) => Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.l,
        0,
        AppSpacing.l,
        AppSpacing.m,
      ),
      child: child,
    );
    const gap = SizedBox(height: AppSpacing.xl);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(allMoviesProvider);
        ref.invalidate(allCollectionsProvider);
        ref.invalidate(serverHomeProvider);
      },
      child: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: [
          // Aligned with the section titles; the whole line is the target.
          InkWell(
            onTap: () => context.go('/collection'),
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        summary,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right,
                      size: 18,
                      color: colors.textSecondary,
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (connection is ServerAuthRequired)
            notice(
              InlineNotice(
                kind: StatusKind.authRequired,
                title: 'Dein Server kennt dieses Gerät nicht mehr',
                message:
                    'Deine Sammlung auf diesem Gerät ist weiter verfügbar.',
                action: StatusAction(
                  'Neu verbinden',
                  () => context.push('/server/connect'),
                ),
              ),
            )
          else if (connection is ServerOffline)
            notice(
              InlineNotice(
                kind: StatusKind.serviceUnavailable,
                title: 'Server nicht erreichbar',
                message:
                    'Deine Sammlung auf diesem Gerät ist weiter verfügbar.',
                action: StatusAction(
                  'Erneut versuchen',
                  () => ref.invalidate(serverHomeProvider),
                ),
              ),
            ),
          if (conflicts > 0)
            notice(
              InlineNotice(
                kind: StatusKind.partial,
                title: conflicts == 1
                    ? 'Eine Angabe wurde auf zwei Geräten verschieden geändert'
                    : '$conflicts Angaben wurden auf zwei Geräten verschieden '
                          'geändert',
                message: 'Nichts wird überschrieben, bis du wählst.',
                action: StatusAction('Ansehen', () => context.push('/sync')),
              ),
            ),
          if (resume.isNotEmpty) ...[
            SectionHeader(
              title: 'Weiterschauen',
              actionLabel: 'Alle',
              onAction: () => context.push('/server'),
            ),
            const SizedBox(height: AppSpacing.s),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              child: ResumeRow(items: resume),
            ),
            gap,
          ],
          if (tonight.isNotEmpty) ...[
            ShelfRow(
              title: 'Für heute Abend',
              onAction: () => context.push('/discover/watch'),
              itemCount: tonight.length,
              itemBuilder: (context, i) {
                final c = tonight[i];
                return MediaCard(
                  title: c.title,
                  posterPath: c.posterPath,
                  subtitle: c.year?.toString(),
                  badge: c.onServer ? const MediaBadge.playable() : null,
                  onTap: () => context.push('/movie/${c.movieId}'),
                );
              },
            ),
            gap,
          ],
          if (inSubscription.isNotEmpty) ...[
            ShelfRow(
              title: 'Jetzt in deinen Abos',
              itemCount: inSubscription.length,
              itemBuilder: (context, i) {
                final hit = inSubscription[i];
                final id = hit.candidate.movieId;
                return MediaCard(
                  title: hit.candidate.title,
                  posterPath: hit.candidate.posterPath,
                  subtitle: hit.provider,
                  status: CollectionStatus.wishlist,
                  onTap: id == null ? null : () => context.push('/movie/$id'),
                );
              },
            ),
            gap,
          ],
          if (recent.isNotEmpty) ...[
            ShelfRow(
              title: 'Zuletzt hinzugefügt',
              onAction: () => context.go('/collection'),
              itemCount: recent.length,
              itemBuilder: (context, i) {
                final m = recent[i];
                return MediaCard(
                  title: m.title,
                  posterPath: m.posterPath,
                  subtitle: m.releaseYear?.toString(),
                  status: m.status,
                  onTap: () => context.push('/movie/${m.id}'),
                );
              },
            ),
            gap,
          ],
          if (gaps.isNotEmpty)
            ShelfRow(
              title: 'Reihen vervollständigen',
              onAction: () => context.push('/missing'),
              itemCount: gaps.length,
              itemBuilder: (context, i) {
                final g = gaps[i];
                final all = g.collection.entries.length;
                final missing = g.missingEntries.length;
                return MediaCard(
                  title: g.collection.name,
                  posterPath: g.collection.posterPath,
                  subtitle: missing == 1
                      ? '1 Teil fehlt'
                      : '$missing Teile fehlen',
                  badge: MediaBadge.text('${all - missing}/$all'),
                  onTap: () => context.push('/collections/${g.collection.id}'),
                );
              },
            ),
        ],
      ),
    );
  }
}
