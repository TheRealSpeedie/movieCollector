import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/speednema_colors.dart';
import '../application/scan_providers.dart';
import '../domain/scan_assessment.dart';
import 'verdict_panel.dart';

/// What the scan means for the collection, with a clear exact/probable mark.
class ScanInsightsCard extends ConsumerWidget {
  const ScanInsightsCard({
    super.key,
    required this.request,
    this.belowVerdict = false,
  });

  final AssessmentRequest request;

  /// Shown under a [VerdictPanel]: leaves out the headline insight and the
  /// exact/probable mark, which the panel already shows.
  final bool belowVerdict;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final assessment = ref.watch(scanAssessmentProvider(request)).valueOrNull;
    if (assessment == null) return const SizedBox.shrink();
    final exact = assessment.confidence == MatchConfidence.exact;
    final headline = belowVerdict ? headlineInsight(assessment) : null;
    final insights = [
      for (final i in assessment.insights)
        if (!identical(i, headline)) i,
    ];
    if (belowVerdict && insights.isEmpty && assessment.maxPrice == null) {
      return const SizedBox.shrink();
    }
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (!belowVerdict) ...[
              Chip(
                avatar: Icon(
                  exact ? Icons.verified_outlined : Icons.help_outline,
                  size: 18,
                ),
                label: Text(
                  exact ? 'Exakte Edition' : 'Wahrscheinlicher Titel',
                ),
                visualDensity: VisualDensity.compact,
              ),
              const SizedBox(height: 8),
            ],
            for (final insight in insights)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      _icon(insight.verdict),
                      color: _color(insight, context.colors),
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
                style: TextStyle(color: context.colors.textSecondary),
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
    ScanVerdict.newDiscovery => Icons.new_releases_outlined,
  };

  static Color _color(ScanInsight insight, SpeednemaColors colors) =>
      switch (insight.verdict) {
        ScanVerdict.alreadyOwnedExact ||
        ScanVerdict.otherEditionOwned => colors.owned,
        ScanVerdict.wishlistMatch => colors.accent,
        _ when insight.isOpportunity => colors.attention,
        _ => colors.textSecondary,
      };
}
