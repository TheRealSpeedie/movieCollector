import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/features/remote/data/control_connection.dart';
import 'package:movie_shelf/features/remote/domain/remote_models.dart';
import 'package:movie_shelf/features/server/data/server_client.dart';
import 'package:movie_shelf/features/server/data/server_credentials.dart';

import 'support.dart';

void main() {
  late Admin admin;
  late ServerClient phone;

  setUpAll(() async {
    if (skipReason != null) return;
    admin = await Admin.login();
    phone = clientFor(await pair(await admin.newLink(), name: 'Phone'));
  });

  Future<ServerCredentials> pairTv() async {
    final service = pairing();
    final tv = await service.startTv(serverUrl!, 'Living room TV');
    await phone.post('/api/pairing/tv-sessions/${tv.shortCode}/approve');
    return (await service.pollTv(tv))!;
  }

  group('television pairing', () {
    test('shows a short code that the phone can look up', () async {
      final tv = await pairing().startTv(serverUrl!, 'Bedroom TV');

      final found =
          await phone.get('/api/pairing/tv-sessions/${tv.shortCode}') as Map;

      expect(tv.shortCode, hasLength(6));
      expect(found['deviceName'], 'Bedroom TV');
      expect(found['fingerprint'], tv.link.fingerprint);
      expect(found['sessionId'], tv.link.sessionId);
    }, skip: skipReason);

    test('keeps waiting until the phone approves', () async {
      final service = pairing();
      final tv = await service.startTv(serverUrl!, 'Waiting TV');

      expect(await service.pollTv(tv), isNull);
    }, skip: skipReason);

    test('delivers working credentials after approval', () async {
      final tv = clientFor(await pairTv());

      final home = await tv.get('/api/home') as Map;

      expect(home, contains('continueWatching'));
    }, skip: skipReason);

    test('approval by the scanned session id works as well', () async {
      final service = pairing();
      final tv = await service.startTv(serverUrl!, 'Scanned TV');

      await phone.post('/api/pairing/tv-sessions/${tv.link.sessionId}/approve');

      expect((await service.pollTv(tv))?.username, 'owner');
    }, skip: skipReason);
  });

  group('phone control', () {
    test('carries phone commands to the television', () async {
      final tvCredentials = await pairTv();
      final tv = ControlConnection(clientFor(tvCredentials));
      final remote = ControlConnection(phone);
      addTearDown(tv.stop);
      addTearDown(remote.stop);
      await tv.start();
      await tv.registerPlayer('Fernseher');
      await remote.start();

      final players = await remote.players();
      expect(players.map((p) => p.deviceId), contains(tvCredentials.deviceId));

      final received = <RemoteCommand>[];
      tv.commands.listen(received.add);
      await remote.send(tvCredentials.deviceId, 'pause');
      await remote.send(tvCredentials.deviceId, 'seek', seconds: 42.5);
      await remote.send(tvCredentials.deviceId, 'open', titleId: 7);
      await Future<void>.delayed(const Duration(milliseconds: 500));

      expect(received.map((c) => c.command), ['pause', 'seek', 'open']);
      expect(received[1].seconds, 42.5);
      expect(received[2].titleId, 7);
    }, skip: skipReason);

    test('shows the television state on the phone', () async {
      final tvCredentials = await pairTv();
      final tv = ControlConnection(clientFor(tvCredentials));
      final remote = ControlConnection(phone);
      addTearDown(tv.stop);
      addTearDown(remote.stop);
      await tv.start();
      await tv.registerPlayer('Fernseher');
      await remote.start();

      final seen = remote.playerStates.firstWhere(
        (p) => p.state.status == 'playing',
      );
      await tv.reportState(
        const PlayerSnapshot(
          titleId: 3,
          title: 'Interstellar',
          positionSeconds: 12,
          durationSeconds: 100,
          playing: true,
          status: 'playing',
        ),
      );
      final player = await seen.timeout(const Duration(seconds: 5));

      expect(player.deviceId, tvCredentials.deviceId);
      expect(player.state.title, 'Interstellar');
      expect(player.state.fraction, closeTo(0.12, 0.001));
      expect(
        (await remote.players())
            .firstWhere((p) => p.deviceId == tvCredentials.deviceId)
            .state
            .positionSeconds,
        12,
      );
    }, skip: skipReason);

    test('rejects commands for unknown players', () async {
      final remote = ControlConnection(phone);
      addTearDown(remote.stop);
      await remote.start();

      await expectLater(
        remote.send('00000000-0000-0000-0000-000000000001', 'pause'),
        throwsA(anything),
      );
    }, skip: skipReason);

    test('drops a revoked television from the player list', () async {
      final tvCredentials = await pairTv();
      final tv = ControlConnection(clientFor(tvCredentials));
      final remote = ControlConnection(phone);
      addTearDown(tv.stop);
      addTearDown(remote.stop);
      await tv.start();
      await tv.registerPlayer('Fernseher');
      await remote.start();

      final gone = remote.playersGone.firstWhere(
        (id) => id == tvCredentials.deviceId,
      );
      await admin.send('DELETE', '/api/devices/${tvCredentials.deviceId}');
      await gone.timeout(const Duration(seconds: 5));

      expect(
        (await remote.players()).map((p) => p.deviceId),
        isNot(contains(tvCredentials.deviceId)),
      );
    }, skip: skipReason);
  });
}
