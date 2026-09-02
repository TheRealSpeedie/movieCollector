import 'package:flutter/material.dart';

import '../../app/theme/app_colors.dart';
import '../../core/network/tmdb/tmdb_models.dart';
import 'poster_image.dart';

/// Reusable tile for displaying a single TMDB search/candidate result.
///
/// Used both for the inline ambiguous-match candidates in the import review
/// and for the full manual movie search screen, so the two flows share one
/// visual representation.
class MovieSearchResultTile extends StatelessWidget {
  const MovieSearchResultTile({
    super.key,
    required this.title,
    this.originalTitle,
    this.releaseYear,
    this.posterPath,
    this.overview,
    this.trailing,
    this.onTap,
  });

  factory MovieSearchResultTile.fromResult(
    TmdbSearchResult result, {
    Key? key,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return MovieSearchResultTile(
      key: key,
      title: result.title,
      originalTitle: result.originalTitle,
      releaseYear: result.releaseYear,
      posterPath: result.posterPath,
      overview: result.overview,
      trailing: trailing,
      onTap: onTap,
    );
  }

  factory MovieSearchResultTile.fromTvResult(
    TmdbTvSearchResult result, {
    Key? key,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return MovieSearchResultTile(
      key: key,
      title: result.name,
      originalTitle: result.originalName,
      releaseYear: result.firstAirYear,
      posterPath: result.posterPath,
      overview: result.overview,
      trailing: trailing,
      onTap: onTap,
    );
  }

  final String title;
  final String? originalTitle;
  final int? releaseYear;
  final String? posterPath;
  final String? overview;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 56,
                child: PosterImage(posterPath: posterPath, borderRadius: 10),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    if (originalTitle != null && originalTitle != title)
                      Text(
                        originalTitle!,
                        style: const TextStyle(
                          color: AppColors.neutralGray,
                          fontSize: 12,
                        ),
                      ),
                    if (releaseYear != null)
                      Text(
                        '$releaseYear',
                        style: const TextStyle(
                          color: AppColors.neutralGray,
                          fontSize: 12,
                        ),
                      ),
                    if (overview != null && overview!.trim().isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          overview!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: AppColors.neutralGray,
                            fontSize: 12,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              trailing ??
                  const Icon(Icons.chevron_right, color: AppColors.neutralGray),
            ],
          ),
        ),
      ),
    );
  }
}
