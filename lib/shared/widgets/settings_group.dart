import 'package:flutter/material.dart';

import '../../app/theme/speednema_colors.dart';
import '../../app/theme/tokens.g.dart';

/// Related settings as one rounded group with hairline separators and an
/// optional explanation underneath, instead of a card per row.
class SettingsGroup extends StatelessWidget {
  const SettingsGroup({
    super.key,
    this.title,
    this.footer,
    required this.children,
  });

  final String? title;

  /// One or two sentences explaining the group.
  final String? footer;
  final List<Widget> children;

  /// Widest a group gets on large screens.
  static const maxWidth = 720.0;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    // Settings read best at a comfortable width; on tablets and desktop
    // windows the groups stay centred instead of stretching.
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: SettingsGroup.maxWidth),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.l,
            vertical: AppSpacing.s,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (title != null)
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: AppSpacing.l,
                    bottom: AppSpacing.s,
                  ),
                  child: Semantics(
                    header: true,
                    child: Text(
                      title!,
                      style: text.labelLarge?.copyWith(
                        color: colors.textSecondary,
                      ),
                    ),
                  ),
                ),
              // A Material, not a decorated box, so row ripples stay visible.
              Material(
                color: colors.surface,
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadii.card),
                  side: BorderSide(color: colors.hairline),
                ),
                child: Column(
                  children: [
                    for (var i = 0; i < children.length; i++) ...[
                      if (i > 0)
                        const Divider(height: 1, indent: AppSpacing.l + 40),
                      children[i],
                    ],
                  ],
                ),
              ),
              if (footer != null)
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(
                    AppSpacing.l,
                    AppSpacing.s,
                    AppSpacing.l,
                    0,
                  ),
                  child: Text(footer!, style: text.bodySmall),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// One row in a [SettingsGroup]: opens a screen, shows a value, toggles,
/// or performs a destructive action.
class SettingsTile extends StatelessWidget {
  /// Opens another screen; shows a chevron and an optional current [value].
  const SettingsTile.navigation({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.value,
    required VoidCallback this.onTap,
  }) : toggle = null,
       onToggle = null,
       destructive = false;

  /// Switches something on or off. The whole row is the target.
  const SettingsTile.toggle({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required bool this.toggle,
    required ValueChanged<bool> this.onToggle,
  }) : value = null,
       onTap = null,
       destructive = false;

  /// Shows a read-only value.
  const SettingsTile.info({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required this.value,
  }) : onTap = null,
       toggle = null,
       onToggle = null,
       destructive = false;

  /// Deletes, leaves or resets. Drawn in the error colour; the caller asks
  /// for confirmation when the action cannot be undone.
  const SettingsTile.destructive({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    required VoidCallback this.onTap,
  }) : value = null,
       toggle = null,
       onToggle = null,
       destructive = true;

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? value;
  final VoidCallback? onTap;
  final bool? toggle;
  final ValueChanged<bool>? onToggle;
  final bool destructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final text = Theme.of(context).textTheme;
    final foreground = destructive ? colors.error : colors.text;

    Widget? trailing;
    if (toggle != null) {
      trailing = Switch(value: toggle!, onChanged: onToggle);
    } else if (onTap != null && !destructive) {
      trailing = Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (value != null)
            Text(
              value!,
              style: text.bodyMedium?.copyWith(color: colors.textSecondary),
            ),
          Icon(Icons.chevron_right, color: colors.textSecondary),
        ],
      );
    } else if (value != null) {
      trailing = Text(
        value!,
        style: text.bodyMedium?.copyWith(color: colors.textSecondary),
      );
    }

    return MergeSemantics(
      child: ListTile(
        minTileHeight: 52,
        leading: Icon(
          icon,
          color: destructive ? colors.error : colors.textSecondary,
        ),
        title: Text(title, style: text.bodyLarge?.copyWith(color: foreground)),
        subtitle: subtitle == null
            ? null
            : Text(
                subtitle!,
                style: text.bodyMedium?.copyWith(color: colors.textSecondary),
              ),
        trailing: trailing,
        onTap: toggle != null ? () => onToggle!(!toggle!) : onTap,
      ),
    );
  }
}
