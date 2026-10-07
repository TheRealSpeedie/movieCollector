class BarcodeSearchContext {
  const BarcodeSearchContext({
    this.query,
    this.barcode,
    this.barcodeType = 'EAN',
    this.productTitle,
    this.physicalFormat,
    this.imdbId,
    this.edition,
  });

  final String? query;
  final String? barcode;
  final String barcodeType;
  final String? productTitle;
  final String? physicalFormat;
  final String? imdbId;
  final String? edition;

  factory BarcodeSearchContext.fromQuery(Map<String, String> query) {
    return BarcodeSearchContext(
      query: query['q'],
      barcode: query['barcode'],
      barcodeType: query['barcodeType'] ?? 'EAN',
      productTitle: query['product'],
      physicalFormat: query['format'],
      imdbId: query['imdb'],
      edition: query['edition'],
    );
  }

  bool get hasBarcode => barcode != null && barcode!.isNotEmpty;

  String location({String path = '/search'}) {
    return Uri(
      path: path,
      queryParameters: {
        if (query != null && query!.isNotEmpty) 'q': query!,
        if (hasBarcode) 'barcode': barcode!,
        if (hasBarcode) 'barcodeType': barcodeType,
        if (productTitle != null && productTitle!.isNotEmpty)
          'product': productTitle!,
        if (physicalFormat != null && physicalFormat!.isNotEmpty)
          'format': physicalFormat!,
        if (imdbId != null && imdbId!.isNotEmpty) 'imdb': imdbId!,
        if (edition != null && edition!.isNotEmpty) 'edition': edition!,
      },
    ).toString();
  }

  BarcodeSearchContext copyForAdd(int tmdbId) {
    return BarcodeSearchContext(
      barcode: barcode,
      barcodeType: barcodeType,
      productTitle: productTitle,
      physicalFormat: physicalFormat,
      imdbId: imdbId,
      edition: edition,
    );
  }
}
