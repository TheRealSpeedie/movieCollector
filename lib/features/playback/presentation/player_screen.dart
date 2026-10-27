import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:media_kit/media_kit.dart' as mk;
import 'package:media_kit_video/media_kit_video.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/errors/app_exception.dart';
import '../../../shared/widgets/error_view.dart';
import '../../remote/application/remote_providers.dart';
import '../../remote/domain/remote_models.dart';
import '../../server/application/server_providers.dart';
import '../../sync/application/sync_providers.dart';
import '../application/playback_hooks.dart';
import '../../server/data/server_client.dart';
import '../../server/domain/server_models.dart';
import '../data/playback_api.dart';
import '../domain/play_request.dart';
import '../domain/playback_session.dart';
import 'player_controls.dart';
import 'subtitle_sheets.dart';

class PlayerScreen extends ConsumerStatefulWidget {
  const PlayerScreen({super.key, required this.request});

  final PlayRequest request;

  @override
  ConsumerState<PlayerScreen> createState() => _PlayerScreenState();
}

class _PlayerScreenState extends ConsumerState<PlayerScreen> {
  final _player = mk.Player();
  late final _video = VideoController(_player);
  late final ServerClient _client = ref.read(serverClientProvider)!;
  late final _api = PlaybackApi(_client);

  final _subscriptions = <StreamSubscription<Object?>>[];
  Timer? _hideTimer;
  Timer? _progressTimer;
  Timer? _tokenTimer;

  PlaybackSession? _session;
  MediaFileInfo? _file;
  Object? _error;
  bool _loading = true;
  bool _controlsVisible = true;
  bool _playing = false;
  bool _buffering = false;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  double? _dragTarget;
  int? _audioStream;
  int? _requestedHeight;
  double _lastPosition = 0;
  late final _bridge = ref.read(playerBridgeProvider.notifier);
  // Read in initState: ref cannot be used any more when dispose records the
  // viewing.
  Future<void> Function(int tmdbId)? _recordViewingOf;
  Map<String, Object?>? _preferences;
  int? _tmdbId;

  /// The subtitle chosen by the server or the user; re-applied after a
  /// restart (quality or audio change). "none" turns subtitles off.
  String? _subtitleKey;
  bool _tracksChosen = false;
  ExternalSubtitle? _currentExternal;
  double _subtitleDelay = 0;

  /// A film watched to 90 % is recorded as seen in the collection too, so
  /// suggestions and "unwatched" lists agree with the server.
  Future<void> _recordViewing() async {
    final tmdbId = _tmdbId;
    final record = _recordViewingOf;
    if (widget.request.episodeId != null || tmdbId == null || record == null) {
      return;
    }
    if (_totalSeconds <= 0 || _currentSeconds / _totalSeconds < 0.9) return;
    await record(tmdbId);
  }

  @override
  void initState() {
    super.initState();
    _recordViewingOf = ref.read(viewingRecorderProvider);
    _preferences = ref.read(playbackPreferencesProvider);
    // The server film list may still be loading; take the id once it is there.
    ref.listenManual(serverMoviesProvider, (_, next) {
      _tmdbId ??= next.valueOrNull
          ?.where((t) => t.id == widget.request.titleId)
          .firstOrNull
          ?.tmdbId;
    }, fireImmediately: true);
    final bridge = _bridge;
    Future.microtask(
      () => bridge.state = PlayerBridge(
        play: _player.play,
        pause: _player.pause,
        seek: _seekTo,
        stop: _finish,
        snapshot: _snapshot,
      ),
    );
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _subscriptions.addAll([
      _player.stream.position.listen((p) {
        _position = p;
        if (mounted) setState(() {});
      }),
      _player.stream.duration.listen((d) {
        if (mounted) setState(() => _duration = d);
      }),
      _player.stream.playing.listen((p) {
        if (mounted) setState(() => _playing = p);
        if (p) _scheduleHide();
      }),
      _player.stream.buffering.listen((b) {
        if (mounted) setState(() => _buffering = b);
      }),
      _player.stream.completed.listen((done) {
        if (done) _finish();
      }),
      _player.stream.error.listen((message) {
        if (mounted) {
          setState(() => _error = ServerRejectedException(message, 0));
        }
      }),
    ]);
    _begin(widget.request.startSeconds);
  }

