import 'package:flutter/foundation.dart';

/// Whether the first-run flow is done. The router redirects to onboarding
/// until it is; main() sets the initial value from the saved settings.
final onboardingGate = ValueNotifier<bool>(true);
