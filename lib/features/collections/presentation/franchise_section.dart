import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_colors.dart';
import '../../../core/providers/repository_providers.dart';
import '../../../shared/models/collection_status.dart';
import '../../../shared/widgets/action_button.dart';
import '../../../shared/widgets/poster_image.dart';
import '../../../shared/widgets/status_chip.dart';
import '../application/collections_providers.dart';
import '../domain/movie_collection_info.dart';

class FranchiseSection extends ConsumerWidget {
  const FranchiseSection({
    super.key,
    required this.tmdbMovieId,
    this.pendingConfirmation = false,
    this.onCommitScanned,
  });

  final int tmdbMovieId;
  final bool pendingConfirmation;
  final Future<void> Function(CollectionStatus status)? onCommitScanned;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final franchise = ref.watch(franchiseProvider(tmdbMovieId));
    return franchise.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: LinearProgressIndicator(),
      ),
      error: (error, stack) => const SizedBox.shrink(),
      data: (info) {
        if (info == null || info.parts.isEmpty) return const SizedBox.shrink();
        return FranchiseCard(
          info: info,
          pendingConfirmation: pendingConfirmation,
          onCommitScanned: onCommitScanned,
        );
      },
    );
  }
}

class FranchiseCard extends ConsumerStatefulWidget {
  const FranchiseCard({
    super.key,
    required this.info,
    this.pendingConfirmation = false,
    this.onCommitScanned,
  });

  final MovieCollectionInfo info;
  final bool pendingConfirmation;
  final Future<void> Function(CollectionStatus status)? onCommitScanned;

  @override
  ConsumerState<FranchiseCard> createState() => _FranchiseCardState();
}

class _FranchiseCardState extends ConsumerState<FranchiseCard> {
  final _draft = <int, CollectionStatus>{};
  bool _saving = false;

  @override
  void didUpdateWidget(FranchiseCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    _draft.removeWhere((id, status) {
      for (final part in widget.info.parts) {
        if (part.tmdbMovieId == id) return _stored(part) == status;
      }
      return true;
    });
  }

  bool get _dirty => _draft.isNotEmpty;

  bool get _needsScanCommit {
    final commit = widget.onCommitScanned;
    if (commit == null) return false;
    for (final part in widget.info.parts) {
      if (part.isCurrent && part.localMovieId == null) return true;
    }
    return false;
  }

  bool get _canSave => !_saving && (_dirty || _needsScanCommit);

  MovieCollectionInfo get _preview => widget.info.withStatuses(_draft);

