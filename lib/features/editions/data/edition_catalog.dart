import '../../../core/database/media_format.dart';

/// A physical release from the edition catalog of the own server or Movie
/// Shelf Cloud.
class CatalogEntry {
  const CatalogEntry({
    required this.id,
    required this.kind,
    required this.title,
    required this.format,
    this.tmdbId,
    this.year,
    this.editionName,
    this.region,
    this.releaseCountry,
    this.publisher,
    this.audioLanguages,
    this.subtitleLanguages,
    this.discCount,
    this.barcodes = const [],
    this.attribution,
    this.status = 'approved',
    this.mine = false,
  });

  factory CatalogEntry.fromJson(Map<String, dynamic> json) => CatalogEntry(
    id: json['id'] as String,
    kind: json['kind'] as String? ?? 'movie',
    title: json['title'] as String,
    format: MediaFormat.fromName(json['format'] as String?),
    tmdbId: json['tmdbId'] as int?,
    year: json['year'] as int?,
    editionName: json['editionName'] as String?,
    region: json['region'] as String?,
    releaseCountry: json['releaseCountry'] as String?,
    publisher: json['publisher'] as String?,
    audioLanguages: json['audioLanguages'] as String?,
    subtitleLanguages: json['subtitleLanguages'] as String?,
    discCount: json['discCount'] as int?,
    barcodes: [for (final b in json['barcodes'] as List? ?? []) b as String],
    attribution: json['attribution'] as String?,
    status: json['status'] as String? ?? 'approved',
    mine: json['mine'] as bool? ?? false,
  );

  final String id;
  final String kind;
  final String title;
  final MediaFormat format;
  final int? tmdbId;
  final int? year;
  final String? editionName;
  final String? region;
  final String? releaseCountry;
  final String? publisher;
  final String? audioLanguages;
  final String? subtitleLanguages;
  final int? discCount;
  final List<String> barcodes;

  /// The credit the source of these facts asks for.
  final String? attribution;

  /// approved, or pending while it waits for review (only shown to its author).
  final String status;
  final bool mine;

  bool get pending => status == 'pending';

  /// What is sent when the person shares an edition: the release itself,
  /// never copies, prices, notes about the own disc or who owns it.
  Map<String, Object?> toSubmission({String? replaces}) => {
    'kind': kind,
    'tmdbId': tmdbId,
    'title': title,
    'year': year,
    'format': format.name,
    'editionName': editionName,
    'region': region,
    'releaseCountry': releaseCountry,
    'publisher': publisher,
    'audioLanguages': audioLanguages,
    'subtitleLanguages': subtitleLanguages,
    'discCount': discCount,
    'barcodes': barcodes,
    'replaces': ?replaces,
  };
}

/// Where edition facts come from beyond this device. The own server and
/// Movie Shelf Cloud offer the same endpoints; other sources can be added
/// behind this interface.
abstract interface class EditionCatalog {
  /// Shown with the results, for example "Movie Shelf Server".
  String get name;

  Future<List<CatalogEntry>> forTitle(String kind, int tmdbId);

  Future<List<CatalogEntry>> forBarcode(String code);

  Future<CatalogEntry> submit(CatalogEntry entry, {String? replaces});
}

class RemoteEditionCatalog implements EditionCatalog {
  RemoteEditionCatalog({
    required this.name,
    required Future<dynamic> Function(String path, Map<String, dynamic> query)
    get,
    required Future<dynamic> Function(String path, Object? body) post,
  }) : _get = get,
       _post = post;

  @override
  final String name;
  final Future<dynamic> Function(String path, Map<String, dynamic> query) _get;
  final Future<dynamic> Function(String path, Object? body) _post;

  @override
  Future<List<CatalogEntry>> forTitle(String kind, int tmdbId) =>
      _list({'kind': kind, 'tmdbId': tmdbId});

  @override
  Future<List<CatalogEntry>> forBarcode(String code) =>
      _list({'barcode': code});

  @override
  Future<CatalogEntry> submit(CatalogEntry entry, {String? replaces}) async =>
      CatalogEntry.fromJson(
        await _post('/api/editions', entry.toSubmission(replaces: replaces))
            as Map<String, dynamic>,
      );

  Future<List<CatalogEntry>> _list(Map<String, dynamic> query) async => [
    for (final e in await _get('/api/editions', query) as List)
      CatalogEntry.fromJson(e as Map<String, dynamic>),
  ];
}
