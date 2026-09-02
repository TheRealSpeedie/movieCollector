# Troubleshooting

## TMDB 401 / "Die API-Konfiguration ist ungültig oder fehlt"

TMDB returned HTTP 401 or 403, mapped to `InvalidApiConfigException`. Causes:

- You didn't pass `--dart-define-from-file=env.json` when running/building. Without it,
  `TMDB_ACCESS_TOKEN` is empty and every TMDB request is unauthenticated.
- You used the short **API Key (v3 auth)** instead of the **API Read Access Token**. Movie
  Shelf sends `Authorization: Bearer <token>` — it needs the long JWT-style Read Access
  Token from <https://www.themoviedb.org/settings/api>, not the v3 `api_key`.
- `env.json` has a typo in the key name — it must be exactly `TMDB_ACCESS_TOKEN` (see
  `env.example.json`).

Check the Settings screen's "API-Status" section — it shows whether TMDB is seen as
configured at all (this only checks that a non-empty token was compiled in, not that it's
valid).

## "Invalid token" / requests silently fail in release builds

Make sure you pass the same `--dart-define-from-file=env.json` flag to `flutter build` that
you use for `flutter run` — dart-defines are not persisted between commands and must be
supplied every time.

## Scanner permission denied

The scanner screen explains why camera access is needed and offers a "Berechtigung
erteilen" button. If you previously denied it permanently, the button becomes "Einstellungen
öffnen" and opens the OS app-settings page (via `permission_handler`'s `openAppSettings()`)
so you can grant it manually. You can always use "Titel eingeben" / "Stattdessen Titel
eingeben" to search by title instead — the app never requires camera access to be useful.

## Barcode has no result / "Es wurde kein passender Film gefunden"

This means UPCitemdb had no product data for that barcode, or TMDB had no search results for
the extracted product title (`BarcodeNoMatch`). Common with obscure regional releases or
barcodes UPCitemdb simply hasn't indexed. Use "Manuell suchen" / import matching to assign a
film, series, or box set by title — you can still create a barcode mapping later.

## UPC provider rate limit reached

UPCitemdb's free trial tier is rate-limited (limits are controlled by UPCitemdb and can
change). A `429` response shows as "Das Anfragelimit wurde erreicht. Bitte später erneut
versuchen." Wait a while before scanning more unknown barcodes, or configure a paid
UPCitemdb key in `env.json` (`UPCITEMDB_USER_KEY` / `UPCITEMDB_KEY_TYPE`) — see
[docs/APIS.md](APIS.md). This never affects barcodes you've already resolved before; those
always resolve instantly from the local database.

## build_runner problems

```
dart run build_runner build --delete-conflicting-outputs
```

If it fails or hangs:

- Make sure `flutter pub get` succeeded first (mismatched package versions are the most
  common cause of generator failures).
- Delete stale generated output and retry: remove any `*.g.dart`/`*.freezed.dart` files under
  `lib/` and `.dart_tool/build`, then re-run the command.
- If you see conflicts about `riverpod_generator`/`riverpod_annotation`, note this project
  intentionally does **not** use Riverpod code generation (to avoid version conflicts with
  `drift_dev`) — do not add those packages back without also re-checking compatibility with
  the pinned `drift_dev`/`freezed` versions in `pubspec.yaml`.

## Drift generated files missing

Symptoms: compile errors like `undefined_identifier '_$AppDatabase'` or
`undefined_class 'MoviesCompanion'`. This means `app_database.g.dart` hasn't been generated
yet. Run `dart run build_runner build --delete-conflicting-outputs` — Drift's generator reads
the `@DriftDatabase(tables: [...])` annotation in `lib/core/database/app_database.dart` and
produces the missing part file.

## Import save fails with "unerwarteter Fehler" / UNIQUE constraint on genres

This was a real bug: `insertOnConflictUpdate` on `genres` conflicted on the local `id`
instead of `tmdb_id`, so the second movie that shared Action/Komödie/Horror aborted the
whole source row. The matcher had already succeeded; only persistence failed.

Current builds upsert genres (and TMDB collections) on their TMDB ids. If you still see a
database constraint on import, expand **Details** on the result screen (user-facing category
only) and check the debug console for `Import save failed` with exception type and stack.
Do not delete `movie_shelf.sqlite` to "fix" a constraint — retry the failed rows instead.

## SQLite migration errors

The app is currently at `schemaVersion = 2`. Changing tables without a new `onUpgrade` step
will break existing installs. See [docs/DATABASE.md](DATABASE.md#migration-strategy). During
development, uninstalling the app (or deleting `movie_shelf.sqlite`) still works as a last
resort, but shipping a wipe is not acceptable.

## Android build issues

- Confirm `minSdkVersion` is at least 23 (already set in
  `android/app/build.gradle.kts`) — `mobile_scanner` requires it.
- If Gradle can't find the Android SDK, ensure `ANDROID_HOME`/`ANDROID_SDK_ROOT` is set and
  `flutter doctor` reports no Android toolchain issues.
- Camera-related crashes on very old/emulator devices without a camera should not happen
  (the manifest marks both camera `<uses-feature>` entries as `required="false"`), but the
  scanner screen itself will simply show the permission-denied view if no camera is present.
- **`compileSdk`/AGP/NDK mismatch errors** (e.g. "requires compiling against SDK 36",
  "requires Android Gradle plugin 8.9.1 or higher", or NDK version mismatches listed per
  plugin) — this project already pins `compileSdk = 36`, `ndkVersion = "27.0.12077973"`
  (`android/app/build.gradle.kts`) and AGP `8.9.1` (`android/settings.gradle.kts`) because
  `mobile_scanner`'s CameraX dependencies require them. If you bump `mobile_scanner` or
  other camera/Gradle-native plugins further, re-run `flutter build apk --debug` and follow
  whatever new minimum versions Gradle reports in the same way.
- **`permission_handler` Kotlin DSL build script errors** (e.g. "Unresolved reference:
  compilerOptions/jvmTarget" while compiling `permission_handler_android`'s own
  `build.gradle.kts`) — a very new `permission_handler_android` release can require a newer
  Android Gradle Plugin/Kotlin Gradle Plugin combination than the one declared in
  `android/settings.gradle.kts`. This project pins `permission_handler: ^12.0.3` (rather than
  the newest `13.x`) specifically to stay on an Android implementation that still ships a
  Groovy `build.gradle` compatible with AGP 8.9.x/Kotlin 2.1.0. If you upgrade
  `permission_handler`, expect to also need to bump AGP/Kotlin in `settings.gradle.kts` to
  match whatever that version's own Gradle script requires.

## iOS permission issues

- `NSCameraUsageDescription` is already set in `ios/Runner/Info.plist`. If the camera prompt
  never appears, fully delete the app from the simulator/device first — iOS caches
  permission decisions per install and won't re-prompt after a permanent denial; use the
  "Einstellungen öffnen" button (Settings → Movie Shelf → Camera) instead.
- Building for iOS requires Xcode on macOS; this cannot be verified from a non-macOS
  development environment — see [docs/IMPLEMENTATION_STATUS.md](IMPLEMENTATION_STATUS.md).

## "Keine Internetverbindung verfügbar" while you're clearly online

`NetworkInfo.isConnected` does a real DNS lookup (`InternetAddress.lookup('themoviedb.org')`)
rather than trusting the OS's "connected" flag, so a captive portal or DNS outage can trigger
this even with Wi-Fi "connected". Try a different network or wait for DNS to recover.
