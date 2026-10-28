# Architecture

## Guiding principle

**SQLite is the source of truth for the user's collection.** TMDB and UPCitemdb are only
used to *enrich* data (metadata, collection info) and to *resolve* unknown barcodes/titles.
A failed API call must never delete, corrupt, or hide anything the user already saved
locally. A sync provider (the user's own server or Movie Shelf Cloud) holds a
copy for other devices; it never replaces the local collection. See the [roadmap](https://github.com/TheRealSpeedie/movieshelf_server/blob/main/ROADMAP.md).

## Ownership and sync

- `lib/core/collection/ownership_service.dart` is the only writer of ownership and wishlist.
  It adds or removes copies and personal state, then recomputes the `user_status` cache that
  screens read.
- `lib/core/sync/collection_records.dart` turns the database into sync records and writes
  incoming records back in reference order.
- `lib/core/sync/sync_engine.dart` pushes the difference between the collection and
  `sync_shadow`, then pulls with a cursor. Conflicting fields are kept locally and held back
  until resolved. `features/sync/data/self_hosted_sync_provider.dart` talks to `/api/sync`.
- Connecting a server never changes where the collection is stored;
  `features/sync/application/storage_migration.dart` is the only way to switch.

## Folder structure

```
lib/
  app/                    MaterialApp, go_router setup, bottom-nav shell, theme
  core/
    config/               Env (dart-define secrets)
    constants/             API + app constants
    database/             Drift tables, AppDatabase, converters, row→domain mappers
    errors/                Sealed AppException hierarchy
    matching/              MovieMatcher, MediaTitleParser, ItemSelection
    network/               DioClient, TMDB client, UPCitemdb client
    providers/             Riverpod providers wiring db/network/repositories
    utils/                 TitleNormalizer, date parsing, season labels
    collection/            OwnershipService: copies, owners, derived status
    sync/                  SyncEngine, CollectionRecords, SyncIds (record protocol)
  features/
    backup/                Encrypted backup, JSON/CSV export, restore, snapshots
    cloud/                 Movie Shelf Cloud account, client and sync provider
    collection/            "Sammlung" screen: Filme | Serien, filters, sort, search
    collections/           Franchises (TMDB collections) + missing movies
    discover/              Entdecken, "Was soll ich schauen?", query parser, optional AI ranking
    editions/              Editions and copies, edition catalog, edition comparison
    home/                  Home with insights
    household/             Haushalt: invite, join, leave, members
    import/                Text/CSV import: parse → typed ImportTarget → review → commit
    movie_details/         Single movie details screen
    movies/                MovieRepository + movie stream providers
    onboarding/            First start: storage, preferences, server, first item
    personal/              Watch state, rating, wishlist price
    playback/              Player, track and subtitle choice, pending positions
    remote/                Remote control for a TV
    scanner/               Barcode resolution + Fundstück-Check, offline scan queue
    search/                TMDB title search + add-movie flow
    server/                Pairing, server browsing, server client with pinning
    settings/              Settings, languages, preferences
    sync/                  Storage choice, migration between providers, sync status
    television/            Android TV flavor
    tv/                    TV series and seasons
    watch/                 Where to Watch, streaming subscriptions
  shared/
    models/                 Movie, TvSeries, TvSeason, PhysicalEdition, CollectionStatus, ImportTarget
    widgets/                Reusable UI: PosterImage, StatusChip, SelectableItemList, ...
```

Each feature keeps `data/` (repositories talking to Drift/network), `domain/` (pure models
and orchestration logic with no Flutter/DB imports), and `presentation/` (widgets) separate
where the feature is non-trivial. Simple features (e.g. `home`) skip layers that would add
no value — the brief explicitly asks not to overengineer this into interfaces for their own
sake.

## Layering / data flow

```mermaid
flowchart LR
    UI[Widgets] -->|ref.watch| Providers[Riverpod Providers]
    Providers --> Repos[Repositories]
    Repos --> DB[(Drift / SQLite)]
    Repos --> TMDB[TmdbApiClient]
    Repos --> UPC[UpcItemDbClient]
    TMDB --> DioClient
    UPC --> DioClient
    DioClient --> NetworkInfo[NetworkInfo]
```

- Widgets never touch Drift or Dio directly. They call `ref.watch`/`ref.read` on providers.
- Repositories are the only classes that know about both the database and the network. They
  decide what gets cached, what's stale, and how failures degrade gracefully.
- `DioClient` centralizes timeout/error-mapping so every API client gets consistent
  `AppException`s (`NoInternetException`, `RateLimitException`, `InvalidApiConfigException`,
  etc.) instead of raw `DioException`s leaking into the UI.

## Riverpod usage

The project uses **manual Riverpod providers** (no `riverpod_generator`/code-gen) to avoid
version conflicts with `drift_dev`/`freezed` in the code-generation pipeline. Patterns used:

- `Provider` — singletons/factories with no async lifecycle (`AppDatabase`, `TmdbApiClient`,
  repositories).
- `StreamProvider` / `StreamProvider.family` — live queries from Drift (`watchAllMovies()`,
  `watchCollection(id)`), so the UI updates automatically the instant something is
  saved/changed, with zero manual cache invalidation.
- `StateNotifierProvider` — screen-level workflows with imperative steps (`FundstueckController`,
  `ImportController`, `CollectionFilterController`).
- Plain `Provider` for derived/computed state (`filteredMoviesProvider`, `collectionCountsProvider`)
  that combines other providers instead of duplicating state.

All async DB/network operations are wrapped in `AsyncValue` (`.when(loading:, error:, data:)`
in the UI), so every screen has consistent loading/error/data states without ad-hoc
`FutureBuilder` boilerplate.

## Repository boundaries

| Repository | Owns | Talks to |
|---|---|---|
| `MovieRepository` | Personal collection rows, genre links | Drift, `TmdbApiClient`, `CollectionRepository` |
| `TvRepository` | TV series + season ownership | Drift, `TmdbApiClient` |
| `PhysicalEditionRepository` | Physical box sets and their movie/season contents | Drift |
| `CollectionRepository` | Cached TMDB collections + their movie lists | Drift, `TmdbApiClient` |
| `BarcodeRepository` | Barcode → movie or physical-edition mappings | Drift only (no network — see below) |
| `BarcodeResolver` | Orchestrates barcode → movie/TV/box resolution | `BarcodeRepository`, `PhysicalEditionRepository`, `BarcodeProvider`, `TmdbApiClient`, `NetworkInfo`, `MediaTitleParser` |
| `ImportRepository` | Bulk text/CSV import matching + commit | `TmdbApiClient`, `MovieRepository`, `TvRepository`, `PhysicalEditionRepository` |

`BarcodeRepository` is intentionally network-free: it only knows about the local
barcode↔movie table. Resolving an *unknown* barcode is a distinct concern
(`BarcodeResolver`), which composes the repository with the network. This keeps "is this
barcode known locally?" trivially testable and fast, and keeps the barcode-provider
abstraction (`BarcodeProvider`) swappable without touching persistence code.

## Offline-first strategy

- **Known movies/barcodes**: served entirely from Drift `Stream` queries — no network call in
  the read path at all.
- **Known collections**: `CollectionRepository.syncCollection` caches TMDB collection data
  with a `lastSyncedAt` timestamp and skips re-fetching for
  `AppConstants.collectionStaleAfter` (7 days) unless `forceRefresh: true`. Cached collections
  render fully offline.
- **Unknown barcode while offline**: `BarcodeResolver` checks `NetworkInfo.isConnected` *before*
  attempting any network call and returns `BarcodeUnresolvedOffline` — the UI explains a
  connection is needed and still offers manual title entry.
- **Metadata staleness**: `MovieRepository.isMetadataStale` compares `lastMetadataSyncAt`
  against `AppConstants.metadataStaleAfter` (14 days); the movie details screen uses this to
  offer an explicit "refresh metadata" action rather than refetching on every open.
- **Posters**: `cached_network_image` persists images to disk; `PosterImage` shows a
  placeholder/error icon instead of breaking layout when an image is unavailable or offline.
- **Failures never corrupt local state**: e.g. in `MovieRepository.addFromTmdb`, if collection
  sync fails after the movie itself was already saved, the exception is swallowed (movie
  stays saved) — collection completeness is a cache, not a dependency for the save to
  succeed.

## Barcode resolution flow

```mermaid
sequenceDiagram
    participant UI as Scanner UI
    participant Resolver as BarcodeResolver
    participant BR as BarcodeRepository (Drift)
    participant Net as NetworkInfo
    participant UPC as UpcItemDbClient
    participant TMDB as TmdbApiClient

    UI->>Resolver: resolve(barcode)
    Resolver->>BR: resolveMovie(barcode)
    alt mapping exists locally
        BR-->>Resolver: Movie
        Resolver-->>UI: BarcodeKnownMovie
    else no local mapping
        Resolver->>Net: isConnected
        alt offline
            Resolver-->>UI: BarcodeUnresolvedOffline
        else online
            Resolver->>UPC: lookup(barcode)
            alt no product found
                Resolver-->>UI: BarcodeNoMatch
            else product found
                Resolver->>TMDB: searchMovies(productTitle)
                Resolver->>Resolver: MovieMatcher.rank(...)
                Resolver-->>UI: BarcodeNeedsConfirmation(candidates)
                UI->>Resolver: confirmAndSave(candidate, status)
                Resolver->>BR: saveMapping(barcode → movie)
            end
        end
    end
```

Once `saveMapping` runs, the same barcode resolves through the top ("mapping exists locally")
branch forever after — no repeated API calls for a barcode you've already resolved.

## TMDB metadata / collection flow

```mermaid
sequenceDiagram
    participant UI as Add-Movie / Import UI
    participant MR as MovieRepository
    participant TMDB as TmdbApiClient
    participant CR as CollectionRepository

    UI->>MR: addFromTmdb(tmdbId, status)
    MR->>TMDB: getMovieDetails(tmdbId)
    MR->>MR: insert movie row + link genres (transaction)
    alt movie belongs to a TMDB collection
        MR->>CR: syncCollection(collectionId)
        CR->>TMDB: getCollection(collectionId)
        CR->>CR: cache collection + all its movie parts
    end
    MR-->>UI: saved Movie
```

If `syncCollection` throws (offline, rate-limited, etc.), `MovieRepository` catches and
ignores it — the movie is still saved, just without series-completeness data until the next
successful sync.

Import persistence is separate: `ImportRepository.commit` fetches full movie details, then
upserts inside a **per-source-row** transaction (see [docs/IMPORT.md](IMPORT.md)). Genre and
collection rows are reused across movies via `tmdb_id` upserts. `addFromTmdb` remains the
API for the single-title add screen and still throws `DuplicateMovieException` when that
title is already stored.

## Navigation

`go_router` with `StatefulShellRoute.indexedStack` drives five persistent bottom-nav tabs
(Home, Sammlung, Entdecken, Fundstück/Scanner, Mehr). Until onboarding is done, a redirect
sends every route except server pairing to `/onboarding`, each keeping its own navigation state when
switching tabs. Screens reached from *within* a tab (movie details, search, add-movie, import,
settings, collection detail, missing movies, Fundstück result) are pushed on the root
navigator via `parentNavigatorKey`, so they appear as full-screen pages above the bottom nav
rather than nested inside a tab.
