# Implementation status

An honest checklist of what's actually done vs. what still needs work. "Fully implemented"
means the code exists, compiles, is wired into the UI, and is covered by a passing automated
test where practical — not just that a placeholder exists.

## Fully implemented

- **Offline-first local database** — Drift/SQLite schema version 2 for movies, TV series,
  seasons, physical editions, barcodes, genres, and collections. Existing v1 movie data is
  migrated in place. SQLite is the only source of truth for ownership status.
- **TV series** — season-level ownership, completeness `x / y Staffeln gekauft`, series
  details with per-season status and confirmed bulk actions. Season 0 / Specials stay
  optional.
- **Physical box sets** — one barcode/import line can own many movies or seasons without
  duplicating the barcode onto each title. Partial duplicates are counted, not rejected.
- **TMDB client** — search, movie details (with German→English overview fallback and German
  FSK certification extraction via `append_to_response=release_dates`), and collection
  details, all using Bearer-token auth.
- **UPCitemdb client** — barcode lookup via the free trial tier by default, with automatic
  switch to the paid tier's base URL/headers when a user key is configured.
- **Barcode resolution & learning** — local-mapping check → offline check → UPCitemdb lookup →
  TMDB search → confidence-ranked matching → user confirmation → permanent mapping saved, so
  repeat scans resolve instantly offline. Backed by passing unit and database tests.
- **Movie repository** — add from TMDB (with DB-level unique-TMDB-id duplicate prevention),
  status updates, on-demand metadata refresh, genre linking/deduplication, deletion (with
  cascading barcode/genre-link cleanup that never touches cached collection data).
- **Collection repository** — TMDB collection sync with a 7-day staleness window
  (`AppConstants.collectionStaleAfter`) and explicit force-refresh, building
  owned/wishlist/open/missing status per series entry by joining against locally saved
  movies.
- **Series completeness UI** — shown in Fundstück-Check results, movie details, and the
  Reihen tab, sorted by release date with entries lacking a date sorted last, with the
  relevant movie highlighted.
- **Fundstück-Check** — full camera scanning flow (EAN-13/EAN-8/UPC-A/UPC-E), manual title
  fallback, all four result states (owned/wishlist/open/missing) with the exact German
  strings from the brief, and inline series-completeness.
- **Import** — plain text/TXT/CSV parsing, TMDB matching with review, default-status
  selection, per-source-row transactional persist (full TMDB details before insert, genre
  and collection upserts on TMDB id, idempotent duplicates, status upgrade without
  downgrade), live save progress, grouped failure summary, and retry of failed rows without
  rematching. A failed box-set row rolls back only that row. Backed by repository,
  controller, widget, and in-memory SQLite persistence tests including a realistic
  multi-title fixture.
- **Manual import matching** — ambiguous rows show their first 4 ranked TMDB candidates
  inline for one-tap selection; both ambiguous and not-found rows can open a dedicated,
  paginated manual TMDB search screen (prefilled with the imported title, debounced search,
  "Mehr laden" pagination) reached via `Weitere Ergebnisse` / `Film manuell suchen`; users can
  explicitly continue without a movie (`Ohne Zuordnung fortfahren`, state `skipped`, kept
  distinct from `notFound`); manual selections never touch the database until the final
  commit, and pressing back without acting leaves the row untouched. Backed by controller,
  repository, and widget tests.
- **Sammlung screen** — grid/list toggle (persisted), search, status filter chips, sorting
  (recently added/title/year/status), and distinct empty states for "no movies yet" vs. "no
  results for this filter."
- **Movie details** — full metadata display, status change via segmented control, on-demand
  metadata refresh, add-barcode bottom sheet, delete with confirmation dialog.
- **Reihen & Fehlende Filme** — collection list with progress, collection detail view, and a
  cross-collection missing-movies view grouped by series with quick "add to wishlist."
- **Settings** — metadata language/region, movie count, cache-clear action, live TMDB/UPCitemdb
  configuration status (without exposing secrets), app version, TMDB attribution text.
- **Navigation** — `go_router` `StatefulShellRoute.indexedStack` bottom nav (Home, Sammlung,
  Reihen, Fundstück, Mehr) with detail screens pushed on the root navigator.
- **Theme** — restrained Material 3 theme matching the requested palette/status semantics, no
  gradients/glassmorphism/oversized hero sections.
- **Error handling** — sealed `AppException` hierarchy mapped centrally from Dio in
  `DioClient`, rendered via a shared `describeError()` helper; no raw exception text is ever
  shown to the user.
- **Permissions** — Android manifest (camera + internet, optional camera hardware features,
  `minSdk 23`) and iOS `Info.plist` (`NSCameraUsageDescription`) configured; the scanner
  screen requests permission, explains why it's needed, and offers an "open settings" button
  when permanently denied.
- **API key configuration** — Dart-define-based (`env.json` / `env.example.json`, gitignored),
  documented commands, no secrets in source; app runs and degrades gracefully with no key
  configured.
