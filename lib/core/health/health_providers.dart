import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/config_providers.dart';
import '../config/env.dart';
import 'service_health.dart';

/// The current health of each external service. Real requests report
/// their outcome here (see DioClient), so the interface can say "Schlüssel
/// abgelehnt" instead of showing an empty list.
class ServiceHealthNotifier
    extends FamilyNotifier<ServiceHealth, ExternalService> {
  @override
  ServiceHealth build(ExternalService service) {
    final configured = switch (service) {
      ExternalService.tmdb => ref.watch(tmdbConfiguredProvider),
      // The trial endpoint works without a key.
      ExternalService.upcItemDb => true,
      ExternalService.upcmdb => Env.isUpcmdbConfigured,
    };
    return configured ? const HealthUnknown() : const HealthNotConfigured();
  }

  /// Records what a request revealed.
  void report(ServiceHealth health) {
    // Without a key nothing can succeed; a stale success must not win.
    if (state is HealthNotConfigured && health is! HealthNotConfigured) return;
    // Repeated successes carry no news; skip them to avoid rebuilds while
    // someone types a search.
    if (state is HealthOk && health is HealthOk) return;
    state = health;
  }
}

final serviceHealthProvider =
    NotifierProvider.family<
      ServiceHealthNotifier,
      ServiceHealth,
      ExternalService
    >(ServiceHealthNotifier.new);
