import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../application/scan_providers.dart';
import '../domain/scan_assessment.dart';

/// What the scan means for the collection, with a clear exact/probable mark.
class ScanInsightsCard extends ConsumerWidget {
  const ScanInsightsCard({super.key, required this.request});

  final AssessmentRequest request;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessment = ref.watch(scanAssessmentProvider(request)).valueOrNull;
    if (assessment == null) return const SizedBox.shrink();
    final exact = assessment.confidence == MatchConfidence.exact;
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              avatar: Icon(
                exact ? Icons.verified_outlined : Icons.help_outline,
                size: 18,
              ),
              label: Text(exact ? 'Exakte Edition' : 'Wahrscheinlicher Titel'),
              visualDensity: VisualDensity.compact,
            ),
            const SizedBox(height: 8),
            for (final insight in assessment.insights)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _icon(insight.verdict),
                      color: _color(insight),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Expanded(child: Text(insight.message)),
                  ],
                ),
              ),
            if (assessment.maxPrice != null) ...[
              const SizedBox(height: 4),
              Text(
                'Dein Höchstpreis: ${assessment.maxPrice!.toStringAsFixed(2)} €',
                style: const TextStyle(color: AppColors.neutralGray),
              ),
            ],
          ],
        ),
      ),
    );
  }

  static IconData _icon(ScanVerdict verdict) => switch (verdict) {
    ScanVerdict.alreadyOwnedExact => Icons.check_circle,
    ScanVerdict.otherEditionOwned => Icons.inventory_2_outlined,
    ScanVerdict.upgrade => Icons.trending_up,
    ScanVerdict.wishlistMatch => Icons.favorite,
    ScanVerdict.collectionGap => Icons.extension_outlined,
    ScanVerdict.missingSeason => Icons.playlist_add,
    ScanVerdict.digitalDuplicate => Icons.dns_outlined,
    ScanVerdict.newDiscovery => Icons.fiber_new_outlined,
  };

  static Color _color(ScanInsight insight) => switch (insight.verdict) {
    ScanVerdict.alreadyOwnedExact ||
    ScanVerdict.otherEditionOwned => AppColors.sage,
    ScanVerdict.wishlistMatch => AppColors.dustyRose,
    _ when insight.isOpportunity => AppColors.amber,
    _ => AppColors.neutralGray,
  };
}
