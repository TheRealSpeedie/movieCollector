import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/models/collection_with_entries.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../collections/application/collections_providers.dart';
import '../../movies/application/movie_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movies = ref.watch(allMoviesProvider);
    final counts = ref.watch(collectionCountsProvider);
    final recent = ref.watch(recentlyAddedMoviesProvider);
    final collections = ref.watch(allCollectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          AppConstants.appName,
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(allMoviesProvider);
            ref.invalidate(allCollectionsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _StatsRow(
                total: movies.valueOrNull?.length ?? 0,
                counts: counts.valueOrNull,
              ),
              const SizedBox(height: 20),
              _FundstueckCta(onTap: () => context.go('/scanner')),
              const SizedBox(height: 24),
              _QuickActions(),
              const SizedBox(height: 24),
              if ((recent.valueOrNull ?? []).isNotEmpty) ...[
                _SectionHeader(
                  title: 'Zuletzt hinzugefügt',
                  onSeeAll: () => context.go('/collection'),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 190,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recent.valueOrNull!.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final movie = recent.valueOrNull![index];
                      return SizedBox(
                        width: 120,
                        child: GestureDetector(
                          onTap: () => context.push('/movie/${movie.id}'),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: PosterImage(
                                  posterPath: movie.posterPath,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                movie.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],
              if ((collections.valueOrNull ?? []).isNotEmpty) ...[
                _SectionHeader(
                  title: 'Deine Reihen',
                  onSeeAll: () => context.go('/collections'),
                ),
                const SizedBox(height: 12),
                ...collections.valueOrNull!
                    .take(3)
                    .map(
                      (collection) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _CollectionProgressCard(
                          name: collection.name,
                          posterPath: collection.posterPath,
                          owned: collection.ownedCount,
                          total: collection.totalCount,
                          onTap: () =>
                              context.push('/collections/${collection.id}'),
                        ),
                      ),
                    ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.total, required this.counts});

  final int total;
  final Map<CollectionStatus, int>? counts;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Deine Sammlung',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  '$total Filme',
                  style: const TextStyle(color: AppColors.neutralGray),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                _StatItem(
                  label: CollectionStatus.owned.germanLabel,
                  value: counts?[CollectionStatus.owned] ?? 0,
                  color: AppColors.sage,
                ),
                _StatItem(
                  label: CollectionStatus.wishlist.germanLabel,
                  value: counts?[CollectionStatus.wishlist] ?? 0,
                  color: AppColors.dustyRose,
                ),
                _StatItem(
                  label: CollectionStatus.open.germanLabel,
                  value: counts?[CollectionStatus.open] ?? 0,
                  color: AppColors.amber,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.neutralGray),
          ),
        ],
      ),
    );
  }
}

class _FundstueckCta extends StatelessWidget {
  const _FundstueckCta({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFF252830),
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 22),
          child: Row(
            children: [
              Icon(Icons.qr_code_scanner, color: AppColors.dustyRose, size: 32),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Fundstück-Check',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Barcode scannen und sofort wissen, ob du den Film schon hast',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/search'),
            icon: const Icon(Icons.search),
            label: const Text('Nach Titel suchen'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => context.push('/import'),
            icon: const Icon(Icons.upload_file_outlined),
            label: const Text('Importieren'),
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, this.onSeeAll});

  final String title;
  final VoidCallback? onSeeAll;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        if (onSeeAll != null)
          TextButton(onPressed: onSeeAll, child: const Text('Alle ansehen')),
      ],
    );
  }
}

class _CollectionProgressCard extends StatelessWidget {
  const _CollectionProgressCard({
    required this.name,
    required this.posterPath,
    required this.owned,
    required this.total,
    required this.onTap,
  });

  final String name;
  final String? posterPath;
  final int owned;
  final int total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final progress = total == 0 ? 0.0 : owned / total;
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                child: PosterImage(posterPath: posterPath, borderRadius: 10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(6),
                      child: LinearProgressIndicator(
                        value: progress,
                        minHeight: 6,
                        backgroundColor: AppColors.divider,
                        color: AppColors.sage,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '$owned / $total gekauft',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.neutralGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
