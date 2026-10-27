import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/constants/api_constants.dart';
import '../../../core/network/tmdb/tmdb_watch_models.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../application/watch_providers.dart';

final _providersProvider = FutureProvider.autoDispose<List<TmdbProvider>>(
  (ref) =>
      ref.watch(watchRepositoryProvider).providers(ref.watch(regionProvider)),
);

/// The streaming services the user pays for. They decide what counts as
/// "in your subscription"; they never count as ownership.
class SubscriptionsScreen extends ConsumerStatefulWidget {
  const SubscriptionsScreen({super.key});

  @override
  ConsumerState<SubscriptionsScreen> createState() =>
      _SubscriptionsScreenState();
}

class _SubscriptionsScreenState extends ConsumerState<SubscriptionsScreen> {
  var _search = '';

  @override
  Widget build(BuildContext context) {
    final providers = ref.watch(_providersProvider);
    final subscribed = ref.watch(subscribedIdsProvider);
    final repository = ref.read(watchRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Streamingdienste')),
      body: providers.when(
        loading: () => const LoadingView(),
        error: (error, _) => ErrorView(
          error: error,
          onRetry: () => ref.invalidate(_providersProvider),
        ),
        data: (all) {
          final term = _search.toLowerCase();
          final list = [
            ...all.where((p) => subscribed.contains(p.id)),
            ...all.where(
              (p) =>
                  !subscribed.contains(p.id) &&
                  (term.isEmpty || p.name.toLowerCase().contains(term)),
            ),
          ];
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Wähle, wofür du ein Abo hast. Movie Shelf zeigt dann, was '
                'du ohne Zusatzkosten schauen kannst, und meldet, wenn ein '
                'Film deiner Wunschliste dort verfügbar wird. Region: '
                '${ref.watch(regionProvider)}.',
                style: const TextStyle(color: AppColors.neutralGray),
              ),
              const SizedBox(height: 12),
              TextField(
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  labelText: 'Dienst suchen',
                ),
                onChanged: (v) => setState(() => _search = v),
              ),
              const SizedBox(height: 8),
              for (final p in list.take(term.isEmpty ? 40 : list.length))
                CheckboxListTile(
                  value: subscribed.contains(p.id),
                  onChanged: (on) => repository.setSubscribed(p, on ?? false),
                  title: Text(p.name),
                  secondary: p.logoPath == null
                      ? const Icon(Icons.live_tv)
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: CachedNetworkImage(
                            imageUrl:
                                '${ApiConstants.tmdbImageBaseUrl}/w92${p.logoPath}',
                            width: 36,
                            height: 36,
                          ),
                        ),
                ),
              const SizedBox(height: 8),
              const Text(
                'Anbieterdaten: JustWatch über TMDB.',
                style: TextStyle(color: AppColors.neutralGray, fontSize: 12),
              ),
            ],
          );
        },
      ),
    );
  }
}
