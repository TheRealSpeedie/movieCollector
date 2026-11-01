import '../health/service_health.dart';
import 'server_error_text.dart';
import 'user_facing_error.dart';

sealed class AppException implements Exception, UserFacingError {
  const AppException(this.message);

  @override
  final String message;

  @override
  String toString() => message;
}

class NoInternetException extends AppException {
  const NoInternetException() : super('Keine Internetverbindung verfügbar.');
}

class ApiUnavailableException extends AppException {
  const ApiUnavailableException([
    super.message = 'Der Dienst ist derzeit nicht erreichbar.',
  ]);
}

class RateLimitException extends AppException {
  const RateLimitException([
    super.message =
        'Das Anfragelimit wurde erreicht. Bitte später erneut versuchen.',
    this.retryAfter,
  ]);

  final Duration? retryAfter;
}

class BarcodeNotFoundException extends AppException {
  const BarcodeNotFoundException()
    : super('Zu diesem Barcode wurden keine Produktdaten gefunden.');
}

class MovieNotFoundException extends AppException {
  const MovieNotFoundException()
    : super('Es wurde kein passender Film gefunden.');
}

class InvalidApiConfigException extends AppException {
  const InvalidApiConfigException([
    super.message = 'Die API-Konfiguration ist ungültig oder fehlt.',
  ]);
}

/// A service is needed but has no key in this build and none was entered.
/// Thrown before any request is sent.
class ServiceNotConfiguredException extends InvalidApiConfigException {
  const ServiceNotConfiguredException(this.service)
    : super(
        service == ExternalService.tmdb
            ? 'Filminfos sind noch nicht eingerichtet.'
            : 'Dieser Dienst ist noch nicht eingerichtet.',
      );

  final ExternalService service;
}

/// The service rejected the key that was sent (HTTP 401 or 403).
class ServiceCredentialsInvalidException extends InvalidApiConfigException {
  const ServiceCredentialsInvalidException(this.service)
    : super(
        service == ExternalService.tmdb
            ? 'TMDB hat den Schlüssel abgelehnt. Prüfe ihn in den Einstellungen.'
            : 'Der Dienst hat den Schlüssel abgelehnt.',
      );

  final ExternalService service;
}

class DuplicateMovieException extends AppException {
  const DuplicateMovieException()
    : super('Dieser Film befindet sich bereits in deiner Sammlung.');
}

class DuplicateBarcodeException extends AppException {
  const DuplicateBarcodeException()
    : super('Dieser Barcode ist bereits einem Film zugeordnet.');
}

class UnknownAppException extends AppException {
  const UnknownAppException([
    super.message = 'Es ist ein unerwarteter Fehler aufgetreten.',
  ]);
}

class ServerUnreachableException extends AppException {
  const ServerUnreachableException()
    : super(
        'Der Speednema-Server ist nicht erreichbar. Prüfe, ob er läuft und ihr im selben WLAN seid.',
      );
}

class ServerRevokedException extends AppException {
  const ServerRevokedException()
    : super(
        'Dieses Gerät wurde vom Server getrennt. Verbinde es erneut mit einem QR-Code.',
      );
}

class ServerRejectedException extends AppException {
  const ServerRejectedException(
    super.message,
    this.statusCode, {
    this.code,
    this.detail,
  });

  /// From an error response: German words for its [code] or status; the
  /// server's own (English) text is kept as [detail].
  factory ServerRejectedException.fromResponse(int status, Object? data) {
    final code = data is Map && data['code'] is String
        ? data['code'] as String
        : null;
    final detail = data is Map && data['error'] is String
        ? data['error'] as String
        : null;
    return ServerRejectedException(
      serverErrorText(code: code, status: status),
      status,
      code: code,
      detail: detail,
    );
  }

  final int statusCode;

  /// Stable error code from the server, e.g. `pin_incorrect`.
  final String? code;

  /// The server's own text, for details and logs only.
  final String? detail;
}

class PairingFailedException extends AppException {
  const PairingFailedException(super.message);
}

class CloudUnreachableException extends AppException {
  const CloudUnreachableException()
    : super(
        'Speednema Cloud ist gerade nicht erreichbar. Deine Änderungen bleiben auf dem Gerät und werden später übertragen.',
      );
}

/// The Speednema Cloud subscription ended: changes stay on the device until
/// it is renewed. Reading and export keep working.
class CloudSubscriptionException extends AppException {
  const CloudSubscriptionException(super.message);
}
