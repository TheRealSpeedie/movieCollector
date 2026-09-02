# Movie Shelf

Movie Shelf is a personal, offline-first Flutter app for managing a physical DVD/Blu-ray
collection of **movies and TV series**. Its main use case: you are at a flea market or
second-hand shop, see a disc, scan its barcode, and immediately learn whether you already own
the movie or season, whether it's on your wishlist, and how complete the series or collector
box it belongs to is.

Your collection lives entirely in a local SQLite database on the device. The
[TMDB](https://www.themoviedb.org/) API and [UPCitemdb](https://www.upcitemdb.com/) are only
used to enrich movies with metadata and to resolve barcodes you have never scanned before —
never as the source of truth for what you own.

## Main features

- **Fundstück-Check** — scan a barcode (or search by title) and instantly see if you own the
  movie, TV season, or box-set contents, if they're on your wishlist, or if they're missing,
  with full offline support for barcodes you've scanned before.
- **TV series** — ownership is tracked per season (`Gekauft` / `Wunschliste` / `Offen` /
  `Fehlt`). Series cards show `x / y Staffeln gekauft`. Season 0 / Specials are never included
  in "complete series" unless you explicitly select them.
- **Physical box sets** — one barcode/import line can represent a movie collector box, several
  TV seasons, or a complete series. The physical product is stored once and linked to its
  contents; already-owned items are not duplicated.
- **Series completeness** — movies that belong to a TMDB collection (e.g. Harry Potter) show
  owned/missing progress across the whole series.
- **Sammlung (collection)** — a searchable, filterable, sortable grid/list of everything you
  own, wishlist, or have marked as open.
- **Reihen (collections)** — browse all cached movie series and jump straight to missing
  entries.
- **Fehlende Filme (missing movies)** — one place to see everything you're still missing
  across all your series, with a quick "add to wishlist" action.
- **Import** — paste a messy plain-text list (or a TXT/CSV file) from your notes app and
  import it with a review step that flags ambiguous or unrecognized titles, letting you pick
  from suggested candidates or search TMDB manually before committing anything.
- **Learns barcode mappings** — once you've resolved a barcode manually, it resolves
  instantly and offline the next time.
- **Offline-first everywhere** — the app remains fully usable for everything you've already
  synced; only resolving unknown barcodes/titles requires a connection.

## Screenshots

_Add screenshots here once available (e.g. `docs/screenshots/home.png`,
`docs/screenshots/fundstueck.png`, `docs/screenshots/collection.png`)._

## Tech stack

| Concern | Package |
|---|---|
| State management | `flutter_riverpod` (manual providers, no code generation) |
| Local database | `drift` (SQLite) |
| Networking | `dio` |
| Barcode scanning | `mobile_scanner` |
| Poster caching | `cached_network_image` / `flutter_cache_manager` |
| Navigation | `go_router` (`StatefulShellRoute.indexedStack`) |
| Immutable models | `freezed` / `json_annotation` |
| Formatting/i18n prep | `intl`, `flutter_localizations` |
| Lightweight settings | `shared_preferences` |
| Permissions | `permission_handler` |

See `pubspec.yaml` for exact versions.

**You only need this file to go from clone → working APIs:** [GETTING_STARTED.md](GETTING_STARTED.md)

## Quick start

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter run --dart-define-from-file=env.json
```

You need a TMDB API token before the app can fetch real movie data — see
[API requirements](#api-requirements) below and [docs/SETUP.md](docs/SETUP.md) for the full
walkthrough.

## API requirements

- **TMDB (required)** — a free TMDB account and API Read Access Token. Without it, search,
  barcode resolution, and metadata refresh are disabled; the app still runs and your existing
  local collection remains fully usable.
- **UPCitemdb (optional)** — no signup required for the free "trial" tier used by default
  (rate-limited). An account is only needed if you want the higher-throughput paid tier.

Full setup instructions: [docs/SETUP.md](docs/SETUP.md).

## Development commands

```bash
flutter pub get                                              # install dependencies
dart run build_runner build --delete-conflicting-outputs      # generate Drift/freezed code
dart format .                                                 # format
flutter analyze                                               # static analysis
flutter test                                                  # unit/widget/database tests
flutter run --dart-define-from-file=env.json                  # run with real TMDB data
```

## Documentation

- [docs/SETUP.md](docs/SETUP.md) — step-by-step setup from a fresh clone
- [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) — architecture, data flow, offline strategy
- [docs/DATABASE.md](docs/DATABASE.md) — schema, relationships, migrations
- [docs/APIS.md](docs/APIS.md) — TMDB & UPCitemdb integration details
- [docs/IMPORT.md](docs/IMPORT.md) — import parsing, matching, review workflow
- [docs/FEATURES.md](docs/FEATURES.md) — features from a user's perspective
- [docs/TROUBLESHOOTING.md](docs/TROUBLESHOOTING.md) — common problems and fixes
- [docs/IMPLEMENTATION_STATUS.md](docs/IMPLEMENTATION_STATUS.md) — honest status checklist

## Project status

Feature-complete for the first version described in the project brief: `flutter analyze`
reports no issues, the automated test suite (unit, database, widget) passes, and an Android
debug APK builds successfully (`flutter build apk --debug`). It has not been run on a
physical device/emulator or built for iOS in this environment (no device/emulator or
macOS/Xcode available here) — see
[docs/IMPLEMENTATION_STATUS.md](docs/IMPLEMENTATION_STATUS.md) for the full, honest breakdown
of what is verified vs. what still needs manual/device verification.

## No account, no backend

There is no login, no cloud sync, and no analytics. Everything lives in a local SQLite file
on your device. This is intentional for a personal, private collection app.
