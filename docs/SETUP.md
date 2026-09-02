# Setup

Step-by-step instructions to get Movie Shelf running from a fresh clone. This assumes you
already know how to program and use Flutter, but have never seen this project before.

## 1. Prerequisites

- **Flutter SDK 3.32.x** (Dart 3.8.x), stable channel. Verify with:

  ```bash
  flutter --version
  ```

  If you have an older Flutter version, run `flutter upgrade` first. The project's
  `pubspec.yaml` pins `environment: sdk: ^3.8.1`, so an older Dart SDK will fail to resolve
  dependencies.
- Android Studio (for the Android SDK/emulator) and/or Xcode (for iOS, macOS only).
- A physical device or emulator with a camera if you want to test barcode scanning — desktop
  emulators without a camera can still exercise every other screen.

## 2. Install dependencies

```bash
flutter pub get
```

## 3. Generate code

Drift (database) and Freezed (immutable models) rely on code generation. Run this after
`flutter pub get` and again any time you change a `@freezed` class or a Drift table:

```bash
dart run build_runner build --delete-conflicting-outputs
```

This produces `*.g.dart` and `*.freezed.dart` files next to their sources. They are not
committed to version control in a fresh clone and must be regenerated locally.

## 4. Create a TMDB account and API token

1. Create a free account at <https://www.themoviedb.org/signup>.
2. Go to **Settings → API** (<https://www.themoviedb.org/settings/api>) and request an API
   key (choose "Developer" — personal, non-commercial use is fine).
3. Once approved, copy the **API Read Access Token** (the long JWT-style token, *not* the
   short "API Key (v3 auth)"). Movie Shelf authenticates with
   `Authorization: Bearer <token>`, which is TMDB's currently recommended v4-style auth for
   read endpoints.

## 5. Configure the token

Movie Shelf never reads secrets from committed source files. It reads them via Dart
compile-time environment variables (`String.fromEnvironment`), supplied through a
`--dart-define-from-file` JSON file.

1. Copy the example file:

   ```bash
   cp env.example.json env.json
   ```

   (On Windows PowerShell: `Copy-Item env.example.json env.json`.)

2. Open `env.json` and fill in your token:

   ```json
   {
     "TMDB_ACCESS_TOKEN": "eyJhbGciOi... (your TMDB API Read Access Token)",
     "UPCITEMDB_USER_KEY": "",
     "UPCITEMDB_KEY_TYPE": "3scale"
   }
   ```

   - `TMDB_ACCESS_TOKEN` — required for search, metadata, and collection sync.
   - `UPCITEMDB_USER_KEY` / `UPCITEMDB_KEY_TYPE` — optional. Leave empty to use UPCitemdb's
     free, rate-limited "trial" tier (no signup needed). Only fill these in if you've signed
     up for UPCitemdb's paid tier — see [docs/APIS.md](APIS.md).

`env.json` is already listed in `.gitignore`, so it will never be committed.

## 6. Run the app

```bash
flutter run --dart-define-from-file=env.json
```

Without the `--dart-define-from-file` flag the app still launches (it never crashes on
missing configuration), but TMDB-backed features are disabled and the Settings screen shows
TMDB as "not configured". Your already-saved local collection remains fully browsable.

To build a release APK/IPA with the token baked in, pass the same flag to `flutter build`:

```bash
flutter build apk --dart-define-from-file=env.json
flutter build ios --dart-define-from-file=env.json
```

> **Security note:** a client-side mobile app cannot truly hide an embedded API key — anyone
> with the compiled binary can, with effort, extract it. This is an accepted tradeoff for a
> private personal app using a free-tier key. If you ever distribute this app publicly,
> proxy paid/sensitive API calls through a small backend instead of embedding credentials in
> the client.

## 7. Android permissions

Already configured in `android/app/src/main/AndroidManifest.xml`:

- `android.permission.CAMERA` — barcode scanning.
- `android.permission.INTERNET` — TMDB/UPCitemdb requests.
- `android.hardware.camera` / `android.hardware.camera.autofocus` (both `required="false"`) —
  the app still installs on devices/emulators without a camera; the scanner screen will show
  a permission/hardware explanation instead of crashing.

`minSdkVersion` is set to 23 (Android 6.0) in `android/app/build.gradle.kts`, which is the
minimum required by `mobile_scanner`. `compileSdk` (36) and `ndkVersion` (27.0.12077973) are
also pinned there, and the Android Gradle Plugin is pinned to 8.9.1 in
`android/settings.gradle.kts` — all three are required by `mobile_scanner`'s CameraX
dependencies; see [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md#android-build-issues) if you
change plugin versions and Gradle starts asking for newer ones again.

No manual steps are required here — the manifest and Gradle files ship with the repository,
and `flutter build apk --debug` has been verified to succeed against them.

## 8. iOS permissions

Already configured in `ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>Movie Shelf benötigt Kamerazugriff, um Barcodes von DVDs und Blu-rays für den Fundstück-Check zu scannen.</string>
```

iOS will show this text the first time the app requests camera access. No manual steps are
required — the `Info.plist` ships with the repository. Building for iOS requires a Mac with
Xcode installed; this cannot be verified from a non-macOS environment.

## 9. Verify your setup

```bash
flutter analyze   # should report "No issues found!"
flutter test      # should report "All tests passed!"
```

Neither command requires a TMDB token — all tests mock external APIs.

## Troubleshooting common setup mistakes

See [docs/TROUBLESHOOTING.md](TROUBLESHOOTING.md) for a full list. The most common first-run
issues are:

- **Forgetting `--dart-define-from-file=env.json`** → TMDB search returns
  "API-Konfiguration ist ungültig" errors. Re-run with the flag.
- **Forgetting to run `build_runner`** → the app fails to compile with errors about missing
  `*.g.dart`/`*.freezed.dart` files or undefined `_$Movie`/`_$AppDatabase` mixins.
- **Using the short "API Key (v3 auth)" instead of the "API Read Access Token"** → TMDB
  requests fail with 401. Movie Shelf uses Bearer-token auth, not the `api_key` query
  parameter.
