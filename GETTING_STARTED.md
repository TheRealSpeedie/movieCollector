# What you need to do to make Movie Shelf work

The app already runs without API keys. Your local collection (SQLite) works offline.
Search, new movie metadata, series/collections, and unknown barcode lookup need **TMDB**.
Unknown barcodes also use **UPCitemdb** (free, no key required by default).

## 1. One-time project setup

In PowerShell, from this folder:

```powershell
flutter pub get
dart run build_runner build --delete-conflicting-outputs
```

You only need `build_runner` again if you change Drift tables or `@freezed` models.

## 2. Get a TMDB token (required for real movie data)

1. Create a free account: https://www.themoviedb.org/signup
2. Open **Settings → API**: https://www.themoviedb.org/settings/api
3. Request a developer API key (personal / non-commercial is fine).
4. Copy the **API Read Access Token** (long JWT, starts with `eyJ...`).
   Do **not** use the short “API Key (v3 auth)”.

## 3. Put the token in `env.json`

```powershell
Copy-Item env.example.json env.json
```

Open `env.json` and paste your token:

```json
{
  "TMDB_ACCESS_TOKEN": "eyJhbGciOi...paste-your-read-access-token-here",
  "UPCITEMDB_USER_KEY": "",
  "UPCITEMDB_KEY_TYPE": "3scale"
}
```

Leave the UPCitemdb fields empty. The free Explorer/trial API works without a key
(it is rate-limited). Only fill `UPCITEMDB_USER_KEY` if you later buy a paid UPCitemdb plan.

`env.json` is gitignored. Do not commit it.

## 4. Always start the app with that file

The token is compiled in at launch. If you forget the flag, TMDB stays “not configured”.

```powershell
flutter run --dart-define-from-file=env.json
```

Pick your Android phone or emulator when Flutter asks.

Same flag for a release APK:

```powershell
flutter build apk --dart-define-from-file=env.json
```

## 5. Check that it worked

1. Open **Mehr → Einstellungen**.
2. Under **API-Status**, TMDB should say **Konfiguriert**.
3. Home → **Nach Titel suchen** → search something like `Der Pate`.
4. Save it as **Gekauft**. It should persist after you restart the app.

If TMDB shows an error or “ungültig”:

- you used the short v3 key instead of the Read Access Token
- `env.json` is empty / wrong key name
- you ran `flutter run` without `--dart-define-from-file=env.json`

## 6. Camera (Fundstück-Check)

On first scan, Android/iOS will ask for camera permission. Allow it.
If you denied it permanently: **Einstellungen öffnen** on the scanner screen, then enable camera.

You can still use **Titel eingeben** without a camera.

## What each API does

| Service | Needed for | Key |
|---|---|---|
| TMDB | Search, posters/metadata, series completeness | Required — Read Access Token |
| UPCitemdb | Resolve a barcode you have never scanned | Optional — empty = free tier |

Barcodes you already mapped are stored locally and work **offline** with no API call.
