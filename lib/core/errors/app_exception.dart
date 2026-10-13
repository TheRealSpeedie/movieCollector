sealed class AppException implements Exception {
  const AppException(this.message);

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
        'Der Movie-Shelf-Server ist nicht erreichbar. Prüfe, ob er läuft und ihr im selben WLAN seid.',
      );
}

class ServerRevokedException extends AppException {
  const ServerRevokedException()
    : super(
        'Dieses Gerät wurde vom Server getrennt. Verbinde es erneut mit einem QR-Code.',
      );
}

class ServerRejectedException extends AppException {
  const ServerRejectedException(super.message, this.statusCode);

  final int statusCode;
}

class PairingFailedException extends AppException {
  const PairingFailedException(super.message);
}
