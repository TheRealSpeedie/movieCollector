import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:speednema/app/theme/app_theme.dart';
import 'package:speednema/l10n/app_localizations.dart';

/// Screen sizes every redesigned screen is checked at (logical pixels).
enum GoldenDevice {
  phone(Size(390, 844)),
  tablet(Size(1024, 1366)),
  desktop(Size(1280, 800));

  const GoldenDevice(this.size);

  final Size size;
}

bool _fontsLoaded = false;

/// Loads Roboto and Material Icons from the Flutter SDK so goldens show real
/// text instead of the test font's boxes. Returns false when the SDK fonts
/// cannot be found; callers skip the golden then.
Future<bool> loadAppFonts() async {
  if (_fontsLoaded) return true;
  final root = Platform.environment['FLUTTER_ROOT'];
  if (root == null) return false;
  final dir = Directory('$root/bin/cache/artifacts/material_fonts');
  if (!dir.existsSync()) return false;

  Future<ByteData> read(String name) async {
    final bytes = await File('${dir.path}/$name').readAsBytes();
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }

  final roboto = FontLoader('Roboto');
  for (final weight in [
    'thin',
    'light',
    'regular',
    'medium',
    'bold',
    'black',
    'italic',
  ]) {
    final file = 'roboto-$weight.ttf';
    if (File('${dir.path}/$file').existsSync()) roboto.addFont(read(file));
  }
  await roboto.load();
  final icons = FontLoader('MaterialIcons')
    ..addFont(read('materialicons-regular.otf'));
  await icons.load();
  _fontsLoaded = true;
  return true;
}

/// Pumps [child] the way the app shows it: app theme, German strings,
/// Riverpod [overrides], at [device] size and [textScale].
Future<void> pumpScreen(
  WidgetTester tester,
  Widget child, {
  GoldenDevice device = GoldenDevice.phone,
  double textScale = 1.0,
  List<Override> overrides = const [],
  Brightness brightness = Brightness.dark,
}) async {
  tester.view
    ..physicalSize = device.size
    ..devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(
    ProviderScope(
      overrides: overrides,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: brightness == Brightness.dark ? AppTheme.dark : AppTheme.light,
        locale: const Locale('de'),
        supportedLocales: AppLocalizations.supportedLocales,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        builder: (context, app) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(textScale)),
          child: app!,
        ),
        home: child,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Renders [child] in both appearances, at every device and text scale, and
/// compares each image with `goldens/<name>_<appearance>_<device>_<scale>x.png`.
///
/// Goldens are reviewed by eye before they are accepted. Regenerate with
/// `flutter test --tags golden --update-goldens`. Font rendering differs a
/// little between operating systems, so compare on the platform that made
/// them.
void screenGoldens(
  String name,
  Widget Function() child, {
  List<Override> Function()? overrides,
  List<GoldenDevice> devices = const [GoldenDevice.phone, GoldenDevice.tablet],
  List<double> textScales = const [1.0, 2.0],
  List<Brightness> appearances = const [Brightness.dark, Brightness.light],
}) {
  for (final appearance in appearances) {
    for (final device in devices) {
      for (final scale in textScales) {
        testWidgets(
          '$name, ${appearance.name}, on ${device.name} at ${scale}x text',
          (tester) async {
            // Real file reads never finish inside the test's fake clock.
            final loaded = await tester.runAsync(loadAppFonts) ?? false;
            if (!loaded) {
              markTestSkipped('Flutter SDK fonts not found; golden skipped.');
              return;
            }
            await pumpScreen(
              tester,
              child(),
              device: device,
              textScale: scale,
              overrides: overrides?.call() ?? const [],
              brightness: appearance,
            );
            await expectLater(
              find.byType(MaterialApp),
              matchesGoldenFile(
                'goldens/${name}_${appearance.name}_${device.name}_${scale.toStringAsFixed(0)}x.png',
              ),
            );
          },
          tags: ['golden'],
        );
      }
    }
  }
}
