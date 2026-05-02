// Copyright (c) 2026, Owen Danke

/*
  Remote path definitions and entity type routing.
  Bucket layout:
    catalog.json
    trees/{id}/thumbnail.jpg
    trees/{id}/description.md
    trees/{id}/gallery-{n}.jpg
    trees/{id}/geography.geojson
    signs/{id}/description.md
    signs/{id}/geography.geojson
*/

/// The remote path to catalog.json - static, never changes.
const String remoteCatalogPath = 'catalog.json';

/// Defines the entity types the app understands.
///
/// [remotePrefix] is the top-level bucket folder for this type.
/// Adding a new type in the future only requires a new enum entry.
enum EntityType {
  tree('trees'),
  sign('signs');

  const EntityType(this.remotePrefix);

  /// The top-level bucket/local folder name for this type, e.g. 'trees'.
  final String remotePrefix;

  /// Returns the remote (and local) folder path for a specific entity.
  /// e.g. EntityType.tree.entityPath('1-18') → 'trees/1-18'
  String entityPath(String id) => '$remotePrefix/$id';

  /// Returns the full remote path for a specific file belonging to an entity.
  /// e.g. EntityType.tree.filePath('1-18', 'thumbnail.jpg') → 'trees/1-18/thumbnail.jpg'
  String filePath(String id, String fileName) => '$remotePrefix/$id/$fileName';

  /// Parses a type string from catalog.json into an [EntityType].
  /// Throws [ArgumentError] for unrecognised type strings so new types are
  /// caught early rather than silently ignored.
  static EntityType fromString(String s) => values.firstWhere(
        (e) => e.name == s,
        orElse: () => throw ArgumentError('Unknown entity type: "$s"'),
      );
}

/// Known asset file names per entity type.
/// These are used for completeness checks - the app will not surface an entity
/// until all required assets are present on disk.
extension EntityTypeAssets on EntityType {
  /// Required file names that must exist for an entity to be considered complete.
  /// Gallery images are checked separately (at least one must exist).
  List<String> get requiredFileNames {
    switch (this) {
      case EntityType.tree:
        return ['thumbnail.jpg', 'description.md', 'geography.geojson'];
      case EntityType.sign:
        return ['description.md', 'geography.geojson'];
    }
  }

  /// Whether this entity type requires at least one gallery image.
  bool get requiresGalleryImage {
    switch (this) {
      case EntityType.tree:
        return true;
      case EntityType.sign:
        return false;
    }
  }

  /// Returns true if [fileName] is a gallery image for this entity type.
  bool isGalleryImage(String fileName) {
    return fileName.startsWith('gallery-') && fileName.endsWith('.jpg');
  }
}