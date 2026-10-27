import '../../../core/sync/sync_provider.dart';
import 'cloud_client.dart';

/// Collection sync through Movie Shelf Cloud. Same protocol as the home
/// server; only the address and the sign-in differ.
class CloudSyncProvider implements CollectionSyncProvider {
  CloudSyncProvider(this._client);

  final CloudClient _client;

  @override
  String get scope => 'cloud:${_client.baseUrl}/${_client.session?.email}';

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
