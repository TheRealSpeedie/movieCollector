/// German words for errors from the Speednema server and Cloud.
///
/// Servers send a stable `code` next to an English `error` meant for the
/// dashboard and logs. The app shows its own sentence for the code, or one
/// that fits the HTTP status when there is no code, and never the English
/// text (that stays available as details).
String serverErrorText({String? code, required int status}) =>
    _byCode[code] ?? _byStatus(status);

const _byCode = {
  'pin_incorrect': 'Die PIN stimmt nicht.',
  'profile_missing': 'Dieses Profil gibt es nicht mehr.',
  'profile_needs_device': 'Profile wechselst du auf einem verbundenen Gerät.',
  'session_ended': 'Die Wiedergabe wurde beendet. Starte sie noch einmal.',
  'session_missing':
      'Diese Wiedergabe gibt es nicht mehr. Starte sie noch einmal.',
  'file_offline':
      'Die Datei ist gerade nicht erreichbar. Prüfe, ob das Laufwerk am '
      'Server angeschlossen ist.',
  'file_unavailable': 'Die Datei ist gerade nicht verfügbar.',
  'item_unavailable': 'Das ist auf deinem Server gerade nicht verfügbar.',
  'subtitles_unreadable': 'Diese Untertitel können nicht gelesen werden.',
  'server_busy':
      'Dein Server wandelt gerade andere Videos um. Versuche es gleich noch '
      'einmal.',
  'audio_languages_invalid': 'Wähle eine bis fünf Sprachen für den Ton.',
  'device_revoked':
      'Dieses Gerät ist nicht mehr mit dem Server verbunden. Verbinde es '
      'erneut.',
  'sign_in_required': 'Melde dich auf diesem Gerät erneut an.',
  'subscription_ended':
      'Dein Speednema-Cloud-Abo ist abgelaufen. Deine Sammlung bleibt auf '
      'deinen Geräten und kann exportiert werden.',
  'subscription_required': 'KI-Vorschläge gehören zum Speednema-Cloud-Abo.',
};

String _byStatus(int status) => switch (status) {
  403 => 'Dafür fehlt dir auf dem Server die Berechtigung.',
  404 => 'Das gibt es auf dem Server nicht mehr.',
  409 =>
    'Das hat sich inzwischen geändert. Lade neu und versuche es noch einmal.',
  429 => 'Zu viele Versuche. Warte eine Minute und versuche es dann erneut.',
  >= 500 =>
    'Der Server hat gerade ein Problem. Versuche es später noch einmal.',
  _ => 'Der Server hat die Anfrage abgelehnt.',
};
