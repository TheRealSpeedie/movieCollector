import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../watch/application/watch_providers.dart';
import '../application/catalog_providers.dart';

/// "Weitere Ausgaben": releases of the film from the edition catalog that
/// are not in the collection yet, with a hint when one is better than what
/// the person owns. Taking one over stores it on the device.
class KnownEditionsSection extends ConsumerWidget {
  const KnownEditionsSection({
    super.key,
    required this.movieId,
    required this.tmdbId,
  });

  final int movieId;
  final int tmdbId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final catalog = ref.watch(editionCatalogProvider);
    if (catalog == null) return const SizedBox.shrink();
    final entries = ref.watch(catalogEditionsProvider(tmdbId)).valueOrNull;
    // Rebuild when the own editions change.
    ref.watch(movieEditionsProvider(movieId));
    final repository = ref.read(copyRepositoryProvider);

    return FutureBuilder(
      future: repository.knownForMovie(movieId),
      builder: (context, snapshot) {
        final known = snapshot.data;
        if (entries == null || known == null) return const SizedBox.shrink();
        final fresh = [
          for (final e in entries)
            if (!known.catalogIds.contains(e.id) &&
                !e.barcodes.any(known.barcodes.contains))
              e,
        ];
        if (fresh.isEmpty) return const SizedBox.shrink();
        final attributions = {
          for (final e in fresh) e.attribution ?? 'Movie Shelf users',
        };
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            Text(
              'Weitere Ausgaben',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            for (final entry in fresh)
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.album_outlined),
                title: Text(
                  [
                    entry.format.label,
                    if (entry.editionName != null) entry.editionName!,
                  ].join(' · '),
                ),
                subtitle: Text(
                  [
                    if (known.bestOwnedRank > 0 &&
                        entry.format.rank > known.bestOwnedRank)
                      'Besser als deine Ausgabe',
                    if (entry.region != null) 'Region ${entry.region}',
                    if (entry.audioLanguages != null)
                      'Ton ${entry.audioLanguages}',
                    if (entry.publisher != null) entry.publisher!,
                    if (entry.pending) 'wartet auf Prüfung',
                  ].join(' · '),
                ),
                trailing: TextButton(
                  onPressed: () async {
                    await repository.adoptCatalogEdition(movieId, entry);
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Ausgabe übernommen. Tippe auf „Besitze ich“, wenn du sie hast.',
                          ),
                        ),
                      );
                    }
                  },
                  child: const Text('Übernehmen'),
                ),
              ),
            Text(
              'Ausgabe-Daten: ${attributions.join(', ')}, über ${catalog.name}. '
              'Filmdaten: TMDB.',
              style: const TextStyle(
                color: AppColors.neutralGray,
                fontSize: 12,
              ),
            ),
          ],
        );
      },
    );
  }
}
