import 'package:flutter/material.dart';

import 'tokens.g.dart';

/// Speednema's type scale, mapped onto Material's text theme so every
/// `Theme.of(context).textTheme.*` call uses it. Sizes scale with the
/// system text size; feature code picks a role instead of setting sizes.
///
/// | Role      | Material slot                     | Use                         |
/// |-----------|-----------------------------------|-----------------------------|
/// | display   | displaySmall                      | Detail titles, Fundstück    |
/// | title1    | headlineSmall                     | Screen titles               |
/// | title2    | titleLarge                        | Section headers             |
/// | headline  | titleMedium                       | Row and card titles         |
/// | body      | bodyLarge                         | Reading text                |
/// | callout   | bodyMedium                        | Secondary text, subtitles   |
/// | label     | titleSmall, labelLarge            | Buttons, emphasised labels  |
/// | caption   | bodySmall, labelMedium/labelSmall | Metadata, chips (min 12 px) |
abstract final class AppTypography {
  /// Set on every style: a component style without a family does not
  /// inherit the theme's and falls back to the platform default.
  static const fontFamily = 'Roboto';

  static TextStyle _style(
    ({double size, double line, int weight, double tracking}) token,
    Color color,
  ) => TextStyle(
    fontFamily: fontFamily,
    fontSize: token.size,
    height: token.line / token.size,
    fontWeight: FontWeight.values[(token.weight ~/ 100) - 1],
    letterSpacing: token.tracking,
    color: color,
  );

  static TextTheme textTheme({required Color text, required Color secondary}) {
    final display = _style(TypeTokens.display, text);
    return TextTheme(
      displayLarge: display.copyWith(fontSize: 48, height: 52 / 48),
      displayMedium: display.copyWith(fontSize: 40, height: 44 / 40),
      displaySmall: display,
      headlineLarge: _style(TypeTokens.title1, text).copyWith(fontSize: 30),
      headlineMedium: _style(TypeTokens.title1, text).copyWith(fontSize: 27),
      headlineSmall: _style(TypeTokens.title1, text),
      titleLarge: _style(TypeTokens.title2, text),
      titleMedium: _style(TypeTokens.headline, text),
      titleSmall: _style(TypeTokens.label, text),
      bodyLarge: _style(TypeTokens.body, text),
      bodyMedium: _style(TypeTokens.callout, text),
      bodySmall: _style(
        TypeTokens.caption,
        secondary,
      ).copyWith(fontWeight: FontWeight.w400),
      labelLarge: _style(TypeTokens.label, text),
      labelMedium: _style(TypeTokens.caption, text),
      labelSmall: _style(TypeTokens.caption, text),
    );
  }
}
