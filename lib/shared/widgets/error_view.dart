import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../../core/errors/app_exception.dart';
import '../../core/errors/user_facing_error.dart';
import '../../core/health/service_health.dart';
import '../../l10n/l10n.dart';
import 'status_view.dart';

export '../../core/errors/user_facing_error.dart' show describeError;

/// What the person can do about a failure.
enum Remedy {
  /// Try the same thing again.
  retry,

  /// Set up or fix movie information (TMDB).
  configureMetadata,

  /// Connect this device to the server again.
  reconnectServer,
}

/// A failure, described for people: what kind it is, a title, one
/// sentence, and what helps. [technical] keeps the raw text for "Details"
/// and diagnostics; it is never shown first.
class StatusDescriptor {
  const StatusDescriptor({
    required this.kind,
    required this.title,
    this.message,
    this.remedy = Remedy.retry,
    this.technical,
  });

  final StatusKind kind;
  final String title;
  final String? message;
  final Remedy remedy;
  final String? technical;
}

/// Turns any error into a [StatusDescriptor]. Known causes get their own
/// words; only truly unknown errors are "unexpected".
StatusDescriptor classifyError(Object error) => switch (error) {
  ServiceNotConfiguredException(service: ExternalService.tmdb) =>
    const StatusDescriptor(
      kind: StatusKind.notConfigured,
      title: 'Filminfos sind noch nicht eingerichtet',
      message:
          'Speednema nutzt TMDB für Titel, Poster und Beschreibungen. '
          'Deine Sammlung funktioniert auch ohne.',
      remedy: Remedy.configureMetadata,
    ),
  ServiceCredentialsInvalidException(service: ExternalService.tmdb) =>
    const StatusDescriptor(
      kind: StatusKind.notConfigured,
      title: 'TMDB hat den Schlüssel abgelehnt',
      message:
          'Ohne gültigen Schlüssel gibt es keine Filminfos. '
          'Deine Sammlung bleibt unverändert.',
      remedy: Remedy.configureMetadata,
    ),
  ServiceNotConfiguredException() ||
  ServiceCredentialsInvalidException() => StatusDescriptor(
    kind: StatusKind.notConfigured,
    title: 'Dieser Dienst ist nicht eingerichtet',
    message: (error as AppException).message,
  ),
  NoInternetException() => const StatusDescriptor(
    kind: StatusKind.noNetwork,
    title: 'Keine Internetverbindung',
    message: 'Was in deinem Regal ist, siehst du weiterhin.',
  ),
  RateLimitException() => const StatusDescriptor(
    kind: StatusKind.serviceUnavailable,
    title: 'Gerade zu viele Anfragen',
    message: 'Versuche es in einer Minute noch einmal.',
  ),
  ApiUnavailableException() => const StatusDescriptor(
    kind: StatusKind.serviceUnavailable,
    title: 'Der Dienst antwortet gerade nicht',
    message: 'Das liegt nicht an dir. Versuche es später noch einmal.',
  ),
  ServerUnreachableException() => const StatusDescriptor(
    kind: StatusKind.serviceUnavailable,
    title: 'Server nicht erreichbar',
    message:
        'Prüfe, ob dein Speednema Server läuft und ihr im selben Netzwerk '
        'seid. Deine Sammlung auf diesem Gerät bleibt verfügbar.',
  ),
  ServerRevokedException() => const StatusDescriptor(
    kind: StatusKind.authRequired,
    title: 'Dein Server kennt dieses Gerät nicht mehr',
    message: 'Verbinde es noch einmal, dann geht es weiter wie vorher.',
    remedy: Remedy.reconnectServer,
  ),
  // The server's own text is English and technical; keep it for Details.
  ServerRejectedException() => StatusDescriptor(
    kind: StatusKind.unexpected,
    title: 'Der Server hat das nicht angenommen',
    message:
        'Versuche es noch einmal. Hilft das nicht, sieh im Dashboard nach.',
    technical: (error as AppException).message,
  ),
  CloudUnreachableException() => const StatusDescriptor(
    kind: StatusKind.serviceUnavailable,
    title: 'Speednema Cloud ist gerade nicht erreichbar',
    message:
        'Deine Änderungen bleiben auf dem Gerät und werden später übertragen.',
  ),
  UnknownAppException() => StatusDescriptor(
    kind: StatusKind.unexpected,
    title: 'Das hat nicht geklappt',
    message: 'Versuche es bitte noch einmal.',
    technical: error.toString(),
  ),
  AppException(:final message) => StatusDescriptor(
    kind: StatusKind.unexpected,
    title: 'Das hat nicht geklappt',
    message: message,
  ),
  UserFacingError(:final message) => StatusDescriptor(
    kind: StatusKind.unexpected,
    title: 'Das hat nicht geklappt',
    message: message,
  ),
  _ => StatusDescriptor(
    kind: StatusKind.unexpected,
    title: 'Das hat nicht geklappt',
    message: 'Versuche es bitte noch einmal.',
    technical: error.toString(),
  ),
};

/// Shows why something could not be loaded and what helps, using
/// [classifyError]. Retry appears only when [onRetry] is given; setup and
/// reconnect lead to the right screen.
class ErrorView extends StatelessWidget {
  const ErrorView({super.key, required this.error, this.onRetry})
    : compact = false;

  /// For a failed section inside a longer page.
  const ErrorView.compact({super.key, required this.error, this.onRetry})
    : compact = true;

  final Object error;
  final VoidCallback? onRetry;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final status = classifyError(error);
    final router = GoRouter.maybeOf(context);

    final remedy = switch (status.remedy) {
      Remedy.retry =>
        onRetry == null
            ? null
            : StatusAction(context.l10n.actionRetry, onRetry!),
      Remedy.configureMetadata =>
        router == null
            ? null
            : StatusAction(
                'Filminfos einrichten',
                () => router.push('/settings/metadata'),
              ),
      Remedy.reconnectServer =>
        router == null
            ? null
            : StatusAction(
                'Neu verbinden',
                () => router.push('/server/connect'),
              ),
    };
    StatusAction? secondary;
    if (status.technical != null) {
      secondary = StatusAction(
        'Details',
        () => _showDetails(context, status.technical!),
      );
    } else if (status.remedy != Remedy.retry && onRetry != null) {
      secondary = StatusAction(context.l10n.actionRetry, onRetry!);
    }
    return compact
        ? StatusView.compact(
            kind: status.kind,
            title: status.title,
            message: status.message,
            primary: remedy,
            secondary: secondary,
          )
        : StatusView(
            kind: status.kind,
            title: status.title,
            message: status.message,
            primary: remedy,
            secondary: secondary,
          );
  }

  static void _showDetails(BuildContext context, String technical) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Technische Details'),
        content: SelectableText(technical),
        actions: [
          TextButton(
            onPressed: () => Clipboard.setData(ClipboardData(text: technical)),
            child: const Text('Kopieren'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }
}
