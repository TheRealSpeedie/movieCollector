import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_typography.dart';
import 'speednema_colors.dart';
import 'tokens.g.dart';

/// Material themes for both appearances, built from the same tokens.
/// The phone app follows the system appearance; the TV app is dark only.
class AppTheme {
  AppTheme._();

  static ThemeData get dark => build(SpeednemaColors.dark);
  static ThemeData get light => build(SpeednemaColors.light);

  static ThemeData build(SpeednemaColors c) {
    final isDark = c.brightness == Brightness.dark;
    // Explicit surfaces: a seeded scheme would tint menus, sheets and bars
    // with the accent.
    final scheme = ColorScheme(
      brightness: c.brightness,
      primary: c.accent,
      onPrimary: c.onAccent,
      primaryContainer: c.tint(c.accent),
      onPrimaryContainer: c.text,
      secondary: c.owned,
      onSecondary: c.onAccent,
      secondaryContainer: c.tint(c.owned),
      onSecondaryContainer: c.text,
      tertiary: c.attention,
      onTertiary: c.onAccent,
      error: c.error,
      onError: isDark ? c.background : c.onMedia,
      errorContainer: c.tint(c.error),
      onErrorContainer: c.text,
      surface: c.surface,
      onSurface: c.text,
      onSurfaceVariant: c.textSecondary,
      surfaceContainerLowest: c.background,
      surfaceContainerLow: c.surface,
      surfaceContainer: c.surface,
      surfaceContainerHigh: c.surfaceRaised,
      surfaceContainerHighest: c.surfaceRaised,
      outline: c.outline,
      outlineVariant: c.hairline,
      shadow: const Color(0xFF000000),
      scrim: c.scrim,
      inverseSurface: c.text,
      onInverseSurface: c.background,
      inversePrimary: c.accent,
      surfaceTint: Colors.transparent,
    );

    final control = BorderRadius.circular(AppRadii.control);
    const buttonPadding = EdgeInsets.symmetric(
      horizontal: AppSpacing.xl - 4,
      vertical: AppSpacing.m + 2,
    );
    final text = AppTypography.textTheme(
      text: c.text,
      secondary: c.textSecondary,
    );
    // Component styles replace the theme's text style instead of merging,
    // so each starts from a scale role that carries the font family.
    final buttonText = text.labelLarge;
    const minTarget = Size(48, 48);

    return ThemeData(
      useMaterial3: true,
      brightness: c.brightness,
      colorScheme: scheme,
      extensions: [c],
      scaffoldBackgroundColor: c.background,
      canvasColor: c.background,
      fontFamily: AppTypography.fontFamily,
      textTheme: text,
      iconTheme: IconThemeData(color: c.text),
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        surfaceTintColor: Colors.transparent,
        systemOverlayStyle: isDark
            ? SystemUiOverlayStyle.light
            : SystemUiOverlayStyle.dark,
      ),
      cardTheme: CardThemeData(
        color: c.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.card),
          side: BorderSide(color: c.hairline),
        ),
      ),
      listTileTheme: ListTileThemeData(
        iconColor: c.textSecondary,
        textColor: c.text,
        subtitleTextStyle: text.bodyMedium?.copyWith(color: c.textSecondary),
        minVerticalPadding: AppSpacing.m,
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.surface,
        selectedColor: c.tint(c.accent),
        side: BorderSide(color: c.hairline),
        labelStyle: text.labelLarge?.copyWith(fontWeight: FontWeight.w500),
        shape: const StadiumBorder(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.s + 2,
          vertical: AppSpacing.xs,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: c.onAccent,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: control),
          textStyle: buttonText,
          minimumSize: minTarget,
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: c.onAccent,
          padding: buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: control),
          textStyle: buttonText,
          minimumSize: minTarget,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: c.text,
          side: BorderSide(color: c.outline),
          padding: buttonPadding,
          shape: RoundedRectangleBorder(borderRadius: control),
          textStyle: buttonText,
          minimumSize: minTarget,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: c.accent,
          textStyle: buttonText,
          minimumSize: minTarget,
        ),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          side: BorderSide(color: c.outline),
          selectedBackgroundColor: c.tint(c.accent),
          selectedForegroundColor: c.text,
          minimumSize: const Size(0, 44),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.l,
          vertical: AppSpacing.m + 2,
        ),
        hintStyle: text.bodyLarge?.copyWith(color: c.textSecondary),
        border: OutlineInputBorder(
          borderRadius: control,
          borderSide: BorderSide(color: c.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: control,
          borderSide: BorderSide(color: c.outline),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: control,
          borderSide: BorderSide(color: c.accent, width: 2),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.tint(c.accent),
        surfaceTintColor: Colors.transparent,
        iconTheme: WidgetStateProperty.resolveWith(
          (states) => IconThemeData(
            color: states.contains(WidgetState.selected)
                ? c.text
                : c.textSecondary,
          ),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (states) => text.labelMedium?.copyWith(
            fontWeight: states.contains(WidgetState.selected)
                ? FontWeight.w600
                : FontWeight.w500,
            color: states.contains(WidgetState.selected)
                ? c.text
                : c.textSecondary,
          ),
        ),
      ),
      navigationRailTheme: NavigationRailThemeData(
        backgroundColor: c.surface,
        indicatorColor: c.tint(c.accent),
        selectedIconTheme: IconThemeData(color: c.text),
        unselectedIconTheme: IconThemeData(color: c.textSecondary),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: c.accent,
        linearTrackColor: c.hairline,
        circularTrackColor: Colors.transparent,
      ),
      dividerTheme: DividerThemeData(color: c.hairline, thickness: 1),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: c.surfaceRaised,
        contentTextStyle: text.bodyMedium,
        actionTextColor: c.accent,
        behavior: SnackBarBehavior.floating,
        elevation: isDark ? 0 : 3,
        shape: RoundedRectangleBorder(borderRadius: control),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadii.sheet),
        ),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: c.surface,
        surfaceTintColor: Colors.transparent,
        showDragHandle: true,
        dragHandleColor: c.outline,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadii.sheet),
          ),
        ),
      ),
      popupMenuTheme: PopupMenuThemeData(
        color: c.surfaceRaised,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: control),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.onAccent : c.outline,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.accent : c.surface,
        ),
        trackOutlineColor: WidgetStateProperty.resolveWith(
          (s) => s.contains(WidgetState.selected) ? c.accent : c.outline,
        ),
      ),
    );
  }
}
