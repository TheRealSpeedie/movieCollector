import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/core/matching/movie_matcher.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_api_client.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/features/editions/data/physical_edition_repository.dart';
import 'package:movie_shelf/features/import/data/import_repository.dart';
import 'package:movie_shelf/features/import/domain/import_models.dart';
import 'package:movie_shelf/features/movies/data/movie_repository.dart';
import 'package:movie_shelf/features/tv/data/tv_repository.dart';
import 'package:movie_shelf/shared/models/collection_status.dart';
import 'package:movie_shelf/shared/models/match_candidate.dart';
import 'package:movie_shelf/shared/models/movie.dart';
import 'package:movie_shelf/shared/models/physical_edition.dart';
import 'package:movie_shelf/shared/models/physical_edition_kind.dart';
import 'package:movie_shelf/shared/models/tv_season.dart';
import 'package:movie_shelf/shared/models/tv_series.dart';
import 'package:movie_shelf/shared/models/tv_series_with_seasons.dart';

import '../../fixtures/movie_fixtures.dart';
import 'import_repository_test.mocks.dart';

/// Matcher stub that returns a fixed, pre-ordered candidate list regardless
/// of the query, so tests can control confidence values deterministically
/// instead of depending on the real similarity math.
class _FixedMatcher extends MovieMatcher {
  const _FixedMatcher(this._candidates, [this._tvCandidates = const []]);

  final List<MatchCandidate> _candidates;
  final List<TvMatchCandidate> _tvCandidates;

  @override
  List<MatchCandidate> rank(
    String query,
    List<TmdbSearchResult> candidates, {
    int? year,
  }) => _candidates;

  @override
  List<TvMatchCandidate> rankTv(
    String query,
    List<TmdbTvSearchResult> candidates, {
    int? year,
  }) => _tvCandidates.isEmpty
      ? super.rankTv(query, candidates, year: year)
      : _tvCandidates;
}

const _goblet = TmdbSearchResult(
  id: 673,
  title: 'Harry Potter und der Feuerkelch',
  originalTitle: 'Harry Potter and the Goblet of Fire',
);
const _prisoner = TmdbSearchResult(
  id: 672,
  title: 'Harry Potter und der Gefangene von Askaban',
);
const _phoenix = TmdbSearchResult(
  id: 674,
  title: 'Harry Potter und der Orden des Phönix',
);
const _halfBlood = TmdbSearchResult(
  id: 675,
  title: 'Harry Potter und der Halbblutprinz',
);
const _deathly1 = TmdbSearchResult(
  id: 676,
  title: 'Harry Potter und die Heiligtümer des Todes 1',
);
const _deathly2 = TmdbSearchResult(
  id: 677,
  title: 'Harry Potter und die Heiligtümer des Todes 2',
);

