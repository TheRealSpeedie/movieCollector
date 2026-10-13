import '../domain/server_models.dart';
import 'server_client.dart';

class TitleQuery {
  const TitleQuery({this.kind, this.search = '', this.sort = 'name'});

  final String? kind;
  final String search;
  final String sort;

  @override
  bool operator ==(Object other) =>
      other is TitleQuery &&
      other.kind == kind &&
      other.search == search &&
      other.sort == sort;

  @override
  int get hashCode => Object.hash(kind, search, sort);
}

class LibraryRepository {
  LibraryRepository(this._client);

  final ServerClient _client;

  Future<HomeData> home() async =>
      HomeData.fromJson(await _client.get('/api/home') as Map<String, dynamic>);

  Future<TitlePage> titles(
    TitleQuery query, {
    int offset = 0,
    int limit = 60,
  }) async {
    final json =
        await _client.get(
              '/api/titles',
              query: {
                if (query.kind != null) 'kind': query.kind,
                if (query.search.trim().isNotEmpty) 'q': query.search.trim(),
                'sort': query.sort,
                'offset': offset,
                'limit': limit,
              },
            )
            as Map<String, dynamic>;
    return TitlePage(
      total: json['total'] as int,
      items: [
        for (final item in json['items'] as List)
          ServerTitle.fromJson(item as Map<String, dynamic>),
      ],
    );
  }

  Future<TitleDetail> title(int id) async => TitleDetail.fromJson(
    await _client.get('/api/titles/$id') as Map<String, dynamic>,
  );

  Future<List<ServerEpisode>> episodes(int seriesId) async => [
    for (final e in await _client.get('/api/titles/$seriesId/episodes') as List)
      ServerEpisode.fromJson(e as Map<String, dynamic>),
  ];

  Future<void> setWatched({
    required bool watched,
    int? titleId,
    int? episodeId,
  }) {
    final path = episodeId != null
        ? '/api/episodes/$episodeId/watched'
        : '/api/titles/$titleId/watched';
    return watched ? _client.put(path) : _client.delete(path);
  }

  Future<void> setFavorite(int titleId, bool favorite) {
    final path = '/api/titles/$titleId/favorite';
    return favorite ? _client.put(path) : _client.delete(path);
  }

  Future<void> chooseVersion(int titleId, int fileId) =>
      _client.put('/api/titles/$titleId/version', body: {'fileId': fileId});
}
