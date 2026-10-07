class PhysicalProduct {
  const PhysicalProduct({
    required this.source,
    required this.title,
    this.productTitle,
    this.year,
    this.physicalFormat,
    this.edition,
    this.region,
    this.publisher,
    this.imdbId,
    this.mediaType,
  });

  final String source;
  final String title;
  final String? productTitle;
  final int? year;
  final String? physicalFormat;
  final String? edition;
  final String? region;
  final String? publisher;
  final String? imdbId;
  final String? mediaType;

  String get displayTitle {
    final extra = productTitle?.trim();
    if (extra != null && extra.isNotEmpty && extra != title) return extra;
    return title;
  }

  Map<String, dynamic> toJson() {
    return {
      'source': source,
      'title': title,
      'productTitle': productTitle,
      'year': year,
      'physicalFormat': physicalFormat,
      'edition': edition,
      'region': region,
      'publisher': publisher,
      'imdbId': imdbId,
      'mediaType': mediaType,
    };
  }

  factory PhysicalProduct.fromJson(Map<String, dynamic> json) {
    return PhysicalProduct(
      source: json['source'] as String? ?? 'cache',
      title: json['title'] as String? ?? '',
      productTitle: json['productTitle'] as String?,
      year: json['year'] as int?,
      physicalFormat: json['physicalFormat'] as String?,
      edition: json['edition'] as String?,
      region: json['region'] as String?,
      publisher: json['publisher'] as String?,
      imdbId: json['imdbId'] as String?,
      mediaType: json['mediaType'] as String?,
    );
  }
}
