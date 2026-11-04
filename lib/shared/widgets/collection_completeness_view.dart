import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
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
                Icon(
                  Icons.collections_bookmark_outlined,
                  color: context.colors.accent,
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
                backgroundColor: context.colors.hairline,
                color: context.colors.owned,
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
                              ? context.colors.accent
                              : context.colors.text,
                        ),
                      ),
                    ),
                    if (entry.tmdbMovieId == highlightTmdbMovieId)
                      Text(
                        'dieser Film',
                        style: TextStyle(
                          fontSize: 11,
                          color: context.colors.accent,
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
      return Icon(
        Icons.circle_outlined,
        size: 18,
        color: context.colors.textSecondary,
      );
    }
    return Icon(
      iconForStatus(status!),
      size: 18,
      color: context.colors.forStatus(status!),
    );
  }
}
