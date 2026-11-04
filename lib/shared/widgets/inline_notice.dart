import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
import '../../app/theme/tokens.g.dart';
import 'status_view.dart';

/// A one- or two-line note inside a screen, above the content it concerns:
/// "Server nicht erreichbar · Deine Sammlung ist weiter verfügbar". Content
/// stays visible below it; nothing is blocked.
class InlineNotice extends StatelessWidget {
  const InlineNotice({
    super.key,
    required this.kind,
    required this.title,
    this.message,
    this.action,
    this.onDismiss,
  });

  final StatusKind kind;
  final String title;
  final String? message;
  final StatusAction? action;

  /// Shows a close button. Callers remember the dismissal.
  final VoidCallback? onDismiss;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final tone = kind.tone(colors);
    return Semantics(
      container: true,
      liveRegion: true,
      // On the plain surface, so text and the action keep full contrast;
      // the icon and border carry the tone.
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(AppRadii.control),
          border: Border.all(color: tone.withValues(alpha: 0.5)),
        ),
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(
            AppSpacing.m,
            AppSpacing.m,
            AppSpacing.xs,
            AppSpacing.m,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ExcludeSemantics(child: Icon(kind.icon, size: 20, color: tone)),
              const SizedBox(width: AppSpacing.m),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: text.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (message != null)
                      Text(
                        message!,
                        style: text.bodyMedium?.copyWith(
                          color: colors.textSecondary,
                        ),
                      ),
                    if (action != null)
                      Align(
                        alignment: AlignmentDirectional.centerStart,
                        child: TextButton(
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(48, 40),
                          ),
                          onPressed: action!.onPressed,
                          child: Text(action!.label),
                        ),
                      ),
                  ],
                ),
              ),
              if (onDismiss != null)
                IconButton(
                  tooltip: 'Ausblenden',
                  onPressed: onDismiss,
                  icon: const Icon(Icons.close, size: 20),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
