/// External services Speednema asks for information. None of them is the
/// source of truth for what the user owns; each only enriches.
enum ExternalService {
  tmdb('Filminfos (TMDB)'),
  upcItemDb('Barcode-Suche (UPCitemdb)'),
  upcmdb('Barcode-Suche (UPCMDB)');

  const ExternalService(this.label);

  /// How the service is named in the interface.
  final String label;
}

/// What Speednema currently knows about a service. Updated from real
/// requests as they happen and from explicit checks, so it never claims
/// more than was observed.
sealed class ServiceHealth {
  const ServiceHealth();
}

/// Set up, but nothing has been asked yet.
final class HealthUnknown extends ServiceHealth {
  const HealthUnknown();
}

/// No key in this build and none entered.
final class HealthNotConfigured extends ServiceHealth {
  const HealthNotConfigured();
}

/// The last request succeeded.
final class HealthOk extends ServiceHealth {
  const HealthOk(this.at);

  final DateTime at;
}

/// The service rejected the key (401 or 403).
final class HealthInvalidCredentials extends ServiceHealth {
  const HealthInvalidCredentials();
}

/// The device has no connection; says nothing about the service itself.
final class HealthOffline extends ServiceHealth {
  const HealthOffline();
}

/// The service did not answer or answered with a server error.
final class HealthUnavailable extends ServiceHealth {
  const HealthUnavailable({this.lastOk});

  final DateTime? lastOk;
}

/// Too many requests; try again later.
final class HealthRateLimited extends ServiceHealth {
  const HealthRateLimited({this.retryAfter});

  final Duration? retryAfter;
}

extension ServiceHealthText on ServiceHealth {
  /// A short status for a settings row.
  String get summary => switch (this) {
    HealthUnknown() => 'Eingerichtet',
    HealthNotConfigured() => 'Nicht eingerichtet',
    HealthOk() => 'Funktioniert',
    HealthInvalidCredentials() => 'Schlüssel abgelehnt',
    HealthOffline() => 'Keine Internetverbindung',
    HealthUnavailable() => 'Antwortet gerade nicht',
    HealthRateLimited() => 'Gerade zu viele Anfragen',
  };

  /// Whether requests can be expected to work.
  bool get isUsable => switch (this) {
    HealthUnknown() || HealthOk() || HealthRateLimited() => true,
    _ => false,
  };
}
