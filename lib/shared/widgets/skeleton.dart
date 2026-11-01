import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
import '../../app/theme/tokens.g.dart';
import 'shelf_row.dart';

/// Placeholders shaped like the content that is loading, so a screen shows
/// its structure at once instead of a lone spinner. They pulse gently
/// unless the system asks for reduced motion, and announce "Wird geladen"
/// once to screen readers.
class Skeleton extends StatefulWidget {
  const Skeleton({super.key, required this.child});

  /// Shapes built from [SkeletonBox].
  final Widget child;

  @override
  State<Skeleton> createState() => _SkeletonState();
}

class _SkeletonState extends State<Skeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1100),
    lowerBound: 0.55,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.disableAnimationsOf(context)) {
      _pulse
        ..stop()
        ..value = 1;
    } else if (!_pulse.isAnimating) {
      _pulse.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Wird geladen',
      liveRegion: true,
      child: ExcludeSemantics(
        child: FadeTransition(opacity: _pulse, child: widget.child),
      ),
    );
  }
}

/// One placeholder block.
class SkeletonBox extends StatelessWidget {
  const SkeletonBox({
    super.key,
    this.width,
    this.height,
    this.radius = AppRadii.control / 2,
  });

  final double? width;
  final double? height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: context.colors.hairline,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Stand-in for a [ShelfRow].
class SkeletonShelfRow extends StatelessWidget {
  const SkeletonShelfRow({super.key, this.itemWidth = 120, this.count = 4});

  final double itemWidth;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.l),
            child: SkeletonBox(width: 160, height: 22),
          ),
          const SizedBox(height: AppSpacing.s + AppSpacing.m),
          SizedBox(
            height: itemWidth * 3 / 2 + ShelfRow.captionHeight(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              physics: const NeverScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.l),
              itemCount: count,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.m),
              itemBuilder: (_, _) => _PosterPlaceholder(width: itemWidth),
            ),
          ),
        ],
      ),
    );
  }
}

/// Stand-in for a poster grid.
class SkeletonPosterGrid extends StatelessWidget {
  const SkeletonPosterGrid({super.key, this.maxItemWidth = 150});

  final double maxItemWidth;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(AppSpacing.l),
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: maxItemWidth,
          mainAxisSpacing: AppSpacing.l,
          crossAxisSpacing: AppSpacing.m,
          childAspectRatio: 0.55,
        ),
        itemCount: 12,
        itemBuilder: (_, _) => LayoutBuilder(
          builder: (_, c) => _PosterPlaceholder(width: c.maxWidth),
        ),
      ),
    );
  }
}

/// Stand-in for a list of rows.
class SkeletonList extends StatelessWidget {
  const SkeletonList({super.key, this.rows = 6});

  final int rows;

  @override
  Widget build(BuildContext context) {
    return Skeleton(
      child: Column(
        children: [
          for (var i = 0; i < rows; i++)
            const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: AppSpacing.l,
                vertical: AppSpacing.s,
              ),
              child: Row(
                children: [
                  SkeletonBox(
                    width: 48,
                    height: 72,
                    radius: AppRadii.poster / 2,
                  ),
                  SizedBox(width: AppSpacing.m),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(height: 16),
                        SizedBox(height: AppSpacing.s),
                        SkeletonBox(width: 90, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _PosterPlaceholder extends StatelessWidget {
  const _PosterPlaceholder({required this.width});

  final double width;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SkeletonBox(
          width: width,
          height: width * 3 / 2,
          radius: AppRadii.poster,
        ),
        const SizedBox(height: AppSpacing.s),
        SkeletonBox(width: width * 0.8, height: 14),
        const SizedBox(height: AppSpacing.xs),
        SkeletonBox(width: width * 0.4, height: 12),
      ],
    );
  }
}