  @override
  Widget build(BuildContext context) {
    final info = widget.info;
    final preview = _preview;
    final bucket = preview.bucketLabel;
    return PopScope(
      canPop: !_dirty,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop || !_dirty) return;
        final discard = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Änderungen verwerfen?'),
            content: const Text(
              'Die Statusänderungen sind noch nicht gespeichert.',
            ),
            actions: [
              TextButton(
                key: const Key('franchise-discard-cancel'),
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('Abbrechen'),
              ),
              TextButton(
                key: const Key('franchise-discard-confirm'),
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Verwerfen'),
              ),
            ],
          ),
        );
        if (discard != true || !mounted) return;
        setState(_draft.clear);
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) Navigator.of(context).pop();
        });
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Teil einer Filmreihe',
                    style: TextStyle(
                      color: AppColors.neutralGray,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    info.name,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    preview.progressLabel,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  if (bucket != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      bucket,
                      style: TextStyle(
                        color: preview.ownedCount == preview.totalCount
                            ? AppColors.sage
                            : AppColors.neutralGray,
                      ),
                    ),
                  ],
                  const SizedBox(height: 12),
                  for (var index = 0; index < info.parts.length; index++)
                    _FranchiseRow(
                      index: index + 1,
                      part: info.parts[index],
                      status:
                          _draft[info.parts[index].tmdbMovieId] ??
                          _stored(info.parts[index]),
                      pendingConfirmation: widget.pendingConfirmation,
                      enabled: !_saving,
                      onOpen: () => _open(info.parts[index]),
                      onStatus: (status) => _set(info.parts[index], status),
                    ),
                  if (!widget.pendingConfirmation) ...[
                    const SizedBox(height: 12),
                    _saveButton(),
                  ],
                ],
              ),
            ),
          ),
          if (widget.pendingConfirmation) ...[
            const SizedBox(height: 16),
            ActionButton(
              key: const Key('franchise-all-owned'),
              label: 'Alle als gekauft',
              icon: Icons.check_circle_outline,
              color: AppColors.sage,
              onTap: _saving ? () {} : () => _setAll(CollectionStatus.owned),
            ),
            const SizedBox(height: 8),
            ActionButton(
              key: const Key('franchise-all-wishlist'),
              label: 'Alle auf die Wunschliste',
              icon: Icons.favorite_border,
              color: AppColors.dustyRose,
              onTap: _saving
                  ? () {}
                  : () => _setAll(CollectionStatus.wishlist),
            ),
            const SizedBox(height: 8),
            ActionButton(
              key: const Key('franchise-all-open'),
              label: 'Alle als offen',
              icon: Icons.hourglass_bottom,
              color: AppColors.amber,
              onTap: _saving ? () {} : () => _setAll(CollectionStatus.open),
            ),
            const SizedBox(height: 12),
            _saveButton(),
          ],
        ],
      ),
    );
  }

  Widget _saveButton() {
    return SizedBox(
      width: double.infinity,
      child: FilledButton(
        key: const Key('franchise-save'),
        onPressed: _canSave ? _save : null,
        child: const Text('Speichern'),
      ),
    );
  }

  MovieCollectionPart? _currentPart() {
    for (final part in widget.info.parts) {
      if (part.isCurrent) return part;
    }
    return null;
  }

  void _open(MovieCollectionPart part) {
    final localId = part.localMovieId;
    if (localId != null) {
      context.push('/movie/$localId');
      return;
    }
    context.push('/search/add/${part.tmdbMovieId}');
  }

  void _set(MovieCollectionPart part, CollectionStatus status) {
    setState(() {
      if (status == _stored(part)) {
        _draft.remove(part.tmdbMovieId);
      } else {
        _draft[part.tmdbMovieId] = status;
      }
    });
  }

  void _setAll(CollectionStatus status) {
    setState(() {
      for (final part in widget.info.parts) {
        if (status == _stored(part)) {
          _draft.remove(part.tmdbMovieId);
        } else {
          _draft[part.tmdbMovieId] = status;
        }
      }
    });
  }

  Future<void> _save() async {
    final changes = Map<int, CollectionStatus>.of(_draft);
    final commit = widget.onCommitScanned;
    final scanned = _currentPart();
    final commitUnsavedScan =
        commit != null && scanned != null && scanned.localMovieId == null;
    if (changes.isEmpty && !commitUnsavedScan) return;
    final messenger = ScaffoldMessenger.of(context);
    setState(() => _saving = true);
    final movies = ref.read(movieRepositoryProvider);
    try {
      for (final part in widget.info.parts) {
        if (commit != null && part.isCurrent) continue;
        final status = changes[part.tmdbMovieId];
        if (status == null) continue;
        await movies.setCollectionStatus(part.tmdbMovieId, status);
      }
      if (commit != null && scanned != null) {
        final status = changes[scanned.tmdbMovieId] ?? _stored(scanned);
        await commit(status);
      }
      if (!mounted) return;
      setState(() {
        _draft.clear();
        _saving = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      messenger.showSnackBar(
        const SnackBar(content: Text('Das hat leider nicht geklappt.')),
      );
    }
  }
}

CollectionStatus _stored(MovieCollectionPart part) {
  return part.status ?? CollectionStatus.open;
}

class _FranchiseRow extends StatelessWidget {
  const _FranchiseRow({
    required this.index,
    required this.part,
    required this.status,
    required this.pendingConfirmation,
    required this.enabled,
    required this.onOpen,
    required this.onStatus,
  });

  final int index;
  final MovieCollectionPart part;
  final CollectionStatus status;
  final bool pendingConfirmation;
  final bool enabled;
  final VoidCallback onOpen;
  final ValueChanged<CollectionStatus> onStatus;

  @override
  Widget build(BuildContext context) {
    final current = part.isCurrent;
    final scanned = pendingConfirmation && current;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: current
            ? AppColors.dustyRose.withValues(alpha: 0.12)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          child: Row(
            children: [
              SizedBox(
                width: 22,
                child: Text(
                  '$index',
                  style: const TextStyle(color: AppColors.neutralGray),
                ),
              ),
              SizedBox(
                width: 36,
                child: PosterImage(posterPath: part.posterPath, borderRadius: 6),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: InkWell(
                  key: Key('franchise-row-${part.tmdbMovieId}'),
                  onTap: onOpen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        part.title,
                        style: TextStyle(
                          fontWeight: current
                              ? FontWeight.w800
                              : FontWeight.w600,
                        ),
                      ),
                      if (part.year != null)
                        Text(
                          '${part.year}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: AppColors.neutralGray,
                          ),
                        ),
                      if (scanned)
                        const Text(
                          'Aktuell gescannt',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.dustyRose,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              DropdownButton<CollectionStatus>(
                key: Key('franchise-status-${part.tmdbMovieId}'),
                value: status,
                isDense: true,
                alignment: AlignmentDirectional.centerEnd,
                underline: const SizedBox.shrink(),
                borderRadius: BorderRadius.circular(12),
                onChanged: enabled
                    ? (next) {
                        if (next != null) onStatus(next);
                      }
                    : null,
                items: [
                  for (final option in CollectionStatus.values)
                    DropdownMenuItem(
                      key: Key(
                        'franchise-status-${part.tmdbMovieId}-${option.name}',
                      ),
                      value: option,
                      child: Text(option.germanLabel),
                    ),
                ],
                selectedItemBuilder: (context) => [
                  for (final option in CollectionStatus.values)
                    Text(
                      option.germanLabel,
                      style: TextStyle(
                        color: _statusColor(option),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Color _statusColor(CollectionStatus status) => colorForStatus(status);
