import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:movie_shelf/core/errors/app_exception.dart';
import 'package:movie_shelf/core/network/network_info.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_api_client.dart';
import 'package:movie_shelf/core/network/tmdb/tmdb_models.dart';
import 'package:movie_shelf/core/network/upcitemdb/upcitemdb_client.dart';
import 'package:movie_shelf/core/network/upcitemdb/upcitemdb_models.dart';
import 'package:movie_shelf/features/scanner/data/barcode_repository.dart';
import 'package:movie_shelf/core/network/upcmdb/upcmdb_client.dart';
import 'package:movie_shelf/features/scanner/domain/barcode_lookup_result.dart';
import 'package:movie_shelf/features/scanner/domain/barcode_lookup_service.dart';
import 'package:movie_shelf/features/scanner/domain/barcode_resolver.dart';
import 'package:movie_shelf/features/scanner/domain/scanned_code.dart';

import '../../fixtures/movie_fixtures.dart';
import 'barcode_resolver_test.mocks.dart';

@GenerateMocks([BarcodeRepository, BarcodeProvider, TmdbApiClient, NetworkInfo])
void main() {
  late MockBarcodeRepository barcodeRepository;
  late MockBarcodeProvider barcodeProvider;
  late MockTmdbApiClient tmdbApiClient;
  late MockNetworkInfo networkInfo;
  late BarcodeResolver resolver;
  late String gtin;

  setUp(() {
    gtin = '500000000000${gtinCheckDigit('500000000000')}';
    barcodeRepository = MockBarcodeRepository();
    barcodeProvider = MockBarcodeProvider();
    tmdbApiClient = MockTmdbApiClient();
    networkInfo = MockNetworkInfo();
    resolver = BarcodeResolver(
      barcodeRepository: barcodeRepository,
      barcodeProvider: barcodeProvider,
      tmdbApiClient: tmdbApiClient,
      networkInfo: networkInfo,
    );
  });

  test(
    'resolves immediately from the local mapping without any network call',
    () async {
      final movie = ownedMovieFixture();
      when(
        barcodeRepository.resolveMovie('4001234567890'),
      ).thenAnswer((_) async => movie);

      final result = await resolver.resolve('4001234567890');

      expect(result, isA<BarcodeKnownMovie>());
      expect((result as BarcodeKnownMovie).movie.id, movie.id);
      verifyNever(networkInfo.isConnected);
    },
  );

  test(
    'reports that a connection is required for an unknown barcode while offline',
    () async {
      when(barcodeRepository.resolveMovie(any)).thenAnswer((_) async => null);
      when(networkInfo.isConnected).thenAnswer((_) async => false);

      final result = await resolver.resolve(gtin);

      expect(result, isA<BarcodeUnresolvedOffline>());
    },
  );

  test('resolves an unknown barcode via UPCitemdb and TMDB search', () async {
    when(barcodeRepository.resolveMovie(any)).thenAnswer((_) async => null);
    when(networkInfo.isConnected).thenAnswer((_) async => true);
    when(barcodeProvider.lookup(any)).thenAnswer(
      (_) async => const UpcLookupResult(
        code: 'OK',
        items: [UpcItem(title: 'Der Pate DVD')],
      ),
    );
    when(tmdbApiClient.searchMovies(any)).thenAnswer(
      (_) async => const [TmdbSearchResult(id: 42, title: 'Der Pate')],
    );

    final result = await resolver.resolve(gtin);

    expect(result, isA<BarcodeNeedsConfirmation>());
    final confirmation = result as BarcodeNeedsConfirmation;
    expect(confirmation.candidates.first.result.id, 42);
  });

  test(
    'reports no match when the barcode provider has no product for this barcode',
    () async {
      when(barcodeRepository.resolveMovie(any)).thenAnswer((_) async => null);
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      when(
        barcodeProvider.lookup(any),
      ).thenThrow(const BarcodeNotFoundException());

      final result = await resolver.resolve(gtin);

      expect(result, isA<BarcodeProductUnknown>());
    },
  );

  test('a local mapping skips UPCMDB', () async {
    final movie = ownedMovieFixture();
    when(barcodeRepository.resolveMovie(any)).thenAnswer((_) async => movie);
    final upcmdb = _CountingUpcmdb();
    final localResolver = BarcodeResolver(
      barcodeRepository: barcodeRepository,
      barcodeProvider: barcodeProvider,
      tmdbApiClient: tmdbApiClient,
      networkInfo: networkInfo,
      lookupService: BarcodeLookupService(
        upcItemDb: barcodeProvider,
        upcmdb: upcmdb,
      ),
    );

    final result = await localResolver.resolve(gtin);

    expect(result, isA<BarcodeKnownMovie>());
    expect(upcmdb.calls, 0);
    verifyNever(barcodeProvider.lookup(any));
  });

  test('an IMDb id from UPCMDB resolves through TMDB find', () async {
    when(barcodeRepository.resolveMovie(any)).thenAnswer((_) async => null);
    when(networkInfo.isConnected).thenAnswer((_) async => true);
    when(tmdbApiClient.findByImdbId('tt0133093')).thenAnswer(
      (_) async => const TmdbExternalMatch(
        movie: TmdbSearchResult(id: 603, title: 'The Matrix'),
      ),
    );
    final localResolver = BarcodeResolver(
      barcodeRepository: barcodeRepository,
      barcodeProvider: barcodeProvider,
      tmdbApiClient: tmdbApiClient,
      networkInfo: networkInfo,
      lookupService: BarcodeLookupService(
        upcItemDb: barcodeProvider,
        upcmdb: _CountingUpcmdb(
          const UpcmdbFound(
            UpcmdbRecord(
              title: 'The Matrix',
              imdbId: 'tt0133093',
              mediaType: 'movie',
            ),
          ),
        ),
      ),
    );

    final result = await localResolver.resolve(gtin);

    expect(result, isA<BarcodeNeedsConfirmation>());
    expect(
      (result as BarcodeNeedsConfirmation).candidates.first.confidence,
      0.99,
    );
    verifyNever(tmdbApiClient.searchMovies(any));
    verifyNever(barcodeProvider.lookup(any));
  });

  test('a physical UPCMDB title is searched as the cleaned movie title', () async {
    when(barcodeRepository.resolveMovie(any)).thenAnswer((_) async => null);
    when(networkInfo.isConnected).thenAnswer((_) async => true);
    when(tmdbApiClient.searchMovies('Interstellar', year: 2014)).thenAnswer(
      (_) async => const [TmdbSearchResult(id: 157336, title: 'Interstellar')],
    );
    final localResolver = BarcodeResolver(
      barcodeRepository: barcodeRepository,
      barcodeProvider: barcodeProvider,
      tmdbApiClient: tmdbApiClient,
      networkInfo: networkInfo,
      lookupService: BarcodeLookupService(
        upcItemDb: barcodeProvider,
        upcmdb: _CountingUpcmdb(
          const UpcmdbFound(
            UpcmdbRecord(
              title: 'Interstellar 4K UHD Steelbook Limited Edition Blu-ray',
              year: 2014,
            ),
          ),
        ),
      ),
    );

    final result = await localResolver.resolve(gtin);

    expect(result, isA<BarcodeNeedsConfirmation>());
    verify(tmdbApiClient.searchMovies('Interstellar', year: 2014)).called(1);
    verifyNever(barcodeProvider.lookup(any));
  });

  test(
    'a distributor suffix still confirms the localized TMDB movie',
    () async {
      when(barcodeRepository.resolveMovie(any)).thenAnswer((_) async => null);
      when(networkInfo.isConnected).thenAnswer((_) async => true);
      const cleaned = 'Pirates Of The Caribbean - Am Ende Der Welt';
      when(tmdbApiClient.searchMovies(cleaned)).thenAnswer(
        (_) async => [
          TmdbSearchResult(
            id: 285,
            title: 'Pirates of the Caribbean - Am Ende der Welt',
            originalTitle: "Pirates of the Caribbean: At World's End",
            releaseDate: DateTime(2007),
          ),
        ],
      );
      final localResolver = BarcodeResolver(
        barcodeRepository: barcodeRepository,
        barcodeProvider: barcodeProvider,
        tmdbApiClient: tmdbApiClient,
        networkInfo: networkInfo,
        lookupService: BarcodeLookupService(
          upcItemDb: barcodeProvider,
          upcmdb: _CountingUpcmdb(
            const UpcmdbFound(
              UpcmdbRecord(
                title:
                    'Pirates Of The Caribbean - Am Ende Der Welt By Buena Vista Home Entertainment.',
                publisher: 'Buena Vista Home Entertainment',
              ),
            ),
          ),
        ),
      );

      final result = await localResolver.resolve(gtin);

      expect(result, isA<BarcodeNeedsConfirmation>());
      final confirmation = result as BarcodeNeedsConfirmation;
      expect(confirmation.searchTitle, cleaned);
      expect(confirmation.candidates.single.result.id, 285);
      expect(confirmation.candidates.single.confidence, greaterThan(0.9));
      verify(tmdbApiClient.searchMovies(cleaned)).called(1);
      verifyNever(
        tmdbApiClient.searchMovies(
          'Pirates Of The Caribbean - Am Ende Der Welt By Buena Vista Home Entertainment.',
        ),
      );
      verifyNever(barcodeProvider.lookup(any));
    },
  );

  test('an empty year-filtered search is retried without the year', () async {
    when(barcodeRepository.resolveMovie(any)).thenAnswer((_) async => null);
    when(networkInfo.isConnected).thenAnswer((_) async => true);
    when(tmdbApiClient.searchMovies('Heat', year: 1995)).thenAnswer(
      (_) async => const [],
    );
    when(tmdbApiClient.searchMovies('Heat')).thenAnswer(
      (_) async => [
        TmdbSearchResult(
          id: 949,
          title: 'Heat',
          releaseDate: DateTime(1995),
        ),
      ],
    );
    final localResolver = BarcodeResolver(
      barcodeRepository: barcodeRepository,
      barcodeProvider: barcodeProvider,
      tmdbApiClient: tmdbApiClient,
      networkInfo: networkInfo,
      lookupService: BarcodeLookupService(
        upcItemDb: barcodeProvider,
        upcmdb: _CountingUpcmdb(
          const UpcmdbFound(UpcmdbRecord(title: 'Heat', year: 1995)),
        ),
      ),
    );

    final result = await localResolver.resolve(gtin);

    expect(result, isA<BarcodeNeedsConfirmation>());
    verify(tmdbApiClient.searchMovies('Heat', year: 1995)).called(1);
    verify(tmdbApiClient.searchMovies('Heat')).called(1);
  });

  test('a trilogy title is not saved as the first movie', () async {
    when(barcodeRepository.resolveMovie(any)).thenAnswer((_) async => null);
    when(networkInfo.isConnected).thenAnswer((_) async => true);
    when(tmdbApiClient.searchCollections(any)).thenAnswer((_) async => []);
    final localResolver = BarcodeResolver(
      barcodeRepository: barcodeRepository,
      barcodeProvider: barcodeProvider,
      tmdbApiClient: tmdbApiClient,
      networkInfo: networkInfo,
      lookupService: BarcodeLookupService(
        upcItemDb: barcodeProvider,
        upcmdb: _CountingUpcmdb(
          const UpcmdbFound(UpcmdbRecord(title: 'The Dark Knight Trilogy')),
        ),
      ),
    );

    final result = await localResolver.resolve(gtin);

    expect(result, isA<BarcodeWeakMatch>());
    verifyNever(tmdbApiClient.searchMovies(any));
  });
}

class _CountingUpcmdb implements UpcmdbApi {
  _CountingUpcmdb([this.call = const UpcmdbNotFound()]);

  final UpcmdbCall call;
  int calls = 0;

  @override
  Future<UpcmdbCall> lookupGtin(String gtin) async {
    calls += 1;
    return call;
  }
}
