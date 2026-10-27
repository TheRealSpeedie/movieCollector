/// Physical or digital release format of an edition.
enum MediaFormat {
  uhd4k,
  bluray3d,
  bluray,
  dvd,
  vhs,
  digital,
  unknown;

  String get label => switch (this) {
    MediaFormat.uhd4k => '4K UHD',
    MediaFormat.bluray3d => 'Blu-ray 3D',
    MediaFormat.bluray => 'Blu-ray',
    MediaFormat.dvd => 'DVD',
    MediaFormat.vhs => 'VHS',
    MediaFormat.digital => 'Digital',
    MediaFormat.unknown => 'Unbekanntes Format',
  };

  /// Picture quality order used to tell upgrades from downgrades.
  int get rank => switch (this) {
    MediaFormat.uhd4k => 5,
    MediaFormat.bluray3d => 4,
    MediaFormat.bluray => 4,
    MediaFormat.digital => 2,
    MediaFormat.dvd => 2,
    MediaFormat.vhs => 1,
    MediaFormat.unknown => 0,
  };

  bool get isPhysical => this != MediaFormat.digital;

  static MediaFormat fromName(String? name) => MediaFormat.values.firstWhere(
    (f) => f.name == name,
    orElse: () => MediaFormat.unknown,
  );

  /// Reads format names from barcode databases and user input,
  /// such as "Blu-ray", "4K Ultra HD + Blu-ray" or "DVD-Video".
  static MediaFormat parse(String? text) {
    if (text == null) return MediaFormat.unknown;
    final value = text.toLowerCase();
    if (MediaFormat.values.any((f) => f.name == value)) {
      return fromName(value);
    }
    if (value.contains('4k') ||
        value.contains('uhd') ||
        value.contains('ultra hd')) {
      return MediaFormat.uhd4k;
    }
    if (value.contains('3d') && value.contains('blu')) {
      return MediaFormat.bluray3d;
    }
    if (value.contains('blu') || value.contains('bd')) {
      return MediaFormat.bluray;
    }
    if (value.contains('dvd')) return MediaFormat.dvd;
    if (value.contains('vhs')) return MediaFormat.vhs;
    if (value.contains('digital') || value.contains('stream')) {
      return MediaFormat.digital;
    }
    return MediaFormat.unknown;
  }
}
