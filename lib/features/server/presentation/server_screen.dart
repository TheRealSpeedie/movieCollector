import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../shared/widgets/empty_state.dart';
import '../../../shared/widgets/error_view.dart';
import '../../../shared/widgets/loading_view.dart';
import '../../playback/domain/play_request.dart';
import '../application/server_providers.dart';
import '../data/library_repository.dart';
import '../domain/server_models.dart';
import 'server_image.dart';
import 'title_card.dart';

class ServerScreen extends ConsumerWidget {
  const ServerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(serverSessionProvider);
    return session.when(
      loading: () => const Scaffold(body: LoadingView()),
      error: (error, _) => Scaffold(body: ErrorView(error: error)),
      data: (credentials) => credentials == null
          ? const _NotConnected()
          : _Connected(serverName: credentials.serverName),
    );
  }
}

class _NotConnected extends ConsumerWidget {
  const _NotConnected();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final revoked = ref.watch(serverRevokedProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Heimserver')),
      body: EmptyState(
        icon: revoked ? Icons.link_off : Icons.dns_outlined,
        title: revoked
            ? 'Dieses Gerät wurde getrennt'
            : 'Kein Server verbunden',
        message: revoked
            ? 'Der Server hat dieses Gerät entfernt. Verbinde es erneut mit einem neuen QR-Code.'
            : 'Verbinde dein Handy mit dem Movie-Shelf-Server, um deine Filme und Serien im Heimnetz zu schauen.',
        action: FilledButton.icon(
          onPressed: () => context.push('/server/connect'),
          icon: const Icon(Icons.qr_code_scanner),
          label: const Text('Server verbinden'),
        ),
      ),
    );
  }
}

class _Connected extends ConsumerWidget {
  const _Connected({required this.serverName});

  final String serverName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(serverName),
          actions: [
            IconButton(
              tooltip: 'Fernbedienung',
              icon: const Icon(Icons.tv),
              onPressed: () => context.push('/remote'),
            ),
            PopupMenuButton<String>(
              onSelected: (value) async {
                if (value == 'tv') {
                  await context.push('/server/tv');
                } else if (value == 'sync') {
                  await context.push('/server/sync');
                } else if (value == 'disconnect') {
                  await _confirmDisconnect(context, ref);
                }
              },
              itemBuilder: (context) => const [
                PopupMenuItem(value: 'tv', child: Text('Fernseher koppeln')),
                PopupMenuItem(value: 'sync', child: Text('Sammlung abgleichen')),
                PopupMenuItem(
                  value: 'disconnect',
                  child: Text('Verbindung trennen'),
                ),
              ],
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Entdecken'),
              Tab(text: 'Bibliothek'),
            ],
          ),
        ),
        body: const TabBarView(children: [_DiscoverTab(), _LibraryTab()]),
      ),
    );
  }

  Future<void> _confirmDisconnect(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Verbindung trennen?'),
        content: const Text(
          'Dieses Gerät wird beim Server abgemeldet. Deine Sammlung auf dem Handy bleibt unverändert.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Trennen'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(serverSessionProvider.notifier).disconnect();
    }
  }
}

