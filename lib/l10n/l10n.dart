import 'package:flutter/widgets.dart';

import 'app_localizations.dart';

export 'app_localizations.dart';

extension AppLocalizationsX on BuildContext {
  /// The app's strings. Falls back to German where no app localizations are
  /// installed (for example a widget pumped alone in a test), so shared
  /// widgets never fail to build for want of a delegate.
  AppLocalizations get l10n =>
      Localizations.of<AppLocalizations>(this, AppLocalizations) ??
      lookupAppLocalizations(const Locale('de'));
}
