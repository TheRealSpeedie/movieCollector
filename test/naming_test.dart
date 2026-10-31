import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// The product is called Speednema. Old names (Movie Shelf, Movie Collector)
/// must not come back in code, platform metadata or docs.
///
/// A match is allowed only where the text around it says why: code that reads
/// files from before the rename mentions "legacy" or "rename" next to it.
/// "Movie collector box" is a generic product term, not the old brand.
void main() {
  final oldName = RegExp(
    r'movie[\s_\-]*shelf|movie[\s_\-]*collector(?![\s_\-]*box)',
    caseSensitive: false,
  );
  final explained = RegExp(r'legacy|rename', caseSensitive: false);

  const roots = ['lib', 'docs', 'android/app/src', 'ios/Runner'];
  const singleFiles = ['README.md', 'pubspec.yaml', 'env.example.json'];
  const extensions = {
    '.dart', '.md', '.kt', '.kts', '.xml', '.plist', '.json', '.yaml', '.swift',
  };

  Iterable<File> sources() sync* {
    for (final root in roots) {
      final dir = Directory(root);
      if (!dir.existsSync()) continue;
      for (final entity in dir.listSync(recursive: true)) {
        if (entity is File &&
            extensions.any((e) => entity.path.endsWith(e)) &&
            !entity.path.endsWith('.g.dart')) {
          yield entity;
        }
      }
    }
    for (final path in singleFiles) {
      final file = File(path);
      if (file.existsSync()) yield file;
    }
  }

  test('no old product names outside documented legacy handling', () {
    final offences = <String>[];
    for (final file in sources()) {
      // Collapse whitespace so a name broken across lines is still found.
      final text = file.readAsStringSync().replaceAll(RegExp(r'\s+'), ' ');
      for (final match in oldName.allMatches(text)) {
        final from = (match.start - 120).clamp(0, text.length);
        final to = (match.end + 120).clamp(0, text.length);
        if (explained.hasMatch(text.substring(from, to))) continue;
        offences.add('${file.path}: …${text.substring(from, to)}…');
      }
    }
    expect(offences, isEmpty, reason: offences.join('\n\n'));
  });
}