  @override
  void dispose() {
    final bridge = _bridge;
    Future.microtask(() => bridge.state = null);
    _hideTimer?.cancel();
    _progressTimer?.cancel();
    _tokenTimer?.cancel();
    for (final s in _subscriptions) {
      s.cancel();
    }
    final session = _session;
    if (session != null) {
      unawaited(_recordViewing().catchError((_) {}));
      unawaited(
        _api
            .stop(
              session.id,
              position: _currentSeconds,
              duration: _totalSeconds,
            )
            .catchError((_) {}),
      );
    }
    _player.dispose();
    SystemChrome.setPreferredOrientations([]);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  double get _currentSeconds =>
      _session?.absolutePosition(_position) ?? _lastPosition;

  double get _totalSeconds {
    final known = _file?.durationSeconds ?? 0;
    if (known > 0) return known;
    return (_session?.offsetSeconds ?? 0) + _duration.inMilliseconds / 1000;
  }

  PlayerSnapshot _snapshot() => PlayerSnapshot(
    titleId: widget.request.titleId,
    episodeId: widget.request.episodeId,
    title: widget.request.title,
    subtitle: widget.request.subtitle,
    positionSeconds: _currentSeconds,
    durationSeconds: _totalSeconds,
    playing: _playing,
    status: _loading || _buffering
        ? 'buffering'
        : _playing
        ? 'playing'
        : 'paused',
  );

  Future<MediaFileInfo> _loadFile() async {
    final repository = ref.read(libraryRepositoryProvider)!;
    final request = widget.request;
    final files = request.episodeId == null
        ? (await repository.title(request.titleId)).files
        : (await repository.episodes(
            request.titleId,
          )).firstWhere((e) => e.id == request.episodeId).files;
    return files.firstWhere((f) => f.id == request.fileId);
  }

  Future<void> _begin(double startSeconds) async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      _file ??= await _loadFile();
      final session = await _api.start(
        fileId: widget.request.fileId,
        startSeconds: startSeconds,
        audioStream: _audioStream,
        requestedHeight: _requestedHeight,
        preferences: _preferences,
      );
      _session = session;
      final headers = await _client.authHeaders();
      await _player.open(
        mk.Media(
          _client.url(session.url),
          httpHeaders: headers,
          start: session.isDirect && startSeconds > 0
              ? Duration(milliseconds: (startSeconds * 1000).round())
              : null,
        ),
      );
      await _applyDelay();
      await _applyTracks(session);
      _startTimers();
      if (mounted) setState(() => _loading = false);
      _scheduleHide();
    } on AppException catch (e) {
      if (mounted) {
        setState(() {
          _error = e;
          _loading = false;
        });
      }
    } on StateError {
      if (mounted) {
        setState(() {
          _error = const ServerRejectedException(
            'Diese Datei ist nicht mehr auf dem Server vorhanden.',
            404,
          );
          _loading = false;
        });
      }
    }
  }

  Future<void> _restart({double? at}) async {
    final session = _session;
    final target = at ?? _currentSeconds;
    _progressTimer?.cancel();
    _lastPosition = target;
    _session = null;
    if (session != null) {
      await _api
          .stop(session.id, position: target, duration: _totalSeconds)
          .catchError((_) {});
    }
    await _begin(target);
  }

  Future<void> _setProperty(String name, String value) async {
    try {
      await (_player.platform as dynamic).setProperty(name, value);
    } on NoSuchMethodError {
      return;
    }
  }

  void _startTimers() {
    _progressTimer?.cancel();
    _progressTimer = Timer.periodic(
      const Duration(seconds: 10),
      (_) => _report(),
    );
    _tokenTimer ??= Timer.periodic(const Duration(minutes: 4), (_) async {
      final token = await _client.accessToken();
      await _setProperty('http-header-fields', 'Authorization: Bearer $token');
    });
  }

  Future<void> _report() async {
    final session = _session;
    if (session == null || _loading) return;
    try {
      await _api.progress(
        session.id,
        position: _currentSeconds,
        duration: _totalSeconds,
        paused: !_playing,
      );
    } on ServerRejectedException catch (e) {
      if ((e.statusCode == 404 || e.statusCode == 409) && mounted) {
        await _player.pause();
        setState(
          () => _error = const ServerRejectedException(
            'Die Wiedergabe wurde vom Server beendet. Starte den Film erneut.',
            409,
          ),
        );
      }
    } on AppException {
      return;
    }
  }

  void _finish() {
    if (mounted) context.pop();
  }

  void _scheduleHide() {
    _hideTimer?.cancel();
    _hideTimer = Timer(const Duration(seconds: 4), () {
      if (mounted && _playing && _dragTarget == null) {
        setState(() => _controlsVisible = false);
      }
    });
  }

  void _toggleControls() {
    setState(() => _controlsVisible = !_controlsVisible);
    if (_controlsVisible) _scheduleHide();
  }

  Future<void> _seekTo(double target) async {
    final session = _session;
    if (session == null) return;
    final clamped = target.clamp(0, _totalSeconds > 0 ? _totalSeconds : target);
    if (session.needsRestartToReach(clamped.toDouble(), _duration)) {
      await _restart(at: clamped.toDouble());
    } else {
      await _player.seek(session.relativeSeek(clamped.toDouble()));
    }
  }

  Future<void> _skip(int seconds) => _seekTo(_currentSeconds + seconds);

  Future<void> _togglePlay() async {
    await _player.playOrPause();
    _scheduleHide();
  }

  Future<void> _chooseTracks() async {
    final session = _session;
    final file = _file;
    if (session == null || file == null) return;
    final choice = await showModalBottomSheet<TrackChoice>(
      context: context,
      isScrollControlled: true,
      builder: (context) => TrackSheet(
        file: file,
        direct: session.isDirect,
        audio: _player.state.tracks.audio
            .where((t) => t.id != 'auto' && t.id != 'no')
            .toList(),
        subtitles: _player.state.tracks.subtitle
            .where((t) => t.id != 'auto' && t.id != 'no')
            .toList(),
        selectedAudio: _player.state.track.audio,
        selectedSubtitle: _player.state.track.subtitle,
        audioStream: _audioStream,
        currentExternal: _currentExternal,
        reason: session.trackReason,
      ),
    );
    if (choice == null) return;
    switch (choice) {
      case EmbeddedAudio(:final track):
        await _player.setAudioTrack(track);
      case EmbeddedSubtitle(:final track):
        _currentExternal = null;
        _subtitleKey = track.id == 'no' ? 'none' : null;
        await _player.setSubtitleTrack(track);
      case ServerAudio(:final stream):
        _audioStream = stream;
        await _restart();
      case ServerSubtitle(:final stream):
        _subtitleKey = stream == null ? 'none' : 's$stream';
        await _applySubtitle(_subtitleKey);
      case ExternalSubtitleChoice(:final subtitle):
        _subtitleKey = 'x${subtitle.id}';
        await _applySubtitle(_subtitleKey);
      case SearchSubtitlesChoice():
        await _searchSubtitles(file);
      case SubtitleDelayChoice():
        if (!mounted) return;
        final delay = await showModalBottomSheet<double>(
          context: context,
          builder: (_) => SubtitleDelaySheet(delay: _subtitleDelay),
        );
        if (delay == null) return;
        _subtitleDelay = delay;
        await _applyDelay();
      case ReportSubtitleChoice(:final subtitle):
        await _api.reportSubtitle(file.id, subtitle.id);
        _file = await _loadFile();
        _subtitleKey = 'none';
        await _applySubtitle(_subtitleKey);
    }
    if (mounted) setState(() {});
  }

  Future<void> _applyDelay() => _setProperty(
    'sub-delay',
    (_subtitleDelay - (_session?.offsetSeconds ?? 0)).toString(),
  );

  /// Applies the server's choice on the first start and the user's choice
  /// after a restart.
  Future<void> _applyTracks(PlaybackSession session) async {
    final file = _file;
    if (file == null) return;
    if (!_tracksChosen) {
      _tracksChosen = true;
      _subtitleKey = session.subtitleKey ?? 'none';
      final audio = session.audioKey;
      if (audio != null && audio.startsWith('s')) {
        final index = int.parse(audio.substring(1));
        if (session.isDirect) {
          final position = file.audioTracks.indexWhere((t) => t.index == index);
          final tracks = await _embedded((t) => t.audio, (t) => t.id);
          if (position >= 0 && position < tracks.length) {
            await _player.setAudioTrack(tracks[position]);
          }
        } else {
          _audioStream = index;
        }
      }
    }
    await _applySubtitle(_subtitleKey);
  }

  /// Waits briefly until the player knows the file's own tracks.
  Future<List<T>> _embedded<T>(
    List<T> Function(mk.Tracks t) pick,
    String Function(T track) id,
  ) async {
    List<T> real(mk.Tracks tracks) =>
        pick(tracks).where((t) => id(t) != 'auto' && id(t) != 'no').toList();

    final tracks = real(_player.state.tracks);
    if (tracks.isNotEmpty) return tracks;
    try {
      return await _player.stream.tracks
          .map(real)
          .firstWhere((list) => list.isNotEmpty)
          .timeout(const Duration(seconds: 3));
    } on TimeoutException {
      return const [];
    }
  }

  Future<void> _applySubtitle(String? key) async {
    final file = _file;
    final session = _session;
    if (file == null || session == null || key == null) return;
    _currentExternal = null;
    if (key == 'none') {
      await _player.setSubtitleTrack(mk.SubtitleTrack.no());
      return;
    }
    final id = int.parse(key.substring(1));
    if (key.startsWith('x')) {
      final subtitle = file.externalSubtitles
          .where((s) => s.id == id)
          .firstOrNull;
      if (subtitle == null) return;
      _currentExternal = subtitle;
      await _player.setSubtitleTrack(
        mk.SubtitleTrack.uri(
          _client.url('/api/files/${file.id}/external-subtitles/$id'),
          title: subtitle.label,
        ),
      );
      return;
    }
    final track = file.subtitleTracks.where((t) => t.index == id).firstOrNull;
    if (track == null) return;
    if (track.text) {
      await _player.setSubtitleTrack(
        mk.SubtitleTrack.uri(
          _client.url('/api/files/${file.id}/subtitles/$id'),
          title: track.label,
        ),
      );
    } else if (session.isDirect) {
      // Picture subtitles only play from the file itself.
      final position = file.subtitleTracks.indexOf(track);
      final tracks = await _embedded((t) => t.subtitle, (t) => t.id);
      if (position < tracks.length) {
        await _player.setSubtitleTrack(tracks[position]);
      }
    }
  }

  Future<void> _searchSubtitles(MediaFileInfo file) async {
    final language =
        (_preferences?['subtitleLanguage'] as String?) ??
        ((_preferences?['audioLanguages'] as List?)?.firstOrNull as String?) ??
        'de';
    final subtitle = await showModalBottomSheet<ExternalSubtitle>(
      context: context,
      isScrollControlled: true,
      builder: (_) =>
          SubtitleSearchSheet(api: _api, fileId: file.id, language: language),
    );
    if (subtitle == null) return;
    _file = await _loadFile();
    _subtitleKey = 'x${subtitle.id}';
    await _applySubtitle(_subtitleKey);
    if (mounted) setState(() {});
  }

  Future<void> _chooseQuality() async {
    final session = _session;
    if (session == null) return;
    final choice = await showModalBottomSheet<QualityChoice>(
      context: context,
      builder: (context) => QualitySheet(
        current: _requestedHeight,
        sourceHeight: _file?.height ?? 0,
        description: session.modeLabel,
        reason: session.reason,
      ),
    );
    if (choice == null || choice.height == _requestedHeight) return;
    _requestedHeight = choice.height;
    await _restart();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent || _error != null) return KeyEventResult.ignored;
    final key = event.logicalKey;
    final action = switch (key) {
      LogicalKeyboardKey.select ||
      LogicalKeyboardKey.enter ||
      LogicalKeyboardKey.space ||
      LogicalKeyboardKey.mediaPlayPause => _togglePlay,
      LogicalKeyboardKey.mediaPlay => _player.play,
      LogicalKeyboardKey.mediaPause => _player.pause,
      LogicalKeyboardKey.arrowLeft ||
      LogicalKeyboardKey.mediaRewind => () => _skip(-10),
      LogicalKeyboardKey.arrowRight ||
      LogicalKeyboardKey.mediaFastForward => () => _skip(10),
      LogicalKeyboardKey.arrowUp => _chooseTracks,
      LogicalKeyboardKey.arrowDown => _chooseQuality,
      _ => null,
    };
    if (action == null) return KeyEventResult.ignored;
    setState(() => _controlsVisible = true);
    _scheduleHide();
    action();
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    final duration = _totalSeconds;
    final current = _dragTarget ?? _currentSeconds;
    return Scaffold(
      backgroundColor: Colors.black,
      body: Focus(
        autofocus: true,
        onKeyEvent: _onKey,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _toggleControls,
          child: Stack(
            fit: StackFit.expand,
            children: [
              Video(
                controller: _video,
                controls: NoVideoControls,
                fit: BoxFit.contain,
              ),
              if (_loading || _buffering)
                const Center(
                  child: CircularProgressIndicator(color: AppColors.dustyRose),
                ),
              if (_error != null) _errorOverlay(),
              if (_controlsVisible && _error == null && !_loading)
                PlayerControls(
                  title: widget.request.title,
                  subtitle: widget.request.subtitle,
                  playing: _playing,
                  current: current,
                  total: duration,
                  modeLabel: _session?.modeLabel ?? '',
                  onBack: context.pop,
                  onPlayPause: _togglePlay,
                  onSkip: _skip,
                  onTracks: _chooseTracks,
                  onQuality: _chooseQuality,
                  onDrag: (v) => setState(() => _dragTarget = v),
                  onDragEnd: (v) async {
                    setState(() => _dragTarget = null);
                    await _seekTo(v);
                    _scheduleHide();
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _errorOverlay() {
    return Container(
      color: AppColors.background,
      child: SafeArea(
        child: Stack(
          children: [
            ErrorView(error: _error!, onRetry: () => _begin(_currentSeconds)),
            Positioned(
              top: 4,
              left: 4,
              child: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: context.pop,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
