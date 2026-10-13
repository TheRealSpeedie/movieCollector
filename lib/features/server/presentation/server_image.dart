import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../application/server_providers.dart';

class ServerImage extends ConsumerStatefulWidget {
  const ServerImage({
    super.key,
    required this.path,
    this.aspectRatio = 2 / 3,
    this.borderRadius = 12,
    this.fit = BoxFit.cover,
    this.icon = Icons.movie_outlined,
  });

  final String? path;
  final double aspectRatio;
  final double borderRadius;
  final BoxFit fit;
  final IconData icon;

  @override
  ConsumerState<ServerImage> createState() => _ServerImageState();
}

class _ServerImageState extends ConsumerState<ServerImage> {
  late final Future<Map<String, String>>? _headers = ref
      .read(serverClientProvider)
      ?.authHeaders();

  @override
  Widget build(BuildContext context) {
    final client = ref.read(serverClientProvider);
    final path = widget.path;
    return ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: AspectRatio(
        aspectRatio: widget.aspectRatio,
        child: client == null || path == null || path.isEmpty
            ? _placeholder()
            : FutureBuilder<Map<String, String>>(
                future: _headers,
                builder: (context, snapshot) {
                  if (snapshot.hasError) return _placeholder();
                  if (!snapshot.hasData) return _placeholder(loading: true);
                  return CachedNetworkImage(
                    imageUrl: client.url(path),
                    cacheKey: path,
                    httpHeaders: snapshot.data,
                    fit: widget.fit,
                    placeholder: (context, _) => _placeholder(loading: true),
                    errorWidget: (context, _, __) => _placeholder(),
                  );
                },
              ),
      ),
    );
  }

  Widget _placeholder({bool loading = false}) {
    return Container(
      color: AppColors.divider,
      alignment: Alignment.center,
      child: loading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppColors.neutralGray,
              ),
            )
          : Icon(widget.icon, color: AppColors.neutralGray, size: 32),
    );
  }
}
