import 'app_exception.dart';

/// An error whose [message] is written for people: plain German, says what
/// happened and what to do. Anything else is a programming or platform error
/// whose text must not reach the screen.
abstract interface class UserFacingError {
  String get message;
}

/// Text that is safe to show for [error]. Never returns raw exception text;
/// unknown errors get a generic sentence (details belong in logs).
String describeError(Object error) {
  if (error is UserFacingError) return error.message;
  if (error is AppException) return error.message;
  return 'Das hat nicht geklappt. Versuche es bitte noch einmal.';
}
