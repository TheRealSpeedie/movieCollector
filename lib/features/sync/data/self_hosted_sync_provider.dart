import '../../../core/sync/sync_provider.dart';
import '../../server/data/server_client.dart';

/// Collection sync through the user's own Movie Shelf Server (`/api/sync`).
class SelfHostedSyncProvider implements CollectionSyncProvider {
  SelfHostedSyncProvider(this._client);

  final ServerClient _client;

  @override
  String get scope =>
      'server:${_client.credentials.serverId}/${_client.credentials.username}';

  @override
  Future<List<SyncPushResult>> push(List<SyncChange> changes) async {
    final response =
        await _client.post(
              '/api/sync/push',
              body: {
                'changes': [for (final c in changes) c.toJson()],
              },
            )
            as Map<String, dynamic>;
    return [
      for (final r in response['results'] as List)
        SyncPushResult.fromJson(r as Map<String, dynamic>),
    ];
  }

  @override
  Future<SyncPullPage> pull(int cursor, {int limit = 200}) async =>
      SyncPullPage.fromJson(
        await _client.get(
              '/api/sync/pull',
              query: {'cursor': cursor, 'limit': limit},
            )
            as Map<String, dynamic>,
      );

  @override
  Future<SyncSnapshotInfo> snapshot() async => SyncSnapshotInfo.fromJson(
    await _client.get('/api/sync/snapshot') as Map<String, dynamic>,
  );
}
