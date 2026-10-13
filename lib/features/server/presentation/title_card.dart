import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../domain/server_models.dart';
import 'server_image.dart';

class TitleCard extends StatelessWidget {
  const TitleCard({super.key, required this.title});

  final ServerTitle title;

  @override
  Widget build(BuildContext context) {
    final progress = title.isSeries
        ? (title.totalEpisodes == 0
              ? 0.0
              : title.watchedEpisodes / title.totalEpisodes)
        : title.fraction;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: () => context.push('/server/title/${title.id}'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Stack(
              fit: StackFit.expand,
              children: [
                ServerImage(path: title.posterUrl),
                if (title.watched)
                  const Positioned(
                    top: 6,
                    right: 6,
                    child: CircleAvatar(
                      radius: 11,
                      backgroundColor: AppColors.sage,
                      child: Icon(
                        Icons.check,
                        size: 14,
                        color: AppColors.background,
                      ),
                    ),
                  ),
                if (!title.watched && progress > 0)
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: LinearProgressIndicator(
                      value: progress.clamp(0, 1).toDouble(),
                      minHeight: 4,
                      backgroundColor: Colors.black54,
                      color: AppColors.dustyRose,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
          ),
          Text(
            [
              if (title.year != null) '${title.year}',
              if (title.isSeries) 'Serie',
            ].join(' · '),
            style: const TextStyle(color: AppColors.neutralGray, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
