import 'package:httapp/models/catalog/catalog_entity.dart';
import 'package:httapp/models/catalog/remote_file_entry.dart';

/// The parsed form of remote_catalog.json.
class RemoteCatalog {
  final String updated;
  final String masterMd5Hash;
  final int fileCount;
  final List<CatalogEntity> entities;
  final Map<String, RemoteFileEntry> files;

  const RemoteCatalog({
    required this.updated,
    required this.masterMd5Hash,
    required this.fileCount,
    required this.entities,
    required this.files,
  });

  factory RemoteCatalog.fromJson(Map<String, dynamic> json) => RemoteCatalog(
        updated: json['updated'] as String,
        masterMd5Hash: json['master_md5_hash'] as String,
        fileCount: json['fileCount'] as int,
        entities: (json['entities'] as List<dynamic>)
            .map((e) => CatalogEntity.fromJson(e as Map<String, dynamic>))
            .toList(),
        files: (json['files'] as Map<String, dynamic>).map(
          (key, value) => MapEntry(
            key,
            RemoteFileEntry.fromJson(value as Map<String, dynamic>),
          ),
        ),
      );
}