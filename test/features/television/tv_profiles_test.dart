import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:movie_shelf/app/theme/app_theme.dart';
import 'package:movie_shelf/features/server/application/server_providers.dart';
import 'package:movie_shelf/features/server/data/profile_api.dart';
import 'package:movie_shelf/features/server/data/server_client.dart';
import 'package:movie_shelf/features/server/data/server_credentials.dart';
import 'package:movie_shelf/features/television/presentation/tv_shell.dart';

import '../server/support/fakes.dart';

void main() {
  test('switching profile keeps the server and replaces the user', () async {
    final requests = <String>[];
    final client = ServerClient(
      credentials: sampleCredentials(),
      store: MemoryStore(),
      discovery: FakeDiscovery(),
      onRevoked: () {},
      dio: fakeDio((options) {
        requests.add('${options.method} ${options.path}');
        if (options.path.endsWith('/api/auth/refresh')) {
          return jsonBody({
            'accessToken': 'a',
            'expiresIn': 600,
            'refreshToken': 'r2',
          });
        }
        if (options.path.endsWith('/api/profiles')) {
          return jsonBody([
            {'id': 1, 'name': 'owner', 'hasPin': false, 'current': true},
            {'id': 2, 'name': 'kid', 'hasPin': true, 'maxAgeRating': 12},
          ]);
        }
        expect((options.data as Map)['pin'], '1234');
        return jsonBody({
          'accessToken': 'b',
          'expiresIn': 600,
          'refreshToken': 'kid-refresh',
          'userId': 2,
          'username': 'kid',
          'role': 'User',
        });
      }),
    );
    final api = ProfileApi(client);

    final profiles = await api.profiles();
    expect(profiles.last.hasPin, isTrue);
    expect(profiles.last.maxAgeRating, 12);

    final switched = await api.switchTo(2, pin: '1234');
    expect(switched.username, 'kid');
    expect(switched.userId, 2);
    expect(switched.refreshToken, 'kid-refresh');
    expect(switched.serverId, sampleCredentials().serverId);
    expect(
      requests.last,
      'POST ${sampleCredentials().baseUrl}/api/profiles/2/switch',
    );
  });

  testWidgets('the TV menu leads to every area', (tester) async {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              TvShell(location: state.matchedLocation, child: child),
          routes: [
            for (final section in tvSections)
              GoRoute(
                path: section.path,
                builder: (context, state) => Text('Seite ${section.path}'),
              ),
          ],
        ),
      ],
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [serverSessionProvider.overrideWith(() => _Session())],
        child: MaterialApp.router(theme: AppTheme.dark, routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('owner'), findsOneWidget);

    for (final section in tvSections) {
      await tester.tap(find.text(section.label));
      await tester.pumpAndSettle();
      expect(find.text('Seite ${section.path}'), findsOneWidget);
    }
  });
}

class _Session extends ServerSession {
  @override
  Future<ServerCredentials?> build() async => sampleCredentials();
}
