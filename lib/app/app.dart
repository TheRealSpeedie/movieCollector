import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/constants/app_constants.dart';
import '../l10n/app_localizations.dart';
import '../features/playback/application/preferences_upload.dart';
import '../features/scanner/application/scan_providers.dart';
import '../features/sync/application/sync_providers.dart';
import 'router.dart';
import 'theme/app_theme.dart';

class SpeednemaApp extends ConsumerWidget {
  const SpeednemaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(syncSchedulerProvider);
    ref.watch(pendingScanDrainProvider);
    ref.watch(preferencesUploadProvider);
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
      routerConfig: appRouter,
      locale: const Locale('de', 'DE'),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
    );
  }
}
