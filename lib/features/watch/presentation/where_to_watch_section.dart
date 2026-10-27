import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/database/media_format.dart';
import '../application/watch_providers.dart';
import '../domain/watchability.dart';

/// "Wo kann ich das schauen?" for one movie or series.
class WhereToWatchSection extends ConsumerStatefulWidget {
  const WhereToWatchSection({
    super.key,
    required this.mediaType,
    required this.tmdbId,
    this.onServer = false,
    this.ownedFormats = const [],
  });

  /// movie or tv.
  final String mediaType;
  final int tmdbId;
  final bool onServer;
  final List<MediaFormat> ownedFormats;

  @override
  ConsumerState<WhereToWatchSection> createState() =>
      _WhereToWatchSectionState();
}

class _WhereToWatchSectionState extends ConsumerState<WhereToWatchSection> {
  var _refresh = false;

  @override
  Widget build(BuildContext context) {
    final offers = ref.watch(
      offersProvider((
        mediaType: widget.mediaType,
        tmdbId: widget.tmdbId,
        refresh: _refresh,
      )),
    );
    final subscriptions = ref.watch(subscribedIdsProvider);
    final region = ref.watch(regionProvider);
    final data = offers.valueOrNull;
    final sources = watchSources(
      onServer: widget.onServer,
      ownedFormats: [
        for (final f in widget.ownedFormats.toSet())
          f == MediaFormat.unknown ? 'Disc' : f.label,
      ],
      offers: data?.offers ?? const [],
      subscriptions: subscriptions,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                'Wo kann ich das schauen?',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            IconButton(
              tooltip: 'Angebote neu laden',
              icon: offers.isLoading
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.refresh),
              onPressed: offers.isLoading
                  ? null
                  : () => setState(() => _refresh = !_refresh),
            ),
          ],
        ),
        for (final source in sources) _SourceTile(source: source),
        if (subscriptions.isEmpty)
          TextButton.icon(
            onPressed: () => context.push('/settings/streaming'),
            icon: const Icon(Icons.subscriptions_outlined),
            label: const Text('Deine Streamingdienste angeben'),
          ),
        Text(
          [
            if (data?.checkedAt != null)
              'Angebote in $region, Stand ${DateFormat('dd.MM.yyyy').format(data!.checkedAt!)}'
            else if (!offers.isLoading)
              'Angebote konnten nicht geladen werden',
            'Daten: JustWatch über TMDB',
          ].join(' · '),
          style: const TextStyle(color: AppColors.neutralGray, fontSize: 12),
        ),
        if (data?.link != null)
          TextButton(
            onPressed: () => launchUrl(
              Uri.parse(data!.link!),
              mode: LaunchMode.externalApplication,
            ),
            child: const Text('Alle Angebote öffnen'),
          ),
      ],
    );
  }
}

class _SourceTile extends StatelessWidget {
  const _SourceTile({required this.source});

  final WatchSource source;

  @override
  Widget build(BuildContext context) {
    final (icon, color) = switch (source.option) {
      WatchOption.playNow => (Icons.play_circle, AppColors.sage),
      WatchOption.subscription => (Icons.check_circle, AppColors.sage),
      WatchOption.free => (Icons.check_circle_outline, AppColors.sage),
      WatchOption.shelf => (Icons.album_outlined, AppColors.dustyRose),
      WatchOption.rentOrBuy => (Icons.euro, AppColors.neutralGray),
      WatchOption.unavailable => (Icons.block, AppColors.neutralGray),
    };
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: source.logoPath != null
          ? ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl:
                    '${ApiConstants.tmdbImageBaseUrl}/w92${source.logoPath}',
                width: 36,
                height: 36,
                errorWidget: (_, _, _) => Icon(icon, color: color),
              ),
            )
          : Icon(icon, color: color, size: 32),
      title: Text(source.title),
      subtitle: source.detail == null ? null : Text(source.detail!),
    );
  }
}
