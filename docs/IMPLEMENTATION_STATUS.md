# Implementation status

What the app has, what is partial, and what is missing. How each part is tested, and what still needs a real device, is in the server repository's [VERIFICATION.md](https://github.com/TheRealSpeedie/movieshelf_server/blob/main/docs/VERIFICATION.md). What each feature looks like for the user is in [FEATURES.md](FEATURES.md).

Last updated: 28 October 2026 (Phase 5.5).

## Implemented

| Area | Where | Tests |
|---|---|---|
| Local database, schema v7, migrations from v1 | `lib/core/database/` | `test/core/database/` |
| Ownership: editions, copies with owner and private flag, personal state | `lib/core/collection/ownership_service.dart` | `test/core/collection/` |
| Sync engine (field merge, conflicts, refused changes undone, collection switch) | `lib/core/sync/` | `test/core/sync/` |
| Storage modes, migration with snapshot and count check, sync status | `lib/features/sync/` | `test/features/sync/`, `test/features/cloud/cloud_migration_test.dart` |
| Own server: pairing, HTTPS pinning, browsing, playback, pending positions, TV remote | `lib/features/server/`, `playback/`, `remote/` | `test/features/server/`, `test/features/playback/`, `test/integration/television_test.dart` (needs a running server) |
| Movie Shelf Cloud account and sync | `lib/features/cloud/` | `test/features/cloud/` |
| Households | `lib/features/household/` | `test/core/sync/collection_switch_test.dart`, `test/core/collection/household_ownership_test.dart` |
| Fundstück-Check with offline queue (drained on start and resume) | `lib/features/scanner/` | `test/features/scanner/` |
| Editions, copies, edition catalog, edition comparison | `lib/features/editions/` | `test/features/editions/` |
| Watch history, ratings, Where to Watch, subscriptions | `lib/features/personal/`, `watch/` | `test/features/watch/` |
| Entdecken, query parser, optional AI ranking with consent | `lib/features/discover/` | `test/features/discover/` |
| Import | `lib/features/import/` | `test/features/import/` |
| Backup, export, restore | `lib/features/backup/` | `test/features/backup/` |
| Onboarding, settings, languages and subtitles | `lib/features/onboarding/`, `settings/` | `test/features/playback/track_preferences_test.dart` |
| Android TV flavor | `lib/features/television/`, `lib/main_tv.dart` | `test/features/television/` |
| Accessibility: labels for icon buttons, spoken collection tiles, large text, reduced motion | across screens | `test/shared/large_text_test.dart` |

## Partial

- **Sammlung filters**: only status chips have a UI. `CollectionFilterController` already supports genre and year filters (`setGenreFilter`, `setYearFilter`).
- **Barcode mappings**: adding works from the movie page; there is no UI to edit or delete a mapping (`BarcodeRepository.deleteMapping` exists and is tested).
- **Manual collections**: the `collections` table can hold user-made collections (`isCustom`), but there is no UI to create one.

## Not implemented

- Buying a Movie Shelf Cloud subscription in the app (the operator grants subscriptions).
- An on-device AI model (the interface exists, none is bundled).
- Statistics screens, lending tracking, push notifications for collection insights.
- Offline downloads, casting and remote access outside the home network (proposed for Phase 6 in the roadmap).

## Known limitations

- API keys from `env.json` are compiled into the app and can be extracted from the binary; see [APIS.md](APIS.md#key-security-limitations-in-mobile-apps).
- UPCitemdb's free tier is rate-limited; the app only reports the limit, it does not budget requests.
- When TMDB has no German text, the overview falls back to English.
- iOS was never built (no Mac available); Android builds were verified, but no screen was checked on a device. Screenshots are still missing.
