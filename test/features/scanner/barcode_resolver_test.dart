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
import 'package:movie_shelf/features/scanner/domain/barcode_lookup_result.dart';
import 'package:movie_shelf/features/scanner/domain/barcode_resolver.dart';

import '../../fixtures/movie_fixtures.dart';
import 'barcode_resolver_test.mocks.dart';

@GenerateMocks([BarcodeRepository, BarcodeProvider, TmdbApiClient, NetworkInfo])
void main() {
  late MockBarcodeRepository barcodeRepository;
  late MockBarcodeProvider barcodeProvider;
  late MockTmdbApiClient tmdbApiClient;
  late MockNetworkInfo networkInfo;
  late BarcodeResolver resolver;

  setUp(() {
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

      final result = await resolver.resolve('4009999999999');

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

    final result = await resolver.resolve('4001234500000');

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

      final result = await resolver.resolve('0000000000000');

      expect(result, isA<BarcodeNoMatch>());
    },
  );
}
