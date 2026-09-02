import '../../errors/app_exception.dart';
import '../dio_client.dart';
import 'upcitemdb_models.dart';

abstract class BarcodeProvider {
  Future<UpcLookupResult> lookup(String barcode);
}

class UpcItemDbClient implements BarcodeProvider {
  UpcItemDbClient(this._client);

  final DioClient _client;

  @override
  Future<UpcLookupResult> lookup(String barcode) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/lookup',
      queryParameters: {'upc': barcode},
    );
    final data = response.data;
    if (data == null) throw const BarcodeNotFoundException();
    final result = UpcLookupResult.fromJson(data);
    if (!result.found) throw const BarcodeNotFoundException();
    return result;
  }
}
