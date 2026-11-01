import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
import '../../app/theme/tokens.g.dart';
import '../models/collection_status.dart';
import 'poster_image.dart';
import 'status_chip.dart';

/// A small fact shown on top of a poster: playable on the server, or how
/// much of a series is owned. At most one per card.
class MediaBadge {
  const MediaBadge.playable() : icon = Icons.play_arrow_rounded, label = null;
  const MediaBadge.text(String this.label) : icon = null;

  final IconData? icon;
  final String? label;

  String get semanticLabel => label ?? 'Auf deinem Server abspielbar';
}

/// A poster with title and year: the way Speednema shows a film or series
/// in grids and shelf rows.
///
/// Ownership appears as a thin "spine" on the poster's leading edge, like a
/// disc on a shelf. Colour is never the only signal: the status is part of
/// the card's screen-reader label, and list rows and detail pages name it.
class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.title,
    this.posterPath,
    this.artwork,
    this.subtitle,
    this.status,
    this.badge,
    this.onTap,
    this.onLongPress,
  });

  final String title;

  /// TMDB poster path. Ignored when [artwork] is given.
  final String? posterPath;

  /// Custom artwork, e.g. an image from the user's server.
  final Widget? artwork;

  /// Usually the release year.
  final String? subtitle;
  final CollectionStatus? status;
  final MediaBadge? badge;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  static const spineWidth = 3.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final label = [
      title,
      ?subtitle,
      if (status != null) status!.germanLabel,
      if (badge != null) badge!.semanticLabel,
    ].join(', ');

    return Semantics(
      button: onTap != null,
      label: label,
      excludeSemantics: true,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppRadii.poster),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(AppRadii.poster),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    artwork ??
                        PosterImage(posterPath: posterPath, borderRadius: 0),
                    if (status != null)
                      PositionedDirectional(
                        start: 0,
                        top: 0,
                        bottom: 0,
                        width: spineWidth,
                        child: ColoredBox(color: colors.forStatus(status!)),
                      ),
                    if (badge != null)
                      PositionedDirectional(
                        end: AppSpacing.xs + 2,
                        bottom: AppSpacing.xs + 2,
                        child: _Badge(badge: badge!),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.s),
            Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
            ),
            if (subtitle != null)
              Text(
                subtitle!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: text.bodySmall,
              ),
          ],
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({required this.badge});

  final MediaBadge badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return DecoratedBox(
      decoration: ShapeDecoration(
        color: colors.scrim,
        shape: const StadiumBorder(),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: badge.label == null ? AppSpacing.xs : AppSpacing.s,
          vertical: 2,
        ),
        child: badge.label == null
            ? Icon(badge.icon, size: 18, color: colors.onMedia)
            : Text(
                badge.label!,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.onMedia,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}

/// A film or series as a list row: small poster, title, metadata, status.
class MediaRow extends StatelessWidget {
  const MediaRow({
    super.key,
    required this.title,
    this.posterPath,
    this.artwork,
    this.subtitle,
    this.status,
    this.trailing,
    this.onTap,
  });

  final String title;
  final String? posterPath;
  final Widget? artwork;
  final String? subtitle;
  final CollectionStatus? status;

  /// Replaces the status chip, e.g. with an action.
  final Widget? trailing;
  final VoidCallback? onTap;

  /// From this text scale on, the trailing chip moves under the title so
  /// the title keeps the row's width.
  static const _stackedFromScale = 1.5;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    final end =
        trailing ??
        (status == null ? null : StatusChip(status: status!, compact: true));
    final stacked =
        MediaQuery.textScalerOf(context).scale(10) / 10 >= _stackedFromScale;
    return MergeSemantics(
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.s,
          ),
          child: Row(
            children: [
              SizedBox(
                width: 48,
                child:
                    artwork ??
                    PosterImage(
                      posterPath: posterPath,
                      borderRadius: AppRadii.poster / 2,
                    ),
              ),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: stacked ? 3 : 2,
                      overflow: TextOverflow.ellipsis,
                      style: text.titleMedium,
                    ),
                    if (subtitle != null)
                      Text(subtitle!, style: text.bodySmall),
                    if (stacked && end != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      end,
                    ],
                  ],
                ),
              ),
              if (!stacked && end != null) ...[
                const SizedBox(width: AppSpacing.s),
                end,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
