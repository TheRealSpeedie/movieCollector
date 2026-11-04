// GENERATED from design/tokens.json (server repository) by scripts/gen-tokens.mjs. Do not edit.

import 'dart:ui';

/// Dark appearance.
abstract final class DarkTokens {
  /// Page background
  static const background = Color(0xFF121418);

  /// Grouped content, sheets, inputs
  static const surface = Color(0xFF1C1F26);

  /// The one featured surface on a screen; menus
  static const surfaceRaised = Color(0xFF252830);

  /// Primary text and icons
  static const text = Color(0xFFE8E4DC);

  /// Metadata, captions, inactive icons
  static const textSecondary = Color(0xFF9AA0A8);

  /// Decorative separators only; never the only edge of a control
  static const hairline = Color(0xFF2A2E38);

  /// Input borders and focus rings (at least 3:1)
  static const outline = Color(0xFF727986);

  /// Primary actions, selection, focus; wishlist
  static const accent = Color(0xFFD4A0B5);

  /// Text and icons on accent
  static const onAccent = Color(0xFF121418);

  /// Owned, available, healthy
  static const owned = Color(0xFF7FA887);

  /// Open, uncertain, needs attention
  static const attention = Color(0xFFD4A05C);

  /// Errors only
  static const error = Color(0xFFD67773);

  /// Text and icons drawn over artwork or video
  static const onMedia = Color(0xFFFFFFFF);

  /// Darkening over artwork or video for legibility
  static const scrim = Color(0x8A000000);
}

/// Light appearance.
abstract final class LightTokens {
  /// Page background
  static const background = Color(0xFFF4F5F7);

  /// Grouped content, sheets, inputs
  static const surface = Color(0xFFFFFFFF);

  /// The one featured surface on a screen; menus (with shadow)
  static const surfaceRaised = Color(0xFFFFFFFF);

  /// Primary text and icons
  static const text = Color(0xFF1B1D22);

  /// Metadata, captions, inactive icons
  static const textSecondary = Color(0xFF5B616B);

  /// Decorative separators only; never the only edge of a control
  static const hairline = Color(0xFFE3E6EA);

  /// Input borders and focus rings (at least 3:1)
  static const outline = Color(0xFF858B95);

  /// Primary actions, selection, focus; wishlist
  static const accent = Color(0xFFA4507A);

  /// Text and icons on accent
  static const onAccent = Color(0xFFFFFFFF);

  /// Owned, available, healthy
  static const owned = Color(0xFF3F7350);

  /// Open, uncertain, needs attention
  static const attention = Color(0xFF8A5D14);

  /// Errors only
  static const error = Color(0xFFB23A36);

  /// Text and icons drawn over artwork or video
  static const onMedia = Color(0xFFFFFFFF);

  /// Darkening over artwork or video for legibility
  static const scrim = Color(0x8A000000);
}

abstract final class AppSpacing {
  static const double xs = 4;
  static const double s = 8;
  static const double m = 12;
  static const double l = 16;
  static const double xl = 24;
  static const double xxl = 32;
  static const double xxxl = 48;
}

abstract final class AppRadii {
  static const double poster = 10;
  static const double control = 14;
  static const double card = 18;
  static const double sheet = 28;
  static const double pill = 999;
}

/// Font size and line height in logical pixels, weight, letter spacing.
abstract final class TypeTokens {
  static const display = (size: 32.0, line: 36.0, weight: 800, tracking: -0.5);
  static const title1 = (size: 24.0, line: 30.0, weight: 700, tracking: -0.2);
  static const title2 = (size: 20.0, line: 26.0, weight: 700, tracking: 0.0);
  static const headline = (size: 17.0, line: 22.0, weight: 600, tracking: 0.0);
  static const body = (size: 16.0, line: 22.0, weight: 400, tracking: 0.0);
  static const callout = (size: 14.0, line: 20.0, weight: 400, tracking: 0.0);
  static const label = (size: 14.0, line: 20.0, weight: 600, tracking: 0.1);
  static const caption = (size: 12.0, line: 16.0, weight: 500, tracking: 0.2);
}

abstract final class AppMotion {
  static const press = Duration(milliseconds: 140);
  static const select = Duration(milliseconds: 180);
  static const enter = Duration(milliseconds: 220);
  static const page = Duration(milliseconds: 280);
}
