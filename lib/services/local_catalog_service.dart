// Dart
import 'dart:convert';
import 'dart:io';

// Flutter
import 'package:flutter/foundation.dart';

// httapp
import 'package:httapp/models/local_path.dart';
import 'package:httapp/models/catalog/local_catalog.dart';
import 'package:httapp/models/catalog/local_file_entry.dart';

/// Reads, writes, and updates local_catalog.json on disk.
class LocalCatalogService {
  LocalCatalog _catalog = LocalCatalog();

  LocalCatalog get catalog => _catalog;

  /// Loads local_catalog.json from disk.
  /// Returns an empty [LocalCatalog] if the file does not exist yet (cold start).
  Future<void> load() async {
    final path = await localCatalogPath;
    final file = File(path);

    if (!await file.exists()) {
      debugPrint('[LocalCatalogService] No local catalog found, starting fresh.');
      _catalog = LocalCatalog();
      return;
    }

    try {
      final contents = await file.readAsString();
      final json = jsonDecode(contents) as Map<String, dynamic>;
      _catalog = LocalCatalog.fromJson(json);
      debugPrint('[LocalCatalogService] Loaded ${_catalog.files.length} file entries.');
    } catch (e) {
      debugPrint('[LocalCatalogService] Failed to parse local catalog, resetting: $e');
      _catalog = LocalCatalog();
    }
  }

  /// Records a successfully downloaded file in the in-memory catalog
  /// and immediately persists to disk.
  ///
  /// [key], the catalog-relative path, e.g. 'trees/1-18/thumbnail.jpg'.
  /// [md5Hash], the hash from the remote catalog entry.
  /// [lastModified], the lastModified timestamp from the remote catalog entry.
  Future<void> recordFile(String key, String md5Hash, String lastModified) async {
    _catalog.files[key] = LocalFileEntry(md5Hash: md5Hash, lastModified: lastModified);
    await _persist();
  }

  /// Removes a file entry from the local catalog and persists.
  /// Called when a file has been deleted from the remote catalog.
  Future<void> removeFile(String key) async {
    _catalog.files.remove(key);
    await _persist();
  }

  /// Updates the sync hash and timestamp after a successful sync,
  /// then persists. Call this only when a full sync cycle completes.
  Future<void> recordSyncComplete(String masterHash) async {
    _catalog.lastSyncHash = masterHash;
    _catalog.lastSyncTime = DateTime.now().toUtc().toIso8601String();
    await _persist();
  }

  /// Writes the current in-memory catalog to disk.
  Future<void> _persist() async {
    try {
      final path = await localCatalogPath;
      final file = File(path);
      await file.parent.create(recursive: true);
      await file.writeAsString(jsonEncode(_catalog.toJson()), flush: true);
    } catch (e) {
      debugPrint('[LocalCatalogService] Failed to persist local catalog: $e');
      // Non-fatal - in-memory state is still valid for this session.
    }
  }
}
