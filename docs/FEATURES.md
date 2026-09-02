# Features

A user-facing walkthrough of everything Movie Shelf can do today.

## Home

The home screen is a compact personal dashboard, not a generic admin panel:

- **Deine Sammlung** card — total movie count plus a `Gekauft` / `Wunschliste` / `Offen`
  breakdown.
- **Fundstück-Check** — a prominent dark call-to-action that jumps straight to the scanner.
- **Quick actions** — "Nach Titel suchen" and "Importieren" for the two other ways to add
  movies.
- **Zuletzt hinzugefügt** — a horizontal strip of your most recently added movies.
- **Deine Reihen** — up to three of your movie collections with a progress bar
  (`x / y gekauft`), tap-through to the full collection.
- Pull-to-refresh reloads movies and collections.

## Fundstück-Check (the main feature)

Reachable from the Home CTA or the "Fundstück" bottom-nav tab. Opens straight into the
camera:

1. Point the camera at an EAN-13, EAN-8, UPC-A, or UPC-E barcode. Detection is automatic
   (no manual capture button needed) and stops itself once a code is read.
2. If camera permission hasn't been granted yet, the screen explains why it's needed and asks
   for it; if permanently denied, a button opens the OS app-settings page directly.
3. A floating "Titel eingeben" button always offers manual title search as a fallback (works
   even without a camera or with permission denied).
4. After scanning/searching, the result screen shows one of four states:
   - **✓ Bereits in deiner Sammlung** (owned) — poster, title, year, genres, runtime, FSK
     rating, overview, and status.
   - **♡ Auf deiner Wunschliste** (wishlist) — same detail layout with the wishlist banner.
   - **Als offen gespeichert** (open) — same layout with the "open" banner.
   - **Dieser Film fehlt dir** (not in your collection) — shows the best match found (with
     alternatives if more than one plausible candidate exists) and three save actions: `Als
     gekauft speichern`, `Zur Wunschliste`, `Als offen speichern`.
5. If the movie belongs to a TMDB collection, its series-completeness card appears
   immediately underneath (see below), with the scanned/found movie's entry highlighted.
6. If the barcode was resolved via a fresh online lookup and confirmed by the user, an
   explicit "Diesen Barcode merken" button saves the barcode → movie mapping so future scans
   of the same disc resolve instantly and offline.
7. If offline and the barcode has never been seen before, the screen explains that a
   connection is required and still lets you search by title or fall back to whatever's
   cached locally.

## Series completeness (collections)

Whenever a saved movie belongs to a TMDB collection (e.g. "Harry Potter Collection"), Movie
Shelf shows:

- Collection name and a progress bar (`x / y gekauft`).
- Every known movie in the series, sorted by release date (movies with an unknown release
  date sort last rather than crashing or throwing off the order).
- Each entry marked as owned (✓), wishlist (♡), open, or missing (○) via consistent color
  coding.
- The currently viewed/scanned movie visually highlighted among its siblings.

This appears in three places: the Fundstück-Check result, the movie details screen, and the
dedicated Reihen (collections) tab.

## Sammlung (your collection)

The `Sammlung` tab has **Filme | Serien**.

Movies keep the existing grid/list, search, status chips, and sort options. Empty movies:
"Deine Sammlung ist noch leer" with "Film suchen".

TV cards show series name plus `x / y Staffeln gekauft`. Opening a series lists every season
with status (`Gekauft` / `Wunschliste` / `Offen` / `Fehlt`) and bulk actions **Alle als
gekauft markieren** / **Alle zur Wunschliste** behind a confirmation dialog. Specials are not
included in those bulk actions.

## Adding a movie by title

From Home ("Nach Titel suchen") or the Sammlung empty state:

1. Type a title; TMDB search results show poster, title, original title, and year.
2. Selecting a result opens an add screen with full movie details, a status selector
   (defaulting to Gekauft), and any collection info already known.
3. Saving stores the movie, links its genres, and — if it belongs to a collection —
   kicks off a background sync of that collection's other entries.
4. If the movie is already in your collection, you're told immediately and offered a status
   change instead of a duplicate insert (also enforced at the database level via a unique
   TMDB id constraint).

## Reihen (Collections) & Fehlende Filme (Missing movies)

- **Reihen** lists every cached collection with a poster, `x / y gekauft`, a progress bar,
  and missing count. Opening one shows the full series with owned/wishlist/open/missing
  status per entry and a quick "add to wishlist" action for anything missing.
- **Fehlende Filme** aggregates missing entries across *all* your cached collections into one
  screen, grouped by collection, so you can see everything you're missing across every series
  at a glance and add items to your wishlist directly from there.

## Movie details

Large poster, title, original title, year, runtime, genres, FSK rating, overview, current
status (changeable via a segmented control), the collection-completeness card if applicable,
every known barcode edition for that movie, and the last metadata sync time. Actions:
refresh metadata from TMDB on demand, add another barcode edition, or delete the movie
(behind a confirmation dialog — cached collection/series data is never affected by deleting a
personal movie).

## Fundstück-Check for boxes and TV

If the scanned product is a season or box, Fundstück-Check shows how many of the contained
titles you already own and how many would be added (`2 bereits vorhanden`, `4 fehlen dir`).
**Als gekauft speichern** only adds or updates missing contents and stores one barcode on the
physical edition. Known box barcodes resolve fully offline.

## Import

Paste a list from your notes app, or pick a TXT/CSV export, and Movie Shelf tolerates messy
formatting (bullets, checkboxes, numbering, stray whitespace). Every line is matched against
TMDB and classified as matched automatically / ambiguous / not found / duplicate before you
commit anything.

- **Ambiguous rows** (`Nicht eindeutig erkannt`) show the first 4 TMDB candidates right in the
  review list — tap one to assign it directly.
- **Unmatched rows** (`Kein passender Titel erkannt`) offer `Film suchen` and `Serie suchen`.
- Manual search has a **Filme | Serien** toggle. TV results open a season picker
  (single / several / complete series). Movie results can be assigned as a single film or
  via **Als Filmreihe / Box Set zuordnen** when the title belongs to a TMDB collection.
- Bundle review cards show counts (`6 Filme ausgewählt`, `4 / 8 Staffeln ausgewählt`) and
  **Auswahl bearbeiten**.
- The final summary counts source entries and logical items separately (`Einträge
  verarbeitet` vs `Filme hinzugefügt` / `Staffeln hinzugefügt` / `bereits vorhanden`).
- Saving shows live progress (`n / total verarbeitet`) and never treats TMDB matching as a
  completed import. Failed rows can be retried without rematching.
- Both cases can open a dedicated **manual search screen** that's prefilled with the imported
  title, supports editing the search freely, debounces requests, and paginates results with a
  "Mehr laden" button. Picking a movie there returns you straight to the review list with that
  row marked `Manuell zugeordnet`.
- You can always explicitly continue **without** assigning a movie (`Ohne Zuordnung
  fortfahren`) — that row is marked `Ohne Zuordnung` and excluded from the import, without
  losing the original imported text.
- Nothing is saved to your collection until you choose a default status and commit — manual
  selections only live in the current import session until then.

See [docs/IMPORT.md](IMPORT.md) for the full parsing/matching/manual-resolution details.

## Settings

Metadata language/region display, database movie count, an image-cache clear button, live
TMDB/UPCitemdb configuration status (without ever showing the actual secret token), app
version, a link to themoviedb.org, and the required TMDB attribution notice.
