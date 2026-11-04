import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Keeps feature code on the design system: colours come from
/// `context.colors`, sizes from the text theme, so both appearances and
/// large text keep working. See lib/app/theme/.
void main() {
  final sources = <String, String>{
    for (final dir in ['lib/features', 'lib/shared', 'lib/app'])
      for (final f in Directory(dir).listSync(recursive: true))
        if (f is File &&
            f.path.endsWith('.dart') &&
            !f.path.replaceAll(r'\', '/').contains('lib/app/theme/'))
          f.path.replaceAll(r'\', '/'): f.readAsStringSync(),
  };

  List<String> offending(RegExp pattern, {Set<String> allowed = const {}}) => [
    for (final MapEntry(key: path, value: text) in sources.entries)
      if (!allowed.contains(path))
        for (final m in pattern.allMatches(text))
          '$path:${text.substring(0, m.start).split('\n').length}: ${m[0]}',
  ];

  test('no fixed colours in feature code', () {
    // Colors.black is true black behind video and camera, correct in both
    // appearances; transparent is not a colour.
    final fixed = offending(
      RegExp(
        r'\bColor\(0x[0-9A-Fa-f]+\)|\bColors\.(?!black\b|transparent\b)\w+',
      ),
      allowed: {
        // QR codes need a white quiet zone to scan, whatever the theme.
        'lib/features/television/presentation/tv_connect_screen.dart',
      },
    );
    expect(fixed, isEmpty, reason: 'Use context.colors.*\n${fixed.join('\n')}');
  });

  test('no palette constants outside the theme', () {
    final palette = offending(
      RegExp(r'\b(AppColors|DarkTokens|LightTokens)\.'),
    );
    expect(palette, isEmpty, reason: palette.join('\n'));
  });

  // Fixed font sizes ignore the type scale. Budgets only go down: when a
  // screen is redesigned, lower or remove its entry.
  const fontSizeBudget = {
    'lib/features/collections/presentation/collection_detail_screen.dart': 1,
    'lib/features/collections/presentation/collections_screen.dart': 1,
    'lib/features/collections/presentation/franchise_section.dart': 2,
    'lib/features/collections/presentation/missing_movies_screen.dart': 1,
    'lib/features/editions/presentation/known_editions_section.dart': 1,
    'lib/features/import/presentation/import_movie_search_screen.dart': 1,
    'lib/features/playback/presentation/subtitle_sheets.dart': 1,
    'lib/features/remote/presentation/remote_screen.dart': 1,
    'lib/features/server/presentation/connect_screen.dart': 1,
    'lib/features/server/presentation/server_screen.dart': 1,
    'lib/features/server/presentation/server_title_screen.dart': 2,
    'lib/features/server/presentation/title_card.dart': 2,
    'lib/features/settings/presentation/language_screen.dart': 1,
    'lib/features/settings/presentation/settings_screen.dart': 1,
    'lib/features/television/presentation/tv_browse_screens.dart': 1,
    'lib/features/television/presentation/tv_focusable.dart': 1,
    'lib/features/television/presentation/tv_profiles_screen.dart': 4,
    'lib/features/television/presentation/tv_settings_screen.dart': 1,
    'lib/features/television/presentation/tv_shell.dart': 2,
    'lib/features/watch/presentation/subscriptions_screen.dart': 1,
    'lib/features/watch/presentation/where_to_watch_section.dart': 1,
    'lib/shared/widgets/collection_completeness_view.dart': 1,
  };

  test('fixed font sizes only shrink', () {
    final over = <String>[];
    for (final MapEntry(key: path, value: text) in sources.entries) {
      final count = RegExp(r'\bfontSize:').allMatches(text).length;
      final budget = fontSizeBudget[path] ?? 0;
      if (count > budget) {
        over.add('$path: $count fixed font sizes, budget $budget');
      }
    }
    expect(
      over,
      isEmpty,
      reason: 'Use a Theme.of(context).textTheme role.\n${over.join('\n')}',
    );
  });
}