- **Automated tests** — unit, database, and widget tests across matching, import
  parse/review/persist (including shared genres, shared collections, bundles, retry, and
  nullable metadata), barcode resolution, physical editions, and v1→v2 migration, all
  passing with mocked external APIs (no TMDB credentials required to run `flutter test`).
- **Static analysis** — `flutter analyze` reports zero issues.
- **Android debug build** — `flutter build apk --debug` compiles and links successfully in
  this environment (Android SDK 36.1.0 toolchain present), producing
  `build/app/outputs/flutter-apk/app-debug.apk`. Getting here required bumping the Android
  Gradle Plugin (8.7.3 → 8.9.1), `compileSdk` (→ 36), and `ndkVersion` (→ 27.0.12077973) in
  `android/settings.gradle.kts` / `android/app/build.gradle.kts`, and pinning
  `permission_handler` to `^12.0.3` instead of the newly-released `13.0.1` (whose Android
  implementation requires an AGP/Kotlin toolchain combination — AGP 9.0.1, Kotlin 2.3.20 —
  newer than what ships with current stable Flutter 3.32.x's default Gradle template). This
  exercises the full Dart→native Android compile path, including all generated Drift/Freezed
  code and plugin registration. See the note under "Known limitations" regarding running on
  an actual device/emulator.

## Partially implemented

- **Sammlung filters** — status filtering and sorting are fully wired into the UI.
  `CollectionFilterController` already supports genre and year filters
  (`setGenreFilter`/`setYearFilter`) and the `Movie` model carries genre/year/certification
  data, but there is **no UI control** yet to set a genre, year, collection, or age-rating
  filter — only the status chips are exposed in `collection_screen.dart`. Wiring up
  additional filter chips/dropdowns for these is straightforward future work using the
  existing controller methods.
- **Barcode edition management** — adding a barcode (with an optional free-text edition name)
  works from the movie details screen, and `BarcodeRepository.deleteMapping` exists and is
  covered by a database test, but there is **no UI action** to delete or edit an existing
  barcode mapping from the movie details screen; the barcode list there is currently
  read-only after creation (edits happen implicitly via `allowRemap: true` during a later
  Fundstück-Check confirmation).
- **Manual/custom collections** — the `collections` table already has an `isCustom` column
  and a nullable `tmdbCollectionId` specifically to support user-created collections later
  without a schema migration, but there is no UI to create or edit a manual collection in
  this version (matches the brief's explicit "not implemented now, but keep it possible").

## Requires external configuration (works, but needs your setup)

- **TMDB integration** — search, metadata, and collection sync are fully implemented but
  require a free TMDB API Read Access Token in `env.json`. Without it the app runs and your
  existing local collection is fully usable, but nothing new can be looked up. See
  [docs/SETUP.md](SETUP.md).
- **UPCitemdb paid tier** — the free trial tier works with no signup, but is subject to
  UPCitemdb-controlled rate limits that can change at any time; a paid key can be configured
  in `env.json` if needed. See [docs/APIS.md](APIS.md).

## Not implemented / future (explicitly out of scope for v1, per the brief)

- Manual/custom collection creation and editing UI.
- Backup/export and cloud synchronization.
- Multiple-edition ownership distinctions beyond the free-text `editionName` field (e.g. no
  dedicated "DVD vs. Blu-ray" ownership toggle).
- Statistics/analytics screens.
- Lending-to-friends tracking.
- Watched/unwatched tracking (the status enum models collection status, not watch status, by
  design).
- User accounts, login, or any backend/cloud database — intentionally absent.

## Known limitations

- **Barcode/rate-limit assumptions** — the app deliberately avoids hard-coding UPCitemdb's
  current rate limit into business logic (per the brief); this means the only feedback for
  exceeding it is the generic "rate limit reached" message, with no proactive
  request-budget UI.
- **API keys are embedded in the client binary** — as documented in
  [docs/APIS.md](APIS.md#key-security-limitations-in-mobile-apps), this is an accepted
  tradeoff for a private personal app and is not a defect, but it means this build should not
  be distributed publicly without moving credentials behind a backend proxy first.
- **English-first TMDB fallback** — when German copy is missing for a given movie, the
  overview (and, rarely, other fields) fall back to English rather than showing nothing;
  the German title is still preferred when available.
- **Genre/year/collection/age-rating filtering** — see "Partially implemented" above; only
  status filtering has a UI today.
- **No platform build verification beyond an Android debug APK** — this development
  environment is Windows-only, with no Android emulator/device attached (`flutter devices`
  only lists Windows desktop and web targets). The debug APK builds successfully but was
  **not run** on a physical device or emulator — camera scanning, permission dialogs, and
  on-device SQLite behavior are implemented per current `mobile_scanner`/`permission_handler`/
  `drift` documentation but have not been interactively exercised. A release build
  (`flutter build apk --release`) and app bundle (`--release --bundle`) were not attempted
  either. iOS could not be built or verified at all, since Xcode/macOS is not available in
  this environment; the iOS project configuration (`Info.plist` camera permission entry,
  deployment target) was written by hand against current Apple/Flutter documentation but is
  otherwise unverified.
- **No screenshots yet** — the README has a placeholder section; add real screenshots once
  the app has been run on a device.
