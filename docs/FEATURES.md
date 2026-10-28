# Features

What Movie Shelf does, from the user's side. The interface is German; screen names are given as they appear.

## Tabs

**Home · Sammlung · Entdecken · Fundstück · Mehr.** Detail screens (movie, series, search, import, settings) open above the tabs.

## First start

Onboarding asks where the collection should live (only on this device, Movie Shelf Cloud, or your own server), your region, audio and subtitle languages and preferred formats (all skippable), offers to connect a server, and suggests a first step: scan a disc, import a list, or search a film. Installs that already have data skip it.

## Fundstück-Check

The scanner opens straight into the camera and reads EAN-13, EAN-8, UPC-A and UPC-E. **Titel eingeben** works without a camera.

The result says, in plain words, which case applies, marked as **exact** (the barcode is known) or **probable** (matched by title):

- you own exactly this edition, or another edition of the film (with how they differ),
- it is on your wishlist (with your maximum price, if set),
- it fills a gap in a series you collect, or a missing season,
- you have it digitally on your server,
- it is new to you.

Box sets and season boxes show how many contents you already own. Known barcodes work offline; unknown ones scanned offline are queued under **Zuletzt gescannt** and looked up when the app is online again. Lookups ask the edition catalog first, then barcode services.

## Sammlung

**Filme | Serien**, grid or list, search, status filters (Gekauft, Wunschliste, Offen) and sorting. Series show `x / y Staffeln gekauft`; seasons have their own status and copies, and Specials never count towards "complete".

## Movie page

Poster, metadata, FSK rating, and everything about this one title in one place:

- **Meine Exemplare**: every edition (format, region, audio and subtitle languages, publisher) with its copies (condition, location, price, purchase date, notes). In a household, other members' copies show who owns them and cannot be changed; your own copies can be private.
- **Weitere Ausgaben**: other releases from the edition catalog, with how they differ from yours (resolution, extra or missing languages, region), what is unknown, and whether an entry is still unreviewed. **Übernehmen** keeps it on the device.
- **Persönlich**: watched, how often and when, rating, favourite, tags, wishlist with maximum price.
- **Wo kann ich das schauen?**: your server's versions with languages, streaming offers in your region with a "Stand" date, rent and buy.
- The series progress of the franchise the film belongs to.

Removing a film that others in your household own removes only your copies.

## Entdecken

- **Was soll ich schauen?**: suggestions from your server, your streaming subscriptions and your shelf, each with reasons. Filters for source, genre, length, unwatched and original language. Type a wish in plain words; the device understands genres, length, decades and "nochmal". **KI-Vorschläge** is optional: after consent, a wish the filters cannot express (for example "ruhig, wie Arrival") is sent with a shortlist of up to 40 titles to your server's or the Cloud's AI. Without it, or when it fails, the device's own suggestions remain.
- Missing parts of franchises, missing seasons, the wishlist, and all franchises.

## Import

Paste a list from your notes or pick a TXT or CSV file. Every line is matched with TMDB and reviewed before anything is saved: ambiguous lines offer candidates, unmatched ones a manual search for films or series, box sets and series can be assigned as bundles. Failed lines can be retried. Details: [IMPORT.md](IMPORT.md).

## Playback (with a Movie Shelf Server)

Play files from your server with direct play, remux or conversion as the device needs. Audio and subtitles follow your preferences (languages, original language, subtitles only when needed, hearing-impaired, audio description). In the player: switch tracks, search and download subtitles, shift them, report wrong ones. Progress is saved per person; positions that could not be sent while offline are delivered later. The phone can control the TV app.

## Mehr

- **Daten & Synchronisation**: storage location and moving between them (with a snapshot first and a count check after), sync status with waiting changes, conflicts with both values to choose from, **Haushalt**, backup, export and restore.
- **Movie Shelf Cloud**: sign up, confirm e-mail, reset password, subscription, devices, export, sign out, delete the account.
- **Haushalt**: invite with a code, join, leave, remove members. Copies, editions and the wishlist are shared; what each person watched and rated stays theirs.
- **Movie Shelf Server**: connect by QR code or network discovery, browse libraries, versions, pairing a TV.
- **Sprache & Untertitel**, **Streamingdienste**, **Einstellungen** (metadata language, API status, cache, TMDB attribution).

## Android TV

A separate flavor with Start, Filme, Serien, Weiterschauen, Suche, Profile (with PIN) and Einstellungen, operated with the remote. It pairs through a phone.
