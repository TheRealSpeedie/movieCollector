import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../models/collection_status.dart';
import '../models/collection_with_entries.dart';
import 'status_chip.dart';

class CollectionCompletenessView extends StatelessWidget {
  const CollectionCompletenessView({
    super.key,
    required this.collection,
    this.highlightTmdbMovieId,
  });

  final CollectionWithEntries collection;
  final int? highlightTmdbMovieId;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.collections_bookmark_outlined,
                  color: AppColors.dustyRose,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    collection.name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: collection.progress,
                minHeight: 7,
                backgroundColor: AppColors.divider,
                color: AppColors.sage,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '${collection.ownedCount} / ${collection.totalCount} gekauft',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            for (final entry in collection.entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    _EntryIcon(status: entry.localMovie?.status),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        entry.title,
                        style: TextStyle(
                          fontWeight: entry.tmdbMovieId == highlightTmdbMovieId
                              ? FontWeight.w800
                              : FontWeight.w400,
                          color: entry.tmdbMovieId == highlightTmdbMovieId
                              ? AppColors.dustyRose
                              : AppColors.charcoal,
                        ),
                      ),
                    ),
                    if (entry.tmdbMovieId == highlightTmdbMovieId)
                      const Text(
                        'dieser Film',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.dustyRose,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _EntryIcon extends StatelessWidget {
  const _EntryIcon({required this.status});

  final CollectionStatus? status;

  @override
  Widget build(BuildContext context) {
    if (status == null) {
      return const Icon(
        Icons.circle_outlined,
        size: 18,
        color: AppColors.neutralGray,
      );
    }
    return Icon(
      iconForStatus(status!),
      size: 18,
      color: colorForStatus(status!),
    );
  }
}
