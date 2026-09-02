# Import

The import feature (`lib/features/import/`) lets you bring in a movie list you already keep
in a notes app, without depending on any specific notes app's API — you simply paste text or
pick an exported file.

## Supported formats

- **Paste plain text** directly into the import screen.
- **TXT file** — parsed the same way as pasted text (one title per line).
- **CSV file** — the first column of each row is treated as the title; a header row (e.g.
  `Titel`, `Title`, `Movie`, `Name`) is automatically detected and skipped.

## Text parsing (`ImportTextParser`)

Plain text/TXT parsing (`parsePlainText`):

1. Splits on any line ending (`\n`, `\r\n`, `\r`).
2. Strips list "artifacts" per line via `TitleNormalizer.stripListArtifacts`: leading bullets
   (`-`, `•`), checkbox markers (`[x]`, `[ ]`), and simple numbering prefixes (`1.`, `2)`, ...).
3. Trims whitespace and drops empty lines.

This means all of the following normalize to clean titles:

```
Harry Potter 1          → Harry Potter 1
- Twilight               → Twilight
[x] Top Gun              → Top Gun
• New Moon                → New Moon
1. Fast and Furious Tokyo Drift → Fast and Furious Tokyo Drift
```

CSV parsing (`parseCsv`) additionally handles a quoted first cell (e.g.
`"Herr der Ringe, Die Gefährten",2001`) and skips a detected header row before applying the
same artifact-stripping to the extracted title.

## Matching (`ImportRepository`)

`MediaTitleParser` first produces a **hint** (not a final decision): single movie, movie box,
single season, multi-season box, or complete series. Distinctions that matter:

- `The Complete Fourth Season` / `komplette vierte Staffel` → **one season**
- `Complete Series` / `Komplettbox` / `komplette Serie` → **all regular seasons**
- `Staffel 1-5`, `Seasons 1–5`, `Staffel 1, 2 und 3` → **those seasons**, still confirmed in UI
- `Collector's Box` / `8-Film Collection` → **movie collection**, contents confirmed by the user

Season 0 / Specials are never preselected for complete-series or "all seasons".

Each row then resolves to a sealed `ImportTarget`:

`singleMovie` | `movieBundle` | `singleTvSeason` | `tvSeasonBundle` | `completeTvSeries` | `skipped`

One source line may create many movies or seasons. Partial duplicates are counted as
already-owned and the rest are added. A skipped bundle creates nothing.

Movie collector boxes **suggest** a TMDB collection and preselect its parts, but never mark
them owned until the user reviews/commits. "Complete Collection" on an unknown title may try
TV first and fall back to a movie collection if TMDB TV search is empty.

For every parsed line, `ImportRepository._buildRow`:

1. Extracts a plausible year from the raw line via `TitleNormalizer.extractYear` (e.g.
   `Dune (2021)` → `2021`), independent of the cleaned title.
2. Searches TMDB for the cleaned title.
3. Ranks all results with `MovieMatcher` (title similarity + optional year boost — see
   [Search normalization](ARCHITECTURE.md)). The full ranked list is kept on the row as
   `candidates`, best match first.
4. Checks whether the top-ranked TMDB movie is **already saved locally**
   (`MovieRepository.getMovieByTmdbId`) — if so, the row is marked `duplicate` regardless of
   confidence, and excluded from `commit`.
5. Classifies the row based on the best candidate's confidence, using the same thresholds as
   barcode resolution (`AppConstants.defaultMatchConfidenceThreshold = 0.82`,
   `AppConstants.minAcceptableConfidence = 0.55`):
   - **`matchedAutomatically`** — best confidence ≥ 0.82 **and** clearly ahead of the
     second-best candidate (margin ≥ 0.1). Auto-selected for import.
   - **`ambiguous`** — best confidence ≥ 0.55 but not confident enough to auto-select.
     The ranked candidates are shown so the user can pick the right one.
   - **`notFound`** — no TMDB results at all, or best confidence below 0.55.
   - **`duplicate`** — best match already exists in the local collection.

The parser and matcher never silently import "whatever TMDB returned first" — every row that
isn't unambiguously confident is flagged for the user to review or correct.

## Row states (`ImportRowStatus`)

Every row is in exactly one of six explicit states — there is no separate "excluded" flag
layered on top, so a row can never be, say, both `ambiguous` and skipped at once:

| Status                 | Meaning                                                              |
| ----------------------- | --------------------------------------------------------------------- |
| `matchedAutomatically`  | Automatic matcher found a confident TMDB match.                      |
| `ambiguous`             | Possible matches exist, but confidence was too low to auto-select.   |
| `notFound`              | The automatic TMDB search returned no usable match.                  |
| `matchedManually`       | The user picked a TMDB movie via the inline candidates or the manual search screen. |
| `duplicate`             | The matched movie already exists in the local collection.            |
| `skipped`               | The user explicitly continued without assigning a movie.             |

## Manual matching flow

Ambiguous and not-found rows are the two states that need user input before they can be
imported. Both reuse the exact same underlying flow instead of two separate implementations:

- **`ambiguous`** rows show the imported text, the badge `Nicht eindeutig erkannt`, and the
  first 4 ranked candidates inline (poster, title, original title, release year) via the
  shared `MovieSearchResultTile` widget. Tapping a candidate immediately calls
  `ImportController.selectCandidate`, which sets the row to `matchedManually` with that movie
  — no database write happens yet. Below the candidates, `Weitere Ergebnisse` opens the
  dedicated manual search screen, and `Ohne Zuordnung fortfahren` calls
  `ImportController.skipRow`.
