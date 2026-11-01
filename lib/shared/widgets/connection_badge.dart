import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
import '../../app/theme/tokens.g.dart';

/// How a connection is doing, in the words the app and the dashboard share.
enum ConnectionTone {
  /// Works.
  ok,

  /// Connecting or syncing right now.
  busy,

  /// Works partly, or needs the user (sign in again, update).
  attention,

  /// Not reachable. Local data stays available.
  offline,

  /// Nothing set up. Neutral, not a problem.
  none;

  IconData get icon => switch (this) {
    ok => Icons.check_circle,
    busy => Icons.sync,
    attention => Icons.error_outline,
    offline => Icons.cloud_off_outlined,
    none => Icons.radio_button_unchecked,
  };

  Color color(SpeednemaColors c) => switch (this) {
    ok => c.owned,
    busy => c.accent,
    attention => c.attention,
    offline => c.textSecondary,
    none => c.textSecondary,
  };
}

/// A connection state as an icon plus a word, never colour alone:
/// "Verbunden", "Wird verbunden …", "Offline".
class ConnectionBadge extends StatelessWidget {
  const ConnectionBadge({super.key, required this.tone, required this.label});

  final ConnectionTone tone;
  final String label;

  @override
  Widget build(BuildContext context) {
    final color = tone.color(context.colors);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (tone == ConnectionTone.busy &&
            !MediaQuery.disableAnimationsOf(context))
          SizedBox.square(
            dimension: 14,
            child: CircularProgressIndicator(strokeWidth: 2, color: color),
          )
        else
          Icon(tone.icon, size: 16, color: color),
        const SizedBox(width: AppSpacing.xs + 2),
        Flexible(
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: tone == ConnectionTone.none ? null : color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
