import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/speednema_colors.dart';
import '../../../app/theme/tokens.g.dart';
import '../../../shared/models/collection_status.dart';
import '../application/scan_providers.dart';
import '../domain/scan_assessment.dart';

/// The answer to "Do I already own this?", in one or two words, before
/// anything else on the screen.
class Verdict {
  const Verdict({
    required this.title,
    required this.icon,
    required this.tone,
    this.detail,
    this.owned = false,
  });

  final String title;
  final String? detail;
  final IconData icon;
  final Color Function(SpeednemaColors colors) tone;

  /// Already in the collection in some form: confirmed with a firmer
  /// haptic, because that is the answer people at a flea market look for.
  final bool owned;
}

/// The most important thing first: owning this exact edition beats owning
/// another one, beats the wishlist, beats a gap in a series.
const _priority = [
  ScanVerdict.alreadyOwnedExact,
  ScanVerdict.otherEditionOwned,
  ScanVerdict.digitalDuplicate,
  ScanVerdict.wishlistMatch,
  ScanVerdict.upgrade,
  ScanVerdict.collectionGap,
  ScanVerdict.missingSeason,
  ScanVerdict.newDiscovery,
];

/// The insight the panel leads with, or null.
ScanInsight? headlineInsight(ScanAssessment? assessment) {
  if (assessment == null) return null;
  for (final verdict in _priority) {
    final match = assessment.insights.where((i) => i.verdict == verdict);
    if (match.isNotEmpty) return match.first;
  }
  return null;
}

Verdict verdictFor(ScanAssessment? assessment, CollectionStatus? status) {
  final insight = headlineInsight(assessment);
  if (insight != null) {
    return switch (insight.verdict) {
      ScanVerdict.alreadyOwnedExact => Verdict(
        title: 'Hab ich',
        detail: insight.message,
        icon: Icons.check_circle,
        tone: (c) => c.owned,
        owned: true,
      ),
      ScanVerdict.otherEditionOwned => Verdict(
        title: 'Hab ich – andere Ausgabe',
        detail: insight.message,
        icon: Icons.inventory_2_outlined,
        tone: (c) => c.owned,
        owned: true,
      ),
      ScanVerdict.digitalDuplicate => Verdict(
        title: 'Auf deinem Server',
        detail: insight.message,
        icon: Icons.dns_outlined,
        tone: (c) => c.owned,
        owned: true,
      ),
      ScanVerdict.wishlistMatch => Verdict(
        title: 'Auf deiner Wunschliste',
        detail: insight.message,
        icon: Icons.favorite,
        tone: (c) => c.accent,
      ),
      ScanVerdict.upgrade => Verdict(
        title: 'Besser als deine Ausgabe',
        detail: insight.message,
        icon: Icons.trending_up,
        tone: (c) => c.attention,
      ),
      ScanVerdict.collectionGap => Verdict(
        title: 'Fehlt in deiner Reihe',
        detail: insight.message,
        icon: Icons.extension_outlined,
        tone: (c) => c.attention,
      ),
      ScanVerdict.missingSeason => Verdict(
        title: 'Fehlende Staffel',
        detail: insight.message,
        icon: Icons.playlist_add,
        tone: (c) => c.attention,
      ),
      ScanVerdict.newDiscovery => Verdict(
        title: 'Neu für dich',
        detail: insight.message,
        icon: Icons.new_releases_outlined,
        tone: (c) => c.textSecondary,
      ),
    };
  }
  return switch (status) {
    CollectionStatus.owned => Verdict(
      title: 'Hab ich',
      icon: Icons.check_circle,
      tone: (c) => c.owned,
      owned: true,
    ),
    CollectionStatus.wishlist => Verdict(
      title: 'Auf deiner Wunschliste',
      icon: Icons.favorite,
      tone: (c) => c.accent,
    ),
    CollectionStatus.open => Verdict(
      title: 'Noch nicht gekauft',
      detail: 'Du hast den Film notiert, aber nicht als gekauft markiert.',
      icon: Icons.hourglass_bottom,
      tone: (c) => c.attention,
    ),
    null => Verdict(
      title: 'Neu für dich',
      detail: 'Diesen Film hast du noch nicht in deiner Sammlung.',
      icon: Icons.new_releases_outlined,
      tone: (c) => c.textSecondary,
    ),
  };
}

/// The verdict, large, at the top of a Fundstück result: readable at arm's
/// length, confirmed by a haptic, marked exact or probable.
class VerdictPanel extends ConsumerStatefulWidget {
  const VerdictPanel({super.key, this.request, this.status});

  /// What to assess; null when only the collection status is known.
  final AssessmentRequest? request;

  /// The collection status of the title, when it is in the collection.
  final CollectionStatus? status;

  @override
  ConsumerState<VerdictPanel> createState() => _VerdictPanelState();
}

class _VerdictPanelState extends ConsumerState<VerdictPanel>
    with SingleTickerProviderStateMixin {
  late final AnimationController _enter = AnimationController(
    vsync: this,
    duration: AppMotion.enter,
  );
  String? _confirmed;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _enter.value = 1;
    } else if (_enter.value == 0 && !_enter.isAnimating) {
      _enter.forward();
    }
  }

  @override
  void dispose() {
    _enter.dispose();
    super.dispose();
  }

  void _confirm(Verdict verdict) {
    // Once per verdict, not on every rebuild.
    if (_confirmed == verdict.title) return;
    _confirmed = verdict.title;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      verdict.owned
          ? HapticFeedback.heavyImpact()
          : HapticFeedback.selectionClick();
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final assessment = widget.request == null
        ? null
        : ref.watch(scanAssessmentProvider(widget.request!)).valueOrNull;
    final verdict = verdictFor(assessment, widget.status);
    final tone = verdict.tone(colors);
    final exact = assessment?.confidence == MatchConfidence.exact;
    _confirm(verdict);

    return FadeTransition(
      opacity: _enter,
      child: SlideTransition(
        position: Tween(
          begin: const Offset(0, 0.08),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: _enter, curve: Curves.easeOut)),
        child: Semantics(
          liveRegion: true,
          container: true,
          label: [verdict.title, ?verdict.detail].join('. '),
          excludeSemantics: true,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppSpacing.xl),
            decoration: BoxDecoration(
              color: colors.tint(tone),
              borderRadius: BorderRadius.circular(AppRadii.card),
              border: Border.all(color: tone.withValues(alpha: 0.5)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(verdict.icon, color: tone, size: 40),
                    const Spacer(),
                    if (assessment != null) _ConfidenceChip(exact: exact),
                  ],
                ),
                const SizedBox(height: AppSpacing.m),
                Text(
                  verdict.title,
                  style: text.displaySmall?.copyWith(color: colors.text),
                ),
                if (verdict.detail != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(verdict.detail!, style: text.bodyLarge),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ConfidenceChip extends StatelessWidget {
  const _ConfidenceChip({required this.exact});

  final bool exact;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.s,
        vertical: AppSpacing.xs,
      ),
      decoration: ShapeDecoration(
        color: colors.surface,
        shape: StadiumBorder(side: BorderSide(color: colors.outline)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            exact ? Icons.verified_outlined : Icons.help_outline,
            size: 16,
            color: colors.textSecondary,
          ),
          const SizedBox(width: AppSpacing.xs),
          Text(
            exact ? 'Genau diese Ausgabe' : 'Wahrscheinlich',
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
    );
  }
}
