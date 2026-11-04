import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
import '../../app/theme/tokens.g.dart';
import 'section_header.dart';

/// A titled, horizontally scrolling row of posters standing on a shelf: a
/// hairline runs under the posters, like the board in Speednema's logo.
///
/// Items are laid out lazily, so long rows stay cheap. The row's height
/// follows the system text size, so titles never clip.
class ShelfRow extends StatelessWidget {
  const ShelfRow({
    super.key,
    required this.title,
    required this.itemCount,
    required this.itemBuilder,
    this.actionLabel = 'Alle',
    this.onAction,
    this.itemWidth = 120,
  });

  final String title;
  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final String actionLabel;
  final VoidCallback? onAction;
  final double itemWidth;

  /// Room for a two-line title and a caption under each poster.
  static double captionHeight(BuildContext context) {
    final scaler = MediaQuery.textScalerOf(context);
    final text = Theme.of(context).textTheme;
    double line(TextStyle? style) =>
        scaler.scale(style!.fontSize!) * (style.height ?? 1.2);
    return AppSpacing.s + 2 * line(text.bodyMedium) + line(text.bodySmall);
  }

  @override
  Widget build(BuildContext context) {
    final posterHeight = itemWidth * 3 / 2;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          actionLabel: onAction == null ? null : actionLabel,
          onAction: onAction,
        ),
        const SizedBox(height: AppSpacing.s),
        SizedBox(
          height: posterHeight + captionHeight(context),
          child: Stack(
            children: [
              // The shelf board, just below the posters.
              Positioned(
                left: 0,
                right: 0,
                top: posterHeight + 1,
                height: 2,
                child: ExcludeSemantics(
                  child: ColoredBox(color: context.colors.hairline),
                ),
              ),
              ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
                itemCount: itemCount,
                separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
                itemBuilder: (context, index) => SizedBox(
                  width: itemWidth,
                  child: itemBuilder(context, index),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
