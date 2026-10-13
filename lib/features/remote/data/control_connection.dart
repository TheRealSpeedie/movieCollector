import 'dart:async';

import 'package:signalr_netcore/signalr_client.dart';

import '../../server/data/server_client.dart';
import '../domain/remote_models.dart';

class ControlConnection {
  ControlConnection(ServerClient client)
    : _hub = HubConnectionBuilder()
          .withUrl(
            client.url('/hubs/control'),
            options: HttpConnectionOptions(
              accessTokenFactory: () async => client.accessToken(),
              transport: HttpTransportType.WebSockets,
            ),
          )
          .withAutomaticReconnect()
          .build() {
    _hub.on('Command', (args) {
      _commands.add(
        RemoteCommand.fromJson(args!.first! as Map<String, dynamic>),
      );
    });
    _hub.on('PlayerState', (args) {
      _states.add(RemotePlayer.fromJson(args!.first! as Map<String, dynamic>));
    });
    _hub.on('PlayerGone', (args) {
      _gone.add(args!.first! as String);
    });
    _hub.onreconnected(({connectionId}) async {
      final name = _playerName;
      if (name != null) await registerPlayer(name);
      _reconnected.add(null);
    });
  }

  final HubConnection _hub;
  final _commands = StreamController<RemoteCommand>.broadcast();
  final _states = StreamController<RemotePlayer>.broadcast();
  final _gone = StreamController<String>.broadcast();
  final _reconnected = StreamController<void>.broadcast();
  String? _playerName;

  Stream<RemoteCommand> get commands => _commands.stream;
  Stream<RemotePlayer> get playerStates => _states.stream;
  Stream<String> get playersGone => _gone.stream;
  Stream<void> get reconnected => _reconnected.stream;

  bool get connected => _hub.state == HubConnectionState.Connected;

  Future<void> start() async {
    await _hub.start();
  }

  Future<void> registerPlayer(String name) async {
    _playerName = name;
    await _hub.invoke('RegisterPlayer', args: [name]);
  }

  Future<void> reportState(PlayerSnapshot snapshot) async {
    if (!connected) return;
    await _hub.invoke('ReportState', args: [snapshot.toJson()]);
  }

  Future<List<RemotePlayer>> players() async {
    final result = await _hub.invoke('GetPlayers') as List;
    return [
      for (final item in result)
        RemotePlayer.fromJson(item as Map<String, dynamic>),
    ];
  }

  Future<void> send(
    String deviceId,
    String command, {
    double? seconds,
    int? titleId,
    int? episodeId,
  }) async {
    await _hub.invoke(
      'SendCommand',
      args: [
        {
          'deviceId': deviceId,
          'command': command,
          'seconds': seconds,
          'titleId': titleId,
          'episodeId': episodeId,
        },
      ],
    );
  }

  Future<void> stop() async {
    await _hub.stop();
    await _commands.close();
    await _states.close();
    await _gone.close();
    await _reconnected.close();
  }
}
