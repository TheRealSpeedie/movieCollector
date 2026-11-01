import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
import '../models/collection_status.dart';

IconData iconForStatus(CollectionStatus status) => switch (status) {
  CollectionStatus.owned => Icons.check_circle,
  CollectionStatus.wishlist => Icons.favorite,
  CollectionStatus.open => Icons.hourglass_bottom,
};

class StatusChip extends StatelessWidget {
  const StatusChip({super.key, required this.status, this.compact = false});

  final CollectionStatus status;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = context.colors.forStatus(status);
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 12,
        vertical: compact ? 4 : 6,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(iconForStatus(status), size: compact ? 14 : 16, color: color),
          const SizedBox(width: 4),
          Text(
            status.germanLabel,
            style:
                (compact
                        ? Theme.of(context).textTheme.labelMedium
                        : Theme.of(context).textTheme.labelLarge)
                    ?.copyWith(color: color, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class MissingChip extends StatelessWidget {
  const MissingChip({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: context.colors.textSecondary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle_outlined,
            size: 16,
            color: context.colors.textSecondary,
          ),
          SizedBox(width: 4),
          Text(
            'Fehlt',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: context.colors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
