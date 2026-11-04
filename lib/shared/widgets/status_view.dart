import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
import '../../app/theme/tokens.g.dart';

/// Why a screen or section has nothing to show. Each kind means something
/// different to the user and gets its own look; never show [unexpected]
/// when the cause is known. Loading is not a status: use a skeleton.
enum StatusKind {
  /// Nothing here yet. An invitation, not a problem.
  empty,

  /// A service this needs is not set up (e.g. movie information).
  notConfigured,

  /// The device is offline.
  noNetwork,

  /// A service answered with an error or not at all.
  serviceUnavailable,

  /// Signed out, or the server no longer knows this device.
  authRequired,

  /// The system denied a permission such as the camera.
  permissionDenied,

  /// Some content loaded, some did not.
  partial,

  /// Something failed for a reason the app cannot name.
  unexpected;

  IconData get icon => switch (this) {
    empty => Icons.inbox_outlined,
    notConfigured => Icons.tune,
    noNetwork => Icons.wifi_off_rounded,
    serviceUnavailable => Icons.cloud_off_outlined,
    authRequired => Icons.lock_outline,
    permissionDenied => Icons.block_outlined,
    partial => Icons.info_outline,
    unexpected => Icons.error_outline,
  };

  Color tone(SpeednemaColors c) => switch (this) {
    empty => c.textSecondary,
    notConfigured || permissionDenied || partial || authRequired => c.attention,
    noNetwork || serviceUnavailable => c.textSecondary,
    unexpected => c.error,
  };
}

/// A labelled action for a [StatusView] or [InlineNotice].
class StatusAction {
  const StatusAction(this.label, this.onPressed);

  final String label;
  final VoidCallback onPressed;
}

/// The one way Speednema says why there is nothing to show, and what to do
/// about it: an icon, a short title, one sentence, and up to two actions.
///
/// Full size fills an empty screen; [StatusView.compact] fits inside a
/// section of a longer page.
class StatusView extends StatelessWidget {
  const StatusView({
    super.key,
    required this.kind,
    required this.title,
    this.message,
    this.icon,
    this.primary,
    this.secondary,
  }) : compact = false;

  const StatusView.compact({
    super.key,
    required this.kind,
    required this.title,
    this.message,
    this.icon,
    this.primary,
    this.secondary,
  }) : compact = true;

  final StatusKind kind;
  final String title;
  final String? message;

  /// Overrides the kind's icon, e.g. a film icon for an empty shelf.
  final IconData? icon;
  final StatusAction? primary;
  final StatusAction? secondary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return compact ? _compact(context) : _full(context);
  }

  Widget _full(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ExcludeSemantics(
                child: Icon(
                  icon ?? kind.icon,
                  size: 48,
                  color: kind.tone(colors),
                ),
              ),
              const SizedBox(height: AppSpacing.l),
              Semantics(
                header: true,
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: text.titleLarge,
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: AppSpacing.s),
                Text(
                  message!,
                  textAlign: TextAlign.center,
                  style: text.bodyLarge?.copyWith(color: colors.textSecondary),
                ),
              ],
              if (primary != null) ...[
                const SizedBox(height: AppSpacing.xl),
                FilledButton(
                  onPressed: primary!.onPressed,
                  child: Text(primary!.label),
                ),
              ],
              if (secondary != null) ...[
                const SizedBox(height: AppSpacing.s),
                TextButton(
                  onPressed: secondary!.onPressed,
                  child: Text(secondary!.label),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _compact(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.l,
        vertical: AppSpacing.m,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExcludeSemantics(
            child: Icon(icon ?? kind.icon, size: 24, color: kind.tone(colors)),
          ),
          const SizedBox(width: AppSpacing.m),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: text.titleMedium),
                if (message != null)
                  Text(
                    message!,
                    style: text.bodyMedium?.copyWith(
                      color: colors.textSecondary,
                    ),
                  ),
                if (primary != null || secondary != null)
                  Wrap(
                    spacing: AppSpacing.s,
                    children: [
                      if (primary != null)
                        TextButton(
                          onPressed: primary!.onPressed,
                          child: Text(primary!.label),
                        ),
                      if (secondary != null)
                        TextButton(
                          onPressed: secondary!.onPressed,
                          child: Text(secondary!.label),
                        ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
