import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../models/collection_status.dart';

Color colorForStatus(CollectionStatus status) => switch (status) {
  CollectionStatus.owned => AppColors.sage,
  CollectionStatus.wishlist => AppColors.dustyRose,
  CollectionStatus.open => AppColors.amber,
};

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
    final color = colorForStatus(status);
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
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: compact ? 12 : 13,
            ),
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
        color: AppColors.neutralGray.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle_outlined, size: 16, color: AppColors.neutralGray),
          SizedBox(width: 4),
          Text(
            'Fehlt',
            style: TextStyle(
              color: AppColors.neutralGray,
              fontWeight: FontWeight.w600,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}