- **`notFound`** rows show the badge `Kein Film erkannt` with a `Film manuell suchen` button
  (opens the same manual search screen) and the same `Ohne Zuordnung fortfahren` action.
- **`ImportMovieSearchScreen`** (`/import/movie-search/:index`) is the shared manual search
  screen for both cases. It shows the original imported text, prefills the search field with
  the parsed title, and lets the user freely edit the query. Typing debounces for 400 ms
  before searching TMDB again (`ImportMovieSearchController`); submitting via the keyboard
  search action searches immediately. TMDB pagination is supported with a "Mehr laden"
  button that fetches the next page and appends it, resetting whenever the query changes.
  Selecting a result calls `selectCandidate` and pops back to the review screen; `Ohne Film
  fortfahren` calls `skipRow` and pops back the same way. Pressing the normal back button
  without picking anything or skipping leaves the row completely untouched — the screen never
  mutates state on its own.
- Selecting a candidate or a manual search result **never writes to the database.** It only
  updates the in-memory `ImportRow` for that line; the movie is only ever persisted when the
  user finally commits the whole import.
- Rows already resolved (`matchedManually`) or explicitly `skipped` still show a small
  `Zuordnen`/re-open action, so a decision can always be revisited before the final commit.

## Review workflow

The import screen (`lib/features/import/presentation/import_screen.dart`) driven by
`ImportController`:

1. Paste text or pick a TXT/CSV file.
2. `ImportController` parses the input and runs `ImportRepository.buildRows`, showing
   progress as each line is matched against TMDB.
3. An **analysis summary** is shown before anything is committed, one chip per state:
   total lines, `matchedAutomatically` ("Erkannt"), `matchedManually` ("Manuell zugeordnet"),
   `ambiguous` ("Unklar"), `notFound` ("Nicht gefunden"), `skipped` ("Übersprungen"), and
   `duplicate` ("Duplikate").
4. The user resolves `ambiguous`/`notFound` rows using the manual matching flow described
   above (pick a candidate, search manually, or explicitly skip).
5. The user picks a **default status** to apply to all imported rows — `Gekauft` (owned,
   the default), `Wunschliste`, or `Offen`.
6. Committing calls `ImportRepository.commit`, which processes **one source row at a time**
   (never a parallel `Future.wait` of dozens of SQLite writes). Matching is already done;
   persistence fetches full TMDB movie details only for titles that are not stored locally,
   then writes inside a per-source-row Drift transaction.

## Persistence lifecycle

```text
source row
→ fetch missing TMDB details (outside the DB transaction)
→ transaction starts
   → upsert genres by TMDB id (insert or update on tmdb_id, never on the local PK)
   → insert new movies / apply status to existing ones
   → insert TV series/seasons when applicable
   → create physical edition + relation rows using LOCAL ids
→ commit or roll back that source row only
```

TMDB collection cache sync runs once per unique collection **after** the row loop, and is
non-fatal.

While saving, the UI shows `n / total verarbeitet`, the current title, and live counters.
Back navigation is blocked only during `ImportPhase.committing`.

## Duplicate handling

Duplicates are detected during matching (by TMDB id) **and** again at persist time. They are
not a failed insert.

- Same TMDB movie already in the collection → counted as `alreadyExists` (or `updated` if
  status changes). Never a UNIQUE constraint error.
- Status rule: import may **upgrade** (`wishlist`/`open` → `owned`, `open` → `wishlist`) but
  never downgrade an already `owned` title.
- Bundles: already-owned parts are reused; only missing parts are inserted. The source row
  still succeeds (`4 hinzugefügt`, `2 bereits vorhanden`).
- Shared genres and shared TMDB collections are upserted, not inserted as new rows.

## Transactional safety

Each **source import row** is one persistence unit (important for box sets such as
`Sharknado 1-6`). If that row fails, its transaction rolls back — no half-written bundle.
Other source rows that already committed stay saved. Unresolved rows without a target are
counted as skipped.

`ImportSaveFailure` keeps a user-facing message plus a developer message (exception type and
text). Debug builds log:

```text
Import save failed
Source: "Pacific Rim"
Target: SingleMovie
TMDB ID: 68726
Exception: ...
StackTrace: ...
```

The result UI never shows stack traces or SQL. Identical failure categories are grouped
(`Datenbankfehler · 2`), then affected titles are listed with expandable details.

## Retry

If any source row fails, **Fehlgeschlagene erneut versuchen** persists only those rows, using
the already resolved `ImportTarget`s. Successful rows are not rematched and not inserted
again. The import session stays in memory until the user leaves the screen or starts a new
import.

Saving a large list after the matching step can hit TMDB's request limit (`HTTP 429`).
Commit waits briefly between detail fetches, retries the current title once after
`Retry-After` (or 5 seconds), and if the limit is still exceeded it stops further TMDB calls
and marks the remaining titles as failed with that reason.

The commit returns an `ImportCommitReport` built from per-row `ImportRowOutcome`s:
source-entry counts (`processedSourceRows`) stay separate from logical counts
(`importedMovies`, `importedSeasons`, `alreadyExisted`, `updated`). One source row may
contribute several movies or seasons.
