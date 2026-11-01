import 'package:flutter/material.dart';

import '../../shared/models/collection_status.dart';
import 'tokens.g.dart';

/// Speednema's colour roles for the current appearance. Read them with
/// `context.colors`; never use a fixed palette in feature code, or the light
/// appearance breaks.
///
/// One colour, one meaning: [accent] is actions and the wishlist, [owned] is
/// owned and healthy, [attention] is open or needing a look, [error] is only
/// errors.
@immutable
class SpeednemaColors extends ThemeExtension<SpeednemaColors> {
  const SpeednemaColors({
    required this.brightness,
    required this.background,
    required this.surface,
    required this.surfaceRaised,
    required this.text,
    required this.textSecondary,
    required this.hairline,
    required this.outline,
    required this.accent,
    required this.onAccent,
    required this.owned,
    required this.attention,
    required this.error,
    required this.onMedia,
    required this.scrim,
  });

  static const dark = SpeednemaColors(
    brightness: Brightness.dark,
    background: DarkTokens.background,
    surface: DarkTokens.surface,
    surfaceRaised: DarkTokens.surfaceRaised,
    text: DarkTokens.text,
    textSecondary: DarkTokens.textSecondary,
    hairline: DarkTokens.hairline,
    outline: DarkTokens.outline,
    accent: DarkTokens.accent,
    onAccent: DarkTokens.onAccent,
    owned: DarkTokens.owned,
    attention: DarkTokens.attention,
    error: DarkTokens.error,
    onMedia: DarkTokens.onMedia,
    scrim: DarkTokens.scrim,
  );

  static const light = SpeednemaColors(
    brightness: Brightness.light,
    background: LightTokens.background,
    surface: LightTokens.surface,
    surfaceRaised: LightTokens.surfaceRaised,
    text: LightTokens.text,
    textSecondary: LightTokens.textSecondary,
    hairline: LightTokens.hairline,
    outline: LightTokens.outline,
    accent: LightTokens.accent,
    onAccent: LightTokens.onAccent,
    owned: LightTokens.owned,
    attention: LightTokens.attention,
    error: LightTokens.error,
    onMedia: LightTokens.onMedia,
    scrim: LightTokens.scrim,
  );

  final Brightness brightness;

  /// Page background.
  final Color background;

  /// Grouped content, sheets, inputs.
  final Color surface;

  /// The one featured surface on a screen; menus.
  final Color surfaceRaised;

  /// Primary text and icons.
  final Color text;

  /// Metadata, captions, inactive icons.
  final Color textSecondary;

  /// Decorative separators only.
  final Color hairline;

  /// Input borders and focus rings (at least 3:1 against surfaces).
  final Color outline;

  /// Primary actions, selection, focus; the wishlist.
  final Color accent;

  /// Text and icons on [accent].
  final Color onAccent;

  /// Owned, available, healthy.
  final Color owned;

  /// Open, uncertain, needs attention.
  final Color attention;

  /// Errors only.
  final Color error;

  /// Text and icons drawn over artwork or video, in both appearances.
  final Color onMedia;

  /// Darkening over artwork or video for legibility.
  final Color scrim;

  /// The status colour of a title. Always pair it with an icon or label.
  Color forStatus(CollectionStatus status) => switch (status) {
    CollectionStatus.owned => owned,
    CollectionStatus.wishlist => accent,
    CollectionStatus.open => attention,
  };

  /// A quiet fill for chips and badges in [color] (16 % on dark, 12 % on
  /// light, where tints read stronger).
  Color tint(Color color) =>
      color.withValues(alpha: brightness == Brightness.dark ? 0.16 : 0.12);

  @override
  SpeednemaColors copyWith({Color? accent}) => SpeednemaColors(
    brightness: brightness,
    background: background,
    surface: surface,
    surfaceRaised: surfaceRaised,
    text: text,
    textSecondary: textSecondary,
    hairline: hairline,
    outline: outline,
    accent: accent ?? this.accent,
    onAccent: onAccent,
    owned: owned,
    attention: attention,
    error: error,
    onMedia: onMedia,
    scrim: scrim,
  );

  @override
  SpeednemaColors lerp(SpeednemaColors? other, double t) {
    if (other == null) return this;
    Color mix(Color a, Color b) => Color.lerp(a, b, t)!;
    return SpeednemaColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      background: mix(background, other.background),
      surface: mix(surface, other.surface),
      surfaceRaised: mix(surfaceRaised, other.surfaceRaised),
      text: mix(text, other.text),
      textSecondary: mix(textSecondary, other.textSecondary),
      hairline: mix(hairline, other.hairline),
      outline: mix(outline, other.outline),
      accent: mix(accent, other.accent),
      onAccent: mix(onAccent, other.onAccent),
      owned: mix(owned, other.owned),
      attention: mix(attention, other.attention),
      error: mix(error, other.error),
      onMedia: mix(onMedia, other.onMedia),
      scrim: mix(scrim, other.scrim),
    );
  }
}

extension SpeednemaColorsX on BuildContext {
  /// Colour roles for the current appearance. Falls back to the dark palette
  /// where no Speednema theme is installed (a widget pumped alone in a test).
  SpeednemaColors get colors =>
      Theme.of(this).extension<SpeednemaColors>() ??
      (Theme.of(this).brightness == Brightness.light
          ? SpeednemaColors.light
          : SpeednemaColors.dark);
}
