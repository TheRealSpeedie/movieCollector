import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:movie_shelf/core/network/dio_client.dart';
import 'package:movie_shelf/core/network/network_info.dart';
import 'package:movie_shelf/core/network/upcmdb/upcmdb_client.dart';

void main() {
  test('maps documented UPCMDB fields and leaves missing ones empty', () {
    final record = UpcmdbRecord.fromJson({
      'upc': '012345678905',
      'title': 'The Matrix',
      'year': '1999',
      'format': 'Blu-ray',
      'special_features': 'Steelbook',
      'publisher': 'Warner',
      'imdbID': 'tt0133093',
      'mediaType': 'movie',
    });

    expect(record.title, 'The Matrix');
    expect(record.upc, '012345678905');
    expect(record.year, 1999);
    expect(record.format, 'Blu-ray');
    expect(record.specialFeatures, 'Steelbook');
    expect(record.publisher, 'Warner');
    expect(record.imdbId, 'tt0133093');
    expect(record.mediaType, 'movie');
  });

  test('an invalid UPCMDB body is a failure and does not invent a product', () async {
    final dio = Dio(BaseOptions(baseUrl: 'https://upcmdb.invalid'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: 'not-a-product',
            ),
          );
        },
      ),
    );
    final client = UpcmdbClient(
      DioClient(dio: dio, networkInfo: _Online()),
    );

    final result = await client.lookupGtin('0123456789055');

    expect(result, isA<UpcmdbFailed>());
    expect((result as UpcmdbFailed).reason, 'invalid');
  });
}

class _Online implements NetworkInfo {
  @override
  Future<bool> get isConnected async => true;
}
