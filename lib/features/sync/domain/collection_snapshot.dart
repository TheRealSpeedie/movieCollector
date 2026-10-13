import 'dart:convert';

import '../../../shared/models/collection_status.dart';

class SnapshotBarcode {
  const SnapshotBarcode({
    required this.barcode,
    required this.type,
    this.productTitle,
    this.editionName,
    this.format,
    this.region,
  });

  factory SnapshotBarcode.fromJson(Map<String, dynamic> json) =>
      SnapshotBarcode(
        barcode: json['barcode'] as String,
        type: json['type'] as String,
        productTitle: json['productTitle'] as String?,
        editionName: json['editionName'] as String?,
        format: json['format'] as String?,
        region: json['region'] as String?,
      );

  final String barcode;
  final String type;
  final String? productTitle;
  final String? editionName;
  final String? format;
  final String? region;

  Map<String, dynamic> toJson() => {
    'barcode': barcode,
    'type': type,
    'productTitle': productTitle,
    'editionName': editionName,
    'format': format,
    'region': region,
  };

  String get key => jsonEncode(toJson());
}

class CollectionSnapshot {
  CollectionSnapshot({
    required this.status,
    required List<SnapshotBarcode> barcodes,
  }) : barcodes = [...barcodes]..sort((a, b) => a.barcode.compareTo(b.barcode));

  factory CollectionSnapshot.fromJson(Map<String, dynamic> json) =>
      CollectionSnapshot(
        status: CollectionStatus.values.byName(json['status'] as String),
        barcodes: [
          for (final b in json['barcodes'] as List)
            SnapshotBarcode.fromJson(b as Map<String, dynamic>),
        ],
      );

  final CollectionStatus status;
  final List<SnapshotBarcode> barcodes;

  Map<String, dynamic> toJson() => {
    'status': status.name,
    'barcodes': [for (final b in barcodes) b.toJson()],
  };

  String encode() => jsonEncode(toJson());
}

class ServerProjection {
  const ServerProjection({
    required this.tmdbId,
    required this.revision,
    required this.snapshot,
  });

  factory ServerProjection.fromJson(Map<String, dynamic> json) =>
      ServerProjection(
        tmdbId: json['tmdbId'] as int,
        revision: json['revision'] as int,
        snapshot: CollectionSnapshot.fromJson(
          json['payload'] as Map<String, dynamic>,
        ),
      );

  final int tmdbId;
  final int revision;
  final CollectionSnapshot snapshot;

  Map<String, dynamic> toJson() => {
    'tmdbId': tmdbId,
    'revision': revision,
    'payload': snapshot.toJson(),
  };
}
