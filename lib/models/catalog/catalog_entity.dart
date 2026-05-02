import 'package:httapp/models/remote_path.dart';

/// Represents a single entity record from the remote catalog's 'entities' list.
class CatalogEntity {
  final String id;
  final EntityType type;
  final String? name;
  final String lastModified;

  const CatalogEntity({
    required this.id,
    required this.type,
    this.name,
    required this.lastModified,
  });

  factory CatalogEntity.fromJson(Map<String, dynamic> json) => CatalogEntity(
        id: json['id'] as String,
        type: EntityType.fromString(json['type'] as String),
        name: json['name'] as String?,
        lastModified: json['lastModified'] as String,
      );
}