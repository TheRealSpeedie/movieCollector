# External APIs

Movie Shelf calls two external services. Both are strictly for **enrichment/resolution**;
neither is ever the source of truth for what the user owns (see
[docs/ARCHITECTURE.md](ARCHITECTURE.md)).

## TMDB (The Movie Database)

- Base URL: `https://api.themoviedb.org/3`
- Authentication: **Bearer token** (`Authorization: Bearer <TMDB_ACCESS_TOKEN>`), TMDB's
  current recommended auth scheme for the "API Read Access Token" (distinct from the legacy
  `api_key` query-parameter scheme, which Movie Shelf does not use).
- Configured via `lib/core/network/dio_client.dart` (`buildTmdbDio`) and
  `lib/core/network/tmdb/tmdb_api_client.dart` (`TmdbApiClient`).

### Endpoints used

| Endpoint | Used for | Client method |
|---|---|---|
| `GET /search/movie` | Title search (Add Movie, Fundstück-Check title fallback, Import matching) | `TmdbApiClient.searchMovies` |
| `GET /movie/{id}` (with `append_to_response=release_dates`) | Full movie metadata + German (DE) certification extraction | `TmdbApiClient.getMovieDetails` |
| `GET /search/collection` | Suggest a TMDB movie collection for collector boxes | `TmdbApiClient.searchCollections` |
| `GET /collection/{id}` | Collection name/overview/poster + all member movies | `TmdbApiClient.getCollection` |
| `GET /search/tv` | TV series search (import, Fundstück, manual matching) | `TmdbApiClient.searchTv` |
| `GET /tv/{id}` (with `append_to_response=content_ratings`) | Series details, seasons, German content rating | `TmdbApiClient.getTvDetails` |

### Language/region behavior

Every request sends `language=de-DE` and, for search, `region=DE` where the endpoint supports
it. If a movie or TV series German overview is empty, details calls re-fetch with
`language=en-US` and merge the English overview while preferring the German title/name when
present.

TV content ratings use `append_to_response=content_ratings` and pick the DE `rating` when
available. Individual episodes are neither fetched nor stored — ownership is season-level.

### Certification (age rating)

TMDB doesn't return a single "age rating" field. `getMovieDetails` requests
`append_to_response=release_dates`, then `_extractGermanCertification` scans the payload for
the entry where `iso_3166_1 == "DE"` and returns the first non-empty `certification` value
found for that country (this is the FSK rating in Germany). If Germany has no certification
data for a title, `certification` stays `null` and the UI simply omits the FSK chip — it
never crashes or shows a placeholder.

### Rate limiting & caching

TMDB does not publish a hard fixed rate limit for the current API; Movie Shelf still treats
HTTP `429` responses as a first-class case (`RateLimitException`, mapped in
`DioClient.mapDioException`) so the UI can show a clear "try again later" message rather than
a raw error. Beyond that, the app avoids unnecessary calls entirely:

- Movie metadata is fetched once on add and cached in SQLite; the details screen offers an
  explicit "refresh metadata" action instead of auto-refreshing.
- Collections are only re-fetched after `AppConstants.collectionStaleAfter` (7 days) unless a
  `forceRefresh` is explicitly requested (triggered automatically alongside a metadata
  refresh of one of its movies).

## UPCitemdb

- Trial (free, default) base URL: `https://api.upcitemdb.com/prod/trial`
- Paid ("3scale") base URL: `https://api.upcitemdb.com/prod/v1`
- Configured via `buildUpcItemDbDio` in `lib/core/network/dio_client.dart` and
  `lib/core/network/upcitemdb/upcitemdb_client.dart` (`UpcItemDbClient implements
  BarcodeProvider`).

### Endpoint used

| Endpoint | Used for |
|---|---|
| `GET /lookup?upc={barcode}` | Resolve a scanned EAN/UPC to a product title |

### Authentication

The free trial tier requires no authentication at all — Movie Shelf uses it by default when
`UPCITEMDB_USER_KEY` is empty. If you configure a paid-tier key, the client switches base URL
to the `prod/v1` host and sends the `user_key` / `key_type` headers UPCitemdb's paid plans
require (`Env.isUpcItemDbProConfigured` decides which base URL/headers to use — see
`lib/core/providers/core_providers.dart`).

### Rate limiting

The free trial tier is rate-limited by UPCitemdb (limits are controlled by UPCitemdb and can
change without notice — the app deliberately does **not** hard-code an assumed request quota
into its business logic). Instead, any `429` response is mapped to the same
`RateLimitException` as TMDB and surfaced with a generic, honest "rate limit reached, try
again later" message. The Settings screen shows which tier is currently active so the user
understands why lookups might occasionally be rate-limited.

### Provider abstraction

`BarcodeProvider` is a one-method abstract class (`Future<UpcLookupResult> lookup(String
barcode)`). `BarcodeResolver` and the rest of the app depend only on this interface, not on
`UpcItemDbClient` directly, so a different barcode/product-lookup service could replace
UPCitemdb later by implementing the same interface and swapping the provider in
`lib/core/providers/core_providers.dart` — no changes needed in `BarcodeResolver` or the UI.

## Error handling

`DioClient` (used by both TMDB and UPCitemdb clients) centralizes all network error mapping
into the sealed `AppException` hierarchy (`lib/core/errors/app_exception.dart`):

| Condition | Exception | User-facing meaning |
|---|---|---|
| `NetworkInfo.isConnected == false` (checked before the request) | `NoInternetException` | No internet connection |
| Dio timeout / connection error | `NoInternetException` | Treated the same as "no internet" — retrying makes sense either way |
| HTTP 401 / 403 | `InvalidApiConfigException` | Invalid/missing API token |
| HTTP 404 | `MovieNotFoundException` | Movie/resource not found |
| HTTP 429 | `RateLimitException` | Rate limit reached |
| HTTP 5xx | `ApiUnavailableException` | Service temporarily unavailable |
| Anything else | `UnknownAppException` | Generic fallback |

`BarcodeNotFoundException` and `DuplicateMovieException`/`DuplicateBarcodeException` are
raised by repository/resolver logic (not by `DioClient`) for domain-specific situations (a
barcode provider explicitly reporting "not found", or the app detecting a duplicate before
even making a request).

Every screen renders these via `shared/widgets/error_view.dart`'s `describeError()` helper,
which maps each `AppException` to its German `message` and falls back to a generic message
for anything unexpected — raw exception text/stack traces are never shown to the user.

## Key-security limitations in mobile apps

Both API credentials are compiled into the app binary via `--dart-define-from-file` at build
time (see [docs/SETUP.md](SETUP.md)). This is standard for hobby/personal Flutter apps but
**does not provide real secrecy**: a sufficiently motivated user can extract embedded strings
from a compiled APK/IPA. This is an acceptable tradeoff for a private, personal collection
app using free-tier keys with no billing risk. If Movie Shelf is ever distributed publicly,
proxy TMDB/UPCitemdb requests through a small backend that holds the real credentials, and
have the app talk to your backend instead of embedding keys directly.
