import 'package:flutter/material.dart';

import '../../app/app_shell.dart';
import '../../app/theme/tokens.g.dart';
import 'shelf_row.dart';

/// A grid of [MediaCard]s that adapts to the space it has: more columns on
/// wider screens, and cells exactly as tall as a poster plus its caption at
/// the current text size, so titles never clip and nothing is left blank.
class PosterGrid extends StatelessWidget {
  const PosterGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.padding = const EdgeInsets.all(AppSpacing.l),
  });

  final int itemCount;
  final IndexedWidgetBuilder itemBuilder;
  final EdgeInsets padding;

  /// The widest a poster gets before another column is added.
  static double maxPosterWidth(double screenWidth) =>
      screenWidth >= Breakpoints.medium ? 180 : 150;

  @override
  Widget build(BuildContext context) {
    final caption = ShelfRow.captionHeight(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = AppSpacing.m;
        final available = constraints.maxWidth - padding.horizontal;
        final maxWidth = maxPosterWidth(MediaQuery.sizeOf(context).width);
        final columns = ((available + spacing) / (maxWidth + spacing))
            .ceil()
            .clamp(2, 12);
        final cell = (available - spacing * (columns - 1)) / columns;
        return GridView.builder(
          padding: padding,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: AppSpacing.l,
            mainAxisExtent: cell * 3 / 2 + caption,
          ),
          itemCount: itemCount,
          itemBuilder: itemBuilder,
        );
      },
    );
  }
}
