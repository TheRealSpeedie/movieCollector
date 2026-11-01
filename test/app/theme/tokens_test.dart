import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/app/theme/speednema_colors.dart';

/// WCAG 2 contrast for every text role against every surface, in both
/// appearances. Text needs 4.5:1; outlines and focus rings need 3:1.
void main() {
  double luminance(Color c) {
    double channel(double v) =>
        v <= 0.03928 ? v / 12.92 : math.pow((v + 0.055) / 1.055, 2.4).toDouble();
    return 0.2126 * channel(c.r) + 0.7152 * channel(c.g) + 0.0722 * channel(c.b);
  }

  double contrast(Color a, Color b) {
    final la = luminance(a), lb = luminance(b);
    return (math.max(la, lb) + 0.05) / (math.min(la, lb) + 0.05);
  }

  for (final palette in [SpeednemaColors.dark, SpeednemaColors.light]) {
    final name = palette.brightness.name;
    final surfaces = {
      'background': palette.background,
      'surface': palette.surface,
      'surfaceRaised': palette.surfaceRaised,
    };
    final textRoles = {
      'text': palette.text,
      'textSecondary': palette.textSecondary,
      'accent': palette.accent,
      'owned': palette.owned,
      'attention': palette.attention,
      'error': palette.error,
    };

    test('$name: every text role reads on every surface (4.5:1)', () {
      final failures = [
        for (final MapEntry(key: role, value: fg) in textRoles.entries)
          for (final MapEntry(key: surface, value: bg) in surfaces.entries)
            if (contrast(fg, bg) < 4.5)
              '$role on $surface: ${contrast(fg, bg).toStringAsFixed(2)}',
      ];
      expect(failures, isEmpty);
    });

    test('$name: outlines are visible on every surface (3:1)', () {
      for (final MapEntry(key: surface, value: bg) in surfaces.entries) {
        expect(
          contrast(palette.outline, bg),
          greaterThanOrEqualTo(3.0),
          reason: 'outline on $surface',
        );
      }
    });

    test('$name: labels on accent buttons read (4.5:1)', () {
      expect(contrast(palette.onAccent, palette.accent), greaterThanOrEqualTo(4.5));
    });

    test('$name: theme exposes the palette as an extension', () {
      final theme = name == 'dark' ? AppTheme.dark : AppTheme.light;
      expect(theme.extension<SpeednemaColors>(), palette);
      expect(theme.colorScheme.primary, palette.accent);
      expect(theme.scaffoldBackgroundColor, palette.background);
    });
  }

  test('no text style in the scale is smaller than 12', () {
    final text = AppTheme.light.textTheme;
    for (final style in [
      text.bodySmall,
      text.labelSmall,
      text.labelMedium,
      text.bodyMedium,
    ]) {
      expect(style!.fontSize, greaterThanOrEqualTo(12));
    }
  });
}
