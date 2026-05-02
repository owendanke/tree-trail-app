// Copyright (c) 2026, Owen Danke

/*
  Local path definitions.
  Mirrors the remote bucket layout under the platform Application Support directory:
    {appSupport}/catalog/local_catalog.json
    {appSupport}/catalog/remote_catalog.json
    {appSupport}/trees/{id}/thumbnail.jpg
    {appSupport}/trees/{id}/description.md
    {appSupport}/trees/{id}/gallery-{n}.jpg
    {appSupport}/trees/{id}/geography.geojson
    {appSupport}/signs/{id}/description.md
    {appSupport}/signs/{id}/geography.geojson
*/

// Dart
import 'dart:io';

// pub.dev
import 'package:path_provider/path_provider.dart';

// httapp
import 'package:httapp/models/remote_path.dart';

/// Returns the Application Support root directory path as a string.
Future<String> get localRootPath async {
  final dir = await getApplicationSupportDirectory();
  return dir.path;
}

/// Returns the local directory path for catalog files.
/// e.g. {appSupport}/catalog/
Future<String> get localCatalogDirPath async {
  final root = await localRootPath;
  return '$root/catalog';
}

/// Full path to the locally maintained catalog (tracks what is on disk).
Future<String> get localCatalogPath async {
  return '${await localCatalogDirPath}/local_catalog.json';
}

/// Full path to the last-downloaded remote catalog snapshot.
Future<String> get remoteCatalogLocalPath async {
  return '${await localCatalogDirPath}/remote_catalog.json';
}

/// Returns the local directory path for a specific entity,
/// mirroring the remote bucket structure.
/// e.g. localEntityPath(EntityType.tree, '1-18') → '{appSupport}/trees/1-18'
Future<String> localEntityPath(EntityType type, String id) async {
  final root = await localRootPath;
  return '$root/${type.entityPath(id)}';
}

/// Returns the full local file path for a specific entity asset.
/// e.g. localFilePath(EntityType.tree, '1-18', 'thumbnail.jpg')
///      → '{appSupport}/trees/1-18/thumbnail.jpg'
Future<String> localFilePath(EntityType type, String id, String fileName) async {
  final root = await localRootPath;
  return '$root/${type.filePath(id, fileName)}';
}

/// Returns the local file path for a catalog-relative key.
/// The key format matches catalog.json's files map, e.g. 'trees/1-18/thumbnail.jpg'.
/// This is the primary path resolver used during sync.
Future<String> localPathForKey(String catalogKey) async {
  final root = await localRootPath;
  return '$root/$catalogKey';
}

/// Ensures the directory for the given file path exists, creating it if needed.
Future<void> ensureDirectoryExists(String filePath) async {
  final dir = File(filePath).parent;
  if (!await dir.exists()) {
    await dir.create(recursive: true);
  }
}