@GenerateMocks([
  TmdbApiClient,
  MovieRepository,
  TvRepository,
  PhysicalEditionRepository,
])
void main() {
  late MockTmdbApiClient tmdb;
  late MockMovieRepository movieRepository;

  setUp(() {
    tmdb = MockTmdbApiClient();
    movieRepository = MockMovieRepository();
    when(movieRepository.getMovieByTmdbId(any)).thenAnswer((_) async => null);
    when(tmdb.getMovieDetails(any)).thenAnswer((invocation) async {
      final id = invocation.positionalArguments.first as int;
      return TmdbMovieDetails(id: id, title: 'Movie $id');
    });
    when(
      movieRepository.upsertFromDetails(
        any,
        status: anyNamed('status'),
        syncCollection: anyNamed('syncCollection'),
      ),
    ).thenAnswer((invocation) async {
      final details = invocation.positionalArguments.first as TmdbMovieDetails;
      return MovieUpsertResult(
        movie: buildMovie(
          id: details.id,
          tmdbId: details.id,
          title: details.title,
        ),
        kind: MoviePersistKind.added,
      );
    });
    when(movieRepository.applyImportedStatus(any, any)).thenAnswer((
      invocation,
    ) async {
      final movie = invocation.positionalArguments.first as Movie;
      return MovieUpsertResult(
        movie: movie,
        kind: MoviePersistKind.alreadyExists,
      );
    });
  });

  ImportRepository buildRepository(
    List<MatchCandidate> fixedCandidates, {
    List<TvMatchCandidate> tvCandidates = const [],
    TvRepository? tvRepository,
    PhysicalEditionRepository? editionRepository,
  }) {
    return ImportRepository(
      tmdb,
      movieRepository,
      matcher: _FixedMatcher(fixedCandidates, tvCandidates),
      tvRepository: tvRepository,
      editionRepository: editionRepository,
      wait: (_) async {},
    );
  }

  group('buildRows', () {
    test('a single confident candidate is matched automatically', () async {
      when(tmdb.searchMovies(any)).thenAnswer((_) async => [_goblet]);
      final repository = buildRepository([
        const MatchCandidate(result: _goblet, confidence: 0.95),
      ]);

      final rows = await repository.buildRows(['Harry Potter 4']);

      expect(rows.single.status, ImportRowStatus.matchedAutomatically);
      expect(rows.single.selectedCandidate, _goblet);
    });

    test(
      'multiple close candidates below the confidence threshold are ambiguous '
      'and expose all ranked candidates for the UI to truncate to 4',
      () async {
        when(tmdb.searchMovies(any)).thenAnswer(
          (_) async => [
            _goblet,
            _prisoner,
            _phoenix,
            _halfBlood,
            _deathly1,
            _deathly2,
          ],
        );
        final repository = buildRepository([
          const MatchCandidate(result: _goblet, confidence: 0.7),
          const MatchCandidate(result: _prisoner, confidence: 0.68),
          const MatchCandidate(result: _phoenix, confidence: 0.65),
          const MatchCandidate(result: _halfBlood, confidence: 0.62),
          const MatchCandidate(result: _deathly1, confidence: 0.6),
          const MatchCandidate(result: _deathly2, confidence: 0.58),
        ]);

        final rows = await repository.buildRows(['Harry Potter 4']);

        expect(rows.single.status, ImportRowStatus.ambiguous);
        expect(rows.single.candidates.length, 6);
        expect(rows.single.candidates.first.result, _goblet);
        expect(rows.single.selectedCandidate, isNull);
      },
    );

    test(
      'low-confidence candidates below the acceptable threshold count as not found',
      () async {
        when(tmdb.searchMovies(any)).thenAnswer((_) async => [_goblet]);
        final repository = buildRepository([
          const MatchCandidate(result: _goblet, confidence: 0.2),
        ]);

        final rows = await repository.buildRows(['Some weird movie name']);

        expect(rows.single.status, ImportRowStatus.notFound);
        expect(rows.single.selectedCandidate, isNull);
      },
    );

    test(
      'zero TMDB results are treated as not found without candidates',
      () async {
        when(tmdb.searchMovies(any)).thenAnswer((_) async => []);
        final repository = buildRepository(const []);

        final rows = await repository.buildRows([
          'Some completely unknown title',
        ]);

        expect(rows.single.status, ImportRowStatus.notFound);
        expect(rows.single.candidates, isEmpty);
      },
    );

    test('a match that already exists locally is a duplicate', () async {
      when(tmdb.searchMovies(any)).thenAnswer((_) async => [_goblet]);
      when(
        movieRepository.getMovieByTmdbId(_goblet.id),
      ).thenAnswer((_) async => buildMovie(tmdbId: _goblet.id));
      final repository = buildRepository([
        const MatchCandidate(result: _goblet, confidence: 0.95),
      ]);

      final rows = await repository.buildRows(['Harry Potter 4']);

      expect(rows.single.status, ImportRowStatus.duplicate);
      expect(rows.single.existingLocalMovie, isNotNull);
    });
  });

  group('commit', () {
    test(
      'only saves rows with a selected movie and excludes skipped unresolved rows',
      () async {
        final repository = buildRepository(const []);

        final rows = [
          const ImportRow(
            index: 0,
            rawLine: 'Harry Potter 4',
            parsedTitle: 'Harry Potter 4',
            status: ImportRowStatus.matchedManually,
            selectedCandidate: _goblet,
          ),
          const ImportRow(
            index: 1,
            rawLine: 'Some weird title',
            parsedTitle: 'Some weird title',
            status: ImportRowStatus.skipped,
          ),
          ImportRow(
            index: 2,
            rawLine: 'Already owned movie',
            parsedTitle: 'Already owned movie',
            status: ImportRowStatus.duplicate,
            selectedCandidate: _prisoner,
            existingLocalMovie: buildMovie(tmdbId: _prisoner.id),
          ),
          const ImportRow(
            index: 3,
            rawLine: 'Unresolved ambiguous title',
            parsedTitle: 'Unresolved ambiguous title',
            status: ImportRowStatus.ambiguous,
          ),
        ];
        when(
          movieRepository.getMovieByTmdbId(_prisoner.id),
        ).thenAnswer((_) async => buildMovie(id: 20, tmdbId: _prisoner.id));

        final report = await repository.commit(rows, CollectionStatus.owned);

        expect(report.imported, 1);
        expect(report.skipped, 2);
        expect(report.failed, 0);
        expect(report.alreadyExisted, 1);
        verify(
          movieRepository.upsertFromDetails(
            any,
            status: CollectionStatus.owned,
            syncCollection: false,
          ),
        ).called(1);
        verify(
          movieRepository.applyImportedStatus(any, CollectionStatus.owned),
        ).called(1);
      },
    );

    test('records a failure reason when saving a movie throws', () async {
      when(
        tmdb.getMovieDetails(_goblet.id),
      ).thenThrow(const ApiUnavailableException());
      final repository = buildRepository(const []);

      final report = await repository.commit(const [
        ImportRow(
          index: 0,
          rawLine: 'Harry Potter 4',
          parsedTitle: 'Harry Potter 4',
          status: ImportRowStatus.matchedAutomatically,
          selectedCandidate: _goblet,
        ),
      ], CollectionStatus.owned);

      expect(report.imported, 0);
      expect(report.failed, 1);
      expect(report.failures.single.title, 'Harry Potter 4');
      expect(
        report.failures.single.reason,
        'Der Dienst ist derzeit nicht erreichbar.',
      );
      expect(
        report.failures.single.category,
        ImportSaveFailureCategory.network,
      );
    });

    test(
      'retries once after a TMDB rate limit, then stops remaining rows',
      () async {
        var gobletCalls = 0;
        when(tmdb.getMovieDetails(_goblet.id)).thenAnswer((_) async {
          gobletCalls++;
          throw const RateLimitException();
        });
        final repository = buildRepository(const []);

        final report = await repository.commit(const [
          ImportRow(
            index: 0,
            rawLine: 'Harry Potter 4',
            parsedTitle: 'Harry Potter 4',
            status: ImportRowStatus.matchedAutomatically,
            selectedCandidate: _goblet,
          ),
          ImportRow(
            index: 1,
            rawLine: 'Harry Potter 3',
            parsedTitle: 'Harry Potter 3',
            status: ImportRowStatus.matchedAutomatically,
            selectedCandidate: _prisoner,
          ),
        ], CollectionStatus.owned);

        expect(gobletCalls, 2);
        expect(report.imported, 0);
        expect(report.failed, 2);
        expect(report.failures.map((f) => f.title), [
          'Harry Potter 4',
          'Harry Potter 3',
        ]);
        verifyNever(tmdb.getMovieDetails(_prisoner.id));
      },
    );

    test(
      'counts an already stored movie as already existed, not failed',
      () async {
        when(
          movieRepository.getMovieByTmdbId(_goblet.id),
        ).thenAnswer((_) async => buildMovie(tmdbId: _goblet.id));
        final repository = buildRepository(const []);

        final report = await repository.commit(const [
          ImportRow(
            index: 0,
            rawLine: 'Harry Potter 4',
            parsedTitle: 'Harry Potter 4',
            status: ImportRowStatus.matchedAutomatically,
            selectedCandidate: _goblet,
          ),
        ], CollectionStatus.owned);

        expect(report.imported, 0);
        expect(report.failed, 0);
        expect(report.alreadyExisted, 1);
        verifyNever(
          movieRepository.upsertFromDetails(
            any,
            status: anyNamed('status'),
            syncCollection: anyNamed('syncCollection'),
          ),
        );
      },
    );

    test('retry onlyIndexes persists only the requested rows', () async {
      final repository = buildRepository(const []);
      final rows = const [
        ImportRow(
          index: 0,
          rawLine: 'Harry Potter 4',
          parsedTitle: 'Harry Potter 4',
          status: ImportRowStatus.matchedAutomatically,
          selectedCandidate: _goblet,
        ),
        ImportRow(
          index: 1,
          rawLine: 'Harry Potter 3',
          parsedTitle: 'Harry Potter 3',
          status: ImportRowStatus.matchedAutomatically,
          selectedCandidate: _prisoner,
        ),
      ];

      final report = await repository.commit(
        rows,
        CollectionStatus.owned,
        onlyIndexes: {1},
      );

      expect(report.outcomes, hasLength(1));
      expect(report.outcomes.single.rowIndex, 1);
      verify(tmdb.getMovieDetails(_prisoner.id)).called(1);
      verifyNever(tmdb.getMovieDetails(_goblet.id));
    });
  });

  group('bundles', () {
    const supernatural = TmdbTvSearchResult(id: 1622, name: 'Supernatural');
    final tvDetails = TmdbTvDetails(
      id: 1622,
      name: 'Supernatural',
      seasons: [
        const TmdbTvSeason(id: 0, seasonNumber: 0, name: 'Specials'),
        for (var i = 1; i <= 15; i++)
          TmdbTvSeason(id: i, seasonNumber: i, name: 'Staffel $i'),
      ],
    );
    final sharknadoCollection = TmdbCollectionDetails(
      id: 11,
      name: 'Sharknado Collection',
      parts: const [
        TmdbCollectionMovieRef(id: 1, title: 'Sharknado'),
        TmdbCollectionMovieRef(id: 2, title: 'Sharknado 2'),
        TmdbCollectionMovieRef(id: 3, title: 'Sharknado 3'),
        TmdbCollectionMovieRef(id: 4, title: 'Sharknado 4'),
        TmdbCollectionMovieRef(id: 5, title: 'Sharknado 5'),
        TmdbCollectionMovieRef(id: 6, title: 'The Last Sharknado'),
      ],
    );

    test(
      'movie box preselects all collection parts but stays ambiguous',
      () async {
        when(tmdb.searchCollections(any)).thenAnswer(
          (_) async => const [
            TmdbCollectionSearchResult(id: 11, name: 'Sharknado Collection'),
          ],
        );
        when(
          tmdb.getCollection(11),
        ).thenAnswer((_) async => sharknadoCollection);
        final repository = buildRepository(const []);

        final rows = await repository.buildRows(["Sharknado Collector's Box"]);
        final target = rows.single.target as ImportTargetMovieBundle;
        expect(rows.single.status, ImportRowStatus.ambiguous);
        expect(target.selectedTmdbIds, [1, 2, 3, 4, 5, 6]);
      },
    );

    test(
      'complete series preselects regular seasons and excludes specials',
      () async {
        when(tmdb.searchTv(any)).thenAnswer((_) async => [supernatural]);
        when(tmdb.getTvDetails(1622)).thenAnswer((_) async => tvDetails);
        final repository = buildRepository(
          const [],
          tvCandidates: const [
            TvMatchCandidate(result: supernatural, confidence: 0.95),
          ],
        );

        final rows = await repository.buildRows([
          'Supernatural Complete Series',
        ]);
        final target = rows.single.target as ImportTargetCompleteTvSeries;
        expect(target.selectedSeasonNumbers, isNot(contains(0)));
        expect(target.selectedSeasonNumbers, [for (var i = 1; i <= 15; i++) i]);
      },
    );

    test('season range preselects the parsed seasons', () async {
      when(tmdb.searchTv(any)).thenAnswer((_) async => [supernatural]);
      when(tmdb.getTvDetails(1622)).thenAnswer((_) async => tvDetails);
      final repository = buildRepository(
        const [],
        tvCandidates: const [
          TvMatchCandidate(result: supernatural, confidence: 0.95),
        ],
      );

      final rows = await repository.buildRows(['Supernatural Staffel 1-5']);
      final target = rows.single.target as ImportTargetTvSeasonBundle;
      expect(target.selectedSeasonNumbers, [1, 2, 3, 4, 5]);
    });

    test(
      'one movie bundle row creates multiple movies and skips owned ones',
      () async {
        when(
          movieRepository.getMovieByTmdbId(1),
        ).thenAnswer((_) async => buildMovie(id: 10, tmdbId: 1));
        when(
          movieRepository.getMovieByTmdbId(2),
        ).thenAnswer((_) async => buildMovie(id: 11, tmdbId: 2));
        when(movieRepository.getMovieByTmdbId(3)).thenAnswer((_) async => null);
        when(movieRepository.getMovieByTmdbId(4)).thenAnswer((_) async => null);
        final editions = MockPhysicalEditionRepository();
        when(
          editions.createEdition(
            kind: anyNamed('kind'),
            productTitle: anyNamed('productTitle'),
            tmdbCollectionId: anyNamed('tmdbCollectionId'),
            movieIds: anyNamed('movieIds'),
          ),
        ).thenAnswer(
          (_) async => PhysicalEditionContents(
            id: 1,
            kind: PhysicalEditionKind.movieBundle,
            createdAt: DateTime(2024),
          ),
        );
        final repository = buildRepository(
          const [],
          editionRepository: editions,
        );

        final report = await repository.commit([
          ImportRow(
            index: 0,
            rawLine: "Sharknado Collector's Box",
            parsedTitle: 'Sharknado',
            status: ImportRowStatus.matchedManually,
            target: ImportTarget.movieBundle(
              collection: TmdbCollectionDetails(
                id: 11,
                name: 'Sharknado Collection',
                parts: sharknadoCollection.parts.take(4).toList(),
              ),
              selectedTmdbIds: const [1, 2, 3, 4],
            ),
          ),
        ], CollectionStatus.owned);

        expect(report.importedMovies, 2);
        expect(report.alreadyExisted, 2);
        expect(report.imported, 2);
      },
    );

    test('skipped bundle creates no movies or seasons', () async {
      final repository = buildRepository(const []);
      final report = await repository.commit(const [
        ImportRow(
          index: 0,
          rawLine: 'Supernatural Complete Series',
          parsedTitle: 'Supernatural',
          status: ImportRowStatus.skipped,
          target: ImportTarget.skipped(),
        ),
      ], CollectionStatus.owned);
      expect(report.imported, 0);
      expect(report.skipped, 1);
      verifyNever(
        movieRepository.upsertFromDetails(
          any,
          status: anyNamed('status'),
          syncCollection: anyNamed('syncCollection'),
        ),
      );
    });

    test('complete series commit only applies selected seasons', () async {
      final tv = MockTvRepository();
      when(
        tv.upsertFromDetails(any, seasonStatuses: anyNamed('seasonStatuses')),
      ).thenAnswer((invocation) async {
        final statuses =
            invocation.namedArguments[#seasonStatuses]
                as Map<int, CollectionStatus>;
        expect(statuses.keys, isNot(contains(0)));
        expect(statuses.length, 15);
        final now = DateTime(2024);
        return TvUpsertResult(
          saved: TvSeriesWithSeasons(
            series: TvSeries(
              id: 1,
              tmdbId: 1622,
              name: 'Supernatural',
              createdAt: now,
              updatedAt: now,
            ),
            seasons: [
              for (final number in statuses.keys)
                TvSeason(
                  id: number,
                  seriesId: 1,
                  seasonNumber: number,
                  name: 'Staffel $number',
                  status: CollectionStatus.owned,
                  createdAt: now,
                  updatedAt: now,
                ),
            ],
          ),
          seasonsAdded: statuses.length,
        );
      });
      final repository = buildRepository(const [], tvRepository: tv);

      final report = await repository.commit([
        ImportRow(
          index: 0,
          rawLine: 'Supernatural Complete Series',
          parsedTitle: 'Supernatural',
          status: ImportRowStatus.matchedManually,
          target: ImportTarget.completeTvSeries(
            series: supernatural,
            details: tvDetails,
            selectedSeasonNumbers: [for (var i = 1; i <= 15; i++) i],
          ),
        ),
      ], CollectionStatus.owned);

      expect(report.importedSeasons, 15);
      expect(report.importedMovies, 0);
    });
  });
}
