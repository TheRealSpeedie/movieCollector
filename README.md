# Movie Shelf

Your physical discs, digital files and streaming services in one personal collection. Movie Shelf is a Flutter app for Android and iOS (plus an Android TV flavor). It works completely offline and without an account; your own server or Movie Shelf Cloud are optional.

## What it does

- **Fundstück-Check**: scan a DVD, Blu-ray or 4K barcode and see at once whether you own it, which edition you have, whether it is on your wishlist, and what is missing in the series. Known barcodes work offline; unknown ones are looked up later.
- **Collection**: movies and series with editions and copies (format, region, languages, condition, location, price), wishlist, watch history and ratings. Box sets are one copy that holds several titles.
- **Entdecken**: what to watch next from your shelf, your server and your streaming subscriptions, with reasons. Wishes in plain words ("etwas Lustiges unter 2 Stunden") are understood on the device; AI ordering is optional and needs consent.
- **Your own server** ([movieshelf_server](https://github.com/TheRealSpeedie/movieshelf_server)): play your files, pick audio and subtitles, resume on another device, control the TV app.
- **Sync and households**: keep the collection on several devices through your own server or Movie Shelf Cloud, and share it with the people you live with. Every copy keeps its owner; watch history and ratings stay personal.
- **Edition catalog**: see other releases of a film and how they differ, take them over, share your own.
- **Backup and export**: encrypted backups, JSON and CSV export, restore.

The full feature list is in [docs/FEATURES.md](docs/FEATURES.md).

## Where your data lives

| Mode | Where | Account |
|---|---|---|
| Only on this device (default) | SQLite on the phone | none |
| Own Movie Shelf Server | the phone and your server at home | none |
| Movie Shelf Cloud | the phone and the Cloud service | e-mail and password |

The collection is always complete on the device, so it stays usable offline in every mode. There are no analytics or advertising SDKs. Privacy policy: [movieshelf_server/site/privacy.html](https://github.com/TheRealSpeedie/movieshelf_server/blob/main/site/privacy.html).

## Quick start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
cp env.example.json env.json        # add your TMDB Read Access Token
flutter run --dart-define-from-file=env.json
```

A free [TMDB](https://www.themoviedb.org/) token is needed for search and metadata; barcodes use UPCitemdb's free tier by default. Without a token the app still runs with your saved collection. Step by step: [docs/SETUP.md](docs/SETUP.md).

## Documentation

| Document | Contents |
|---|---|
| [docs/SETUP.md](docs/SETUP.md) | From a fresh clone to a running app, `env.json` keys, permissions |
| [docs/FEATURES.md](docs/FEATURES.md) | Every feature from the user's side |
| [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) | Folders, layers, offline strategy, barcode and sync flows |
| [docs/DATABASE.md](docs/DATABASE.md) | Schema v7, migrations, deletion rules |
| [docs/APIS.md](docs/APIS.md) | TMDB, UPCitemdb and UPCMDB |
| [docs/IMPORT.md](docs/IMPORT.md) | Importing lists from notes, TXT and CSV |
| [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) | Common problems |
| [docs/IMPLEMENTATION_STATUS.md](docs/IMPLEMENTATION_STATUS.md) | What is done, partial or missing |

Test results, the device checklist and the roadmap for app and server live in the server repository: [VERIFICATION.md](https://github.com/TheRealSpeedie/movieshelf_server/blob/main/docs/VERIFICATION.md), [ROADMAP.md](https://github.com/TheRealSpeedie/movieshelf_server/blob/main/ROADMAP.md).

## Development

```bash
dart format .
flutter analyze
flutter test                                    # no API keys needed
flutter build apk --dart-define-from-file=env.json
flutter build apk --flavor tv -t lib/main_tv.dart --dart-define-from-file=env.json
```

Built with Riverpod, Drift, go_router, Dio, mobile_scanner and media_kit; exact versions in `pubspec.yaml`.
