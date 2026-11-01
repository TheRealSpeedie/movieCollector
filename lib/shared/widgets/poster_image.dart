import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
import '../../core/constants/api_constants.dart';

class PosterImage extends StatelessWidget {
  const PosterImage({
    super.key,
    required this.posterPath,
    this.borderRadius = 12,
    this.fit = BoxFit.cover,
  });

  final String? posterPath;
  final double borderRadius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    final url = ApiConstants.posterUrl(posterPath);
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: AspectRatio(
        aspectRatio: 2 / 3,
        child: url.isEmpty
            ? _placeholder(context)
            : CachedNetworkImage(
                imageUrl: url,
                fit: fit,
                placeholder: (context, _) =>
                    _placeholder(context, loading: true),
                errorWidget: (context, _, __) => _placeholder(context),
              ),
      ),
    );
  }

  Widget _placeholder(BuildContext context, {bool loading = false}) {
    return Container(
      color: context.colors.hairline,
      alignment: Alignment.center,
      child: loading
          ? SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: context.colors.textSecondary,
              ),
            )
          : Icon(
              Icons.movie_outlined,
              color: context.colors.textSecondary,
              size: 32,
            ),
    );
  }
}
