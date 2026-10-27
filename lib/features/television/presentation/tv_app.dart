import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../../playback/domain/play_request.dart';
import '../../playback/presentation/player_screen.dart';
import '../../remote/application/remote_providers.dart';
import '../../remote/domain/remote_models.dart';
import '../../server/application/server_providers.dart';
import 'tv_browse_screens.dart';
import 'tv_connect_screen.dart';
import 'tv_home_screen.dart';
import 'tv_profiles_screen.dart';
import 'tv_settings_screen.dart';
import 'tv_shell.dart';
import 'tv_title_screen.dart';

final tvRouterProvider = Provider<GoRouter>((ref) {
  final changes = ValueNotifier(0);
  ref.listen(serverSessionProvider, (_, _) => changes.value++);
  ref.onDispose(changes.dispose);
  return GoRouter(
    initialLocation: '/splash',
    refreshListenable: changes,
    redirect: (context, state) {
      final session = ref.read(serverSessionProvider);
      final location = state.matchedLocation;
      if (session.isLoading) return '/splash';
      if (session.valueOrNull == null) {
        return location == '/connect' ? null : '/connect';
      }
      return location == '/splash' || location == '/connect' ? '/home' : null;
    },
    routes: [
      GoRoute(
        path: '/splash',
        builder: (context, state) =>
            const Scaffold(body: Center(child: CircularProgressIndicator())),
      ),
      GoRoute(
        path: '/connect',
        builder: (context, state) => const TvConnectScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) =>
            TvShell(location: state.matchedLocation, child: child),
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => const TvHomeScreen(),
          ),
          GoRoute(
            path: '/movies',
            builder: (context, state) => const TvLibraryScreen(kind: 'Movie'),
          ),
          GoRoute(
            path: '/series',
            builder: (context, state) => const TvLibraryScreen(kind: 'Series'),
          ),
          GoRoute(
            path: '/continue',
            builder: (context, state) => const TvContinueScreen(),
          ),
          GoRoute(
            path: '/search',
            builder: (context, state) => const TvSearchScreen(),
          ),
          GoRoute(
            path: '/profiles',
            builder: (context, state) => const TvProfilesScreen(),
          ),
          GoRoute(
            path: '/settings',
            builder: (context, state) => const TvSettingsScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/title/:id',
        builder: (context, state) =>
            TvTitleScreen(titleId: int.parse(state.pathParameters['id']!)),
      ),
      GoRoute(
        path: '/play',
        builder: (context, state) =>
            PlayerScreen(request: state.extra! as PlayRequest),
      ),
    ],
  );
});

final tvHostProvider = Provider<void>((ref) {
  final connection = ref.watch(controlConnectionProvider);
  if (connection.hasError) {
    final retry = Timer(
      const Duration(seconds: 10),
      () => ref.invalidate(controlConnectionProvider),
    );
    ref.onDispose(retry.cancel);
    return;
  }
  final hub = connection.valueOrNull;
  if (hub == null) return;

  final router = ref.read(tvRouterProvider);
  hub.registerPlayer(tvDeviceName).catchError((_) {});

  final commands = hub.commands.listen((command) async {
    final bridge = ref.read(playerBridgeProvider);
    switch (command.command) {
      case 'play':
        await bridge?.play();
      case 'pause':
        await bridge?.pause();
      case 'seek':
        await bridge?.seek(command.seconds ?? 0);
      case 'stop':
        bridge?.stop();
      case 'open':
        router.go('/home');
        router.push('/title/${command.titleId}');
    }
  });
  final reports = Timer.periodic(const Duration(seconds: 2), (_) {
    final snapshot =
        ref.read(playerBridgeProvider)?.snapshot() ?? const PlayerSnapshot();
    hub.reportState(snapshot).catchError((_) {});
  });
  ref.onDispose(() {
    commands.cancel();
    reports.cancel();
  });
});

class TvApp extends ConsumerWidget {
  const TvApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(tvHostProvider);
    return MaterialApp.router(
      title: 'Movie Shelf',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: ref.watch(tvRouterProvider),
      locale: const Locale('de', 'DE'),
      supportedLocales: const [Locale('de', 'DE'), Locale('en', 'US')],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(1.25)),
        child: child!,
      ),
    );
  }
}
