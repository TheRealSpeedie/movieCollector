class UpcItem {
  const UpcItem({required this.title, this.brand, this.model});

  final String title;
  final String? brand;
  final String? model;

  factory UpcItem.fromJson(Map<String, dynamic> json) {
    return UpcItem(
      title: json['title'] as String? ?? '',
      brand: json['brand'] as String?,
      model: json['model'] as String?,
    );
  }
}

class UpcLookupResult {
  const UpcLookupResult({required this.code, this.items = const []});

  final String code;
  final List<UpcItem> items;

  bool get found => code == 'OK' && items.isNotEmpty;

  factory UpcLookupResult.fromJson(Map<String, dynamic> json) {
    final itemsJson = json['items'] as List<dynamic>? ?? const [];
    return UpcLookupResult(
      code: json['code'] as String? ?? 'UNKNOWN',
      items: itemsJson
          .whereType<Map<String, dynamic>>()
          .map(UpcItem.fromJson)
          .toList(growable: false),
    );
  }
}
