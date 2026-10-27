import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/collection/presentation/collection_screen.dart';
import '../features/collections/presentation/collection_detail_screen.dart';
import '../features/collections/presentation/collections_screen.dart';
import '../features/collections/presentation/missing_movies_screen.dart';
import '../features/discover/domain/watch_suggestions.dart';
import '../features/discover/presentation/discover_screen.dart';
import '../features/discover/presentation/what_to_watch_screen.dart';
import '../features/watch/presentation/subscriptions_screen.dart';
import '../features/home/presentation/home_screen.dart';
import '../features/import/application/import_movie_search_controller.dart';
import '../features/import/presentation/import_movie_search_screen.dart';
import '../features/import/presentation/import_screen.dart';
import '../features/import/presentation/import_selection_screen.dart';
import '../features/movie_details/presentation/movie_details_screen.dart';
import '../features/onboarding/application/onboarding_gate.dart';
import '../features/onboarding/presentation/onboarding_screen.dart';
import '../features/playback/domain/play_request.dart';
import '../features/playback/presentation/player_screen.dart';
import '../features/remote/presentation/remote_screen.dart';
import '../features/scanner/domain/barcode_search_context.dart';
import '../features/scanner/presentation/fundstueck_result_screen.dart';
import '../features/scanner/presentation/scanner_screen.dart';
import '../features/search/presentation/add_movie_screen.dart';
import '../features/search/presentation/movie_search_screen.dart';
import '../features/server/presentation/connect_screen.dart';
import '../features/server/presentation/pair_scan_screen.dart';
import '../features/server/presentation/server_screen.dart';
import '../features/server/presentation/server_title_screen.dart';
import '../features/server/presentation/tv_approve_screen.dart';
import '../features/settings/presentation/more_screen.dart';
import '../features/sync/presentation/sync_screen.dart';
import '../features/settings/presentation/settings_screen.dart';
import '../features/tv/presentation/tv_series_details_screen.dart';
import 'app_shell.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: '/home',
  refreshListenable: onboardingGate,
  redirect: (context, state) {
    final onboarding = state.matchedLocation == '/onboarding';
    // Server pairing is reachable from inside onboarding.
    if (!onboardingGate.value &&
        !onboarding &&
        !state.matchedLocation.startsWith('/server')) {
      return '/onboarding';
    }
    return null;
  },
  routes: [
    GoRoute(
      path: '/onboarding',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const OnboardingScreen(),
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          AppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/collection',
              builder: (context, state) => const CollectionScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/discover',
              builder: (context, state) => const DiscoverScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/scanner',
              builder: (context, state) => const ScannerScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/more',
              builder: (context, state) => const MoreScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/movie/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          MovieDetailsScreen(movieId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/search',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final scan = BarcodeSearchContext.fromQuery(state.uri.queryParameters);
        return MovieSearchScreen(scan: scan);
      },
    ),
    GoRoute(
      path: '/search/add/:tmdbId',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => AddMovieScreen(
        tmdbId: int.parse(state.pathParameters['tmdbId']!),
        scan: BarcodeSearchContext.fromQuery(state.uri.queryParameters),
      ),
    ),
    GoRoute(
      path: '/fundstueck/result',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const FundstueckResultScreen(),
    ),
    GoRoute(
      path: '/collections',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const CollectionsScreen(),
    ),
    GoRoute(
      path: '/discover/watch',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final sources = state.uri.queryParameters['sources'];
        return WhatToWatchScreen(
          initialSources: sources == null
              ? null
              : {
                  for (final name in sources.split(','))
                    SuggestionSource.values.byName(name),
                },
        );
      },
    ),
    GoRoute(
      path: '/settings/streaming',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SubscriptionsScreen(),
    ),
    GoRoute(
      path: '/sync',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SyncScreen(),
    ),
    GoRoute(
      path: '/collections/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => CollectionDetailScreen(
        collectionId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/missing',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const MissingMoviesScreen(),
    ),
    GoRoute(
      path: '/import',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ImportScreen(),
    ),
    GoRoute(
      path: '/import/movie-search/:index',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => ImportMovieSearchScreen(
        rowIndex: int.parse(state.pathParameters['index']!),
        initialMedia: state.uri.queryParameters['media'] == 'tv'
            ? ImportSearchMedia.tv
            : ImportSearchMedia.movie,
      ),
    ),
    GoRoute(
      path: '/import/selection/:index',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) {
        final query = state.uri.queryParameters;
        return ImportSelectionScreen(
          rowIndex: int.parse(state.pathParameters['index']!),
          tmdbSeriesId: int.tryParse(query['seriesId'] ?? ''),
          tmdbCollectionId: int.tryParse(query['collectionId'] ?? ''),
          closeSearchOnConfirm: query['closeSearch'] == '1',
        );
      },
    ),
    GoRoute(
      path: '/series/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => TvSeriesDetailsScreen(
        seriesId: int.parse(state.pathParameters['id']!),
      ),
    ),
    GoRoute(
      path: '/settings',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SettingsScreen(),
    ),
    GoRoute(
      path: '/server',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ServerScreen(),
    ),
    GoRoute(
      path: '/server/connect',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const ConnectScreen(),
    ),
    GoRoute(
      path: '/server/tv',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const TvApproveScreen(),
    ),
    GoRoute(
      path: '/server/sync',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const SyncScreen(),
    ),
    GoRoute(
      path: '/remote',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const RemoteScreen(),
    ),
    GoRoute(
      path: '/server/scan',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) => const PairScanScreen(),
    ),
    GoRoute(
      path: '/server/title/:id',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          ServerTitleScreen(titleId: int.parse(state.pathParameters['id']!)),
    ),
    GoRoute(
      path: '/play',
      parentNavigatorKey: rootNavigatorKey,
      builder: (context, state) =>
          PlayerScreen(request: state.extra! as PlayRequest),
    ),
  ],
);