class _DiscoverTab extends ConsumerWidget {
  const _DiscoverTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final home = ref.watch(serverHomeProvider);
    return home.when(
      loading: () => const LoadingView(),
      error: (error, _) => ErrorView(
        error: error,
        onRetry: () => ref.invalidate(serverHomeProvider),
      ),
      data: (data) {
        if (data.resume.isEmpty && data.recent.isEmpty) {
          return const EmptyState(
            icon: Icons.video_library_outlined,
            title: 'Noch keine Titel',
            message:
                'Füge im Dashboard einen Medienordner hinzu. Gefundene Filme und Serien erscheinen hier.',
          );
        }
        return RefreshIndicator(
          onRefresh: () async {
            ref.invalidate(serverHomeProvider);
            await ref.read(serverHomeProvider.future);
          },
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              if (data.resume.isNotEmpty) ...[
                Text(
                  'Weiter schauen',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                ResumeRow(items: data.resume),
                const SizedBox(height: 24),
              ],
              if (data.recent.isNotEmpty) ...[
                Text(
                  'Zuletzt hinzugefügt',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: data.recent.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) => SizedBox(
                      width: 120,
                      child: TitleCard(title: data.recent[index]),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class ResumeRow extends StatelessWidget {
  const ResumeRow({super.key, required this.items});

  final List<ResumeItem> items;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => ResumeCard(item: items[index]),
      ),
    );
  }
}

class ResumeCard extends StatelessWidget {
  const ResumeCard({super.key, required this.item});

  final ResumeItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 240,
      child: Card(
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => context.push(
            '/play',
            extra: PlayRequest(
              fileId: item.fileId,
              titleId: item.titleId,
              episodeId: item.episodeId,
              title: item.name,
              subtitle: item.subtitle,
              startSeconds: item.positionSeconds,
            ),
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ServerImage(
                path: item.backdropUrl ?? item.posterUrl,
                aspectRatio: 16 / 9,
                borderRadius: 0,
              ),
              Container(color: Colors.black38),
              const Center(
                child: Icon(
                  Icons.play_circle_outline,
                  size: 44,
                  color: Colors.white,
                ),
              ),
              Positioned(
                left: 12,
                right: 12,
                bottom: item.isNext ? 10 : 14,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      item.isNext
                          ? 'Als Nächstes: ${item.subtitle ?? ''}'
                          : item.subtitle ?? '',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              if (!item.isNext)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: LinearProgressIndicator(
                    value: item.fraction.toDouble(),
                    minHeight: 4,
                    backgroundColor: Colors.black54,
                    color: AppColors.dustyRose,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LibraryTab extends ConsumerStatefulWidget {
  const _LibraryTab();

  @override
  ConsumerState<_LibraryTab> createState() => _LibraryTabState();
}

class _LibraryTabState extends ConsumerState<_LibraryTab>
    with AutomaticKeepAliveClientMixin {
  static const _pageSize = 60;

  final _search = TextEditingController();
  final _scroll = ScrollController();
  final _items = <ServerTitle>[];
  Timer? _debounce;
  String? _kind;
  int _total = 0;
  bool _loading = false;
  Object? _error;
  int _generation = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scroll.addListener(() {
      if (_scroll.position.extentAfter < 400) _load();
    });
    _reload();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _search.dispose();
    _scroll.dispose();
    super.dispose();
  }

  TitleQuery get _query => TitleQuery(kind: _kind, search: _search.text);

  void _reload() {
    _generation++;
    _items.clear();
    _total = 0;
    _error = null;
    _loading = false;
    _load();
  }

  Future<void> _load() async {
    final repository = ref.read(libraryRepositoryProvider);
    if (repository == null ||
        _loading ||
        (_items.isNotEmpty && _items.length >= _total)) {
      return;
    }
    final generation = _generation;
    setState(() => _loading = true);
    try {
      final page = await repository.titles(
        _query,
        offset: _items.length,
        limit: _pageSize,
      );
      if (generation != _generation || !mounted) return;
      setState(() {
        _items.addAll(page.items);
        _total = page.total;
        _loading = false;
      });
    } on Object catch (e) {
      if (generation != _generation || !mounted) return;
      setState(() {
        _error = e;
        _loading = false;
      });
    }
  }

  void _onSearchChanged(String _) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 350), () {
      if (mounted) _reload();
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
          child: TextField(
            controller: _search,
            onChanged: _onSearchChanged,
            textInputAction: TextInputAction.search,
            decoration: const InputDecoration(
              hintText: 'Titel, Genre oder Darsteller suchen',
              prefixIcon: Icon(Icons.search),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: Row(
            children: [
              for (final (label, kind) in const [
                ('Alle', null),
                ('Filme', 'Movie'),
                ('Serien', 'Series'),
              ])
                Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(label),
                    selected: _kind == kind,
                    onSelected: (_) {
                      _kind = kind;
                      _reload();
                    },
                  ),
                ),
            ],
          ),
        ),
        Expanded(child: _body()),
      ],
    );
  }

  Widget _body() {
    if (_error != null && _items.isEmpty) {
      return ErrorView(error: _error!, onRetry: _reload);
    }
    if (_items.isEmpty && _loading) return const LoadingView();
    if (_items.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: _search.text.trim().isEmpty
            ? 'Hier ist noch nichts'
            : 'Nichts gefunden',
        message: _search.text.trim().isEmpty
            ? 'Füge im Dashboard einen Medienordner hinzu.'
            : 'Prüfe die Schreibweise oder wähle einen anderen Filter.',
      );
    }
    return GridView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 130,
        childAspectRatio: 0.52,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) => TitleCard(title: _items[index]),
    );
  }
}
