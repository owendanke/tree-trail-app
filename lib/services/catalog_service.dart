import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:httapp/models/poi.dart';
import 'package:latlong2/latlong.dart';

import 'package:httapp/models/local_path.dart';
import 'package:httapp/models/remote_path.dart';
import 'package:httapp/models/entity/entity.dart';
import 'package:httapp/models/entity/tree_entity_data.dart';
import 'package:httapp/models/entity/sign_entity_data.dart';
import 'package:httapp/models/catalog/catalog_entity.dart';
import 'package:httapp/models/catalog/remote_catalog.dart';
// import 'package:httapp/models/catalog/remote_file_entry.dart';
import 'package:httapp/services/firebase/remote_file_handler.dart';
import 'package:httapp/services/local_catalog_service.dart';

// import 'package:httapp/services/local_file_handling.dart';

// ---------------------------------------------------------------------------
// CatalogService
// ---------------------------------------------------------------------------
class CatalogService {
  final FirebaseStorage _storage;
  final Set<String> _downloadingFiles = {};
  late final LocalCatalogService _localCatalog;

  /// The live list of complete entities. The UI listens to this.
  /// Grows as entities finish downloading during background sync.
  final ValueNotifier<List<EntityData>> entities = ValueNotifier([]);

  final ValueNotifier<List<PointOfInterest>> treeLocations = ValueNotifier([]);
  final ValueNotifier<List<PointOfInterest>> signLocations = ValueNotifier([]);

  /// True while a sync is running. Useful for showing a sync indicator.
  final ValueNotifier<bool> isSyncing = ValueNotifier(false);

  CatalogService({FirebaseStorage? storage})
      : _storage = storage ?? FirebaseStorage.instance {
       _localCatalog = LocalCatalogService();
  }

  // -------------------------------------------------------------------------
  // Phase 1 - load from local cache (call before runApp)
  // -------------------------------------------------------------------------

  /// Reads local_catalog.json and verifies files are on disk.
  /// Populates [entities] with all complete entities found locally.
  /// No network calls.
  Future<void> loadLocal() async {
    debugPrint('[CatalogService][loadLocal] starting ');
    await _localCatalog.load();

    // Read local version of remote_catalog.json if it exists to know what entities and names we expect.
    // Fall back to remote catalog if it doesn't exist yet.
    final remoteCatalog = await _readLocalRemoteCatalog();
    if (remoteCatalog == null) {
      debugPrint('[CatalogService][loadLocal] No remote_catalog.json on disk, cold start.');
      return;
    }

    final List<EntityData> complete = [];
    for (final entity in remoteCatalog.entities) {
      // Skip entities without required metadata (e.g. missing name for trees).
      if (!_entityMetadataComplete(entity)) {
        debugPrint('[CatalogService] Skipping incomplete entity metadata: ${entity.id}');
        continue;
      }

      final entityData = await _buildEntityFromDisk(entity, remoteCatalog);
      if (entityData != null) {
        complete.add(entityData);
        debugPrint('[CatalogService] Loaded complete entity from disk: ${entity.id}');
      }
    }

    for (final entity in complete) {
      _upsertEntity(entity);
    }
    debugPrint('[CatalogService][loadLocal] done - ${complete.length} complete entities.');
  }

  // -------------------------------------------------------------------------
  // Phase 2 - background sync (call after runApp, from a post-frame callback)
  // -------------------------------------------------------------------------

  /// Checks for remote catalog updates and downloads any changed/new assets.
  /// Emits updated [entities] incrementally as each entity completes.
  /// Safe to call multiple times - returns early if a sync is already running.
  Future<void> sync() async {
    if (isSyncing.value) {
      debugPrint('[CatalogService] sync() called while already syncing, ignoring.');
      return;
    }

    isSyncing.value = true;
    debugPrint('[CatalogService][sync] starting');

    try {
      // --- Step 1: check remote catalog metadata ---
      final FullMetadata metadata;
      try {
        metadata = await RemoteFileHandler.getMetadata(remoteCatalogPath);
      } catch (e) {
        debugPrint('[CatalogService] Cannot reach remote catalog, skipping sync: $e');
        return;
      }

      // Extract master hash - prefer custom metadata, fall back to md5Hash.
      final remoteHash = metadata.customMetadata?['master_md5_hash'] ??
          // metadata.md5Hash ??
          '';

      if (remoteHash.isNotEmpty &&
          remoteHash == _localCatalog.catalog.lastSyncHash &&
          _localCatalog.catalog.files.isNotEmpty) {
        debugPrint('[CatalogService] Remote catalog unchanged ($remoteHash), sync done.');
        return;
      }

      debugPrint('[CatalogService] Catalog changed, downloading remote_catalog.json');

      // --- Step 2: download remote catalog ---
      final remoteCatalogLocalFile = await remoteCatalogLocalPath;
      // Always re-download to get fresh data (GCS objects are immutable;
      // a changed hash means a new object was uploaded).
      final existingFile = File(remoteCatalogLocalFile);
      if (await existingFile.exists()) {
        await existingFile.delete();
      }

      final downloaded = await RemoteFileHandler.downloadFile(
        remoteFilePath: remoteCatalogPath,
        localFilePath: remoteCatalogLocalFile,
        storageInstance: _storage,
        downloadingFilesSet: _downloadingFiles,
      );

      if (!downloaded) {
        debugPrint('[CatalogService] Failed to download remote catalog, aborting sync.');
        return;
      }

      final remoteCatalog = await _readLocalRemoteCatalog();
      if (remoteCatalog == null) {
        debugPrint('[CatalogService] Could not parse remote catalog, aborting sync.');
        return;
      }

      // --- Step 3: diff and download, entity by entity ---
      await _syncEntities(remoteCatalog);

      // --- Step 4: clean up files removed from remote catalog ---
      await _pruneRemovedFiles(remoteCatalog);

      // --- Step 5: mark sync complete ---
      await _localCatalog.recordSyncComplete(remoteCatalog.masterMd5Hash);
      debugPrint('[CatalogService] sync() complete. Hash: ${remoteCatalog.masterMd5Hash}');
    } catch (e) {
      debugPrint('[CatalogService] sync() encountered an error: $e');
    } finally {
      isSyncing.value = false;
    }
  }

  // -------------------------------------------------------------------------
  // Internal sync helpers
  // -------------------------------------------------------------------------

  /// Downloads changed or missing files for each entity in order.
  /// After each entity finishes, checks completeness and updates [entities].
  Future<void> _syncEntities(RemoteCatalog remoteCatalog) async {
    for (final entity in remoteCatalog.entities) {
      if (!_entityMetadataComplete(entity)) {
        debugPrint('[CatalogService] Skipping entity with incomplete metadata: ${entity.id}');
        continue;
      }

      debugPrint('[CatalogService] Processing entity: ${entity.id} (${entity.type.name})');

      // Collect all files belonging to this entity.
      final entityPrefix = '${entity.type.remotePrefix}/${entity.id}/';
      final entityFiles = remoteCatalog.files.entries
          .where((e) => e.key.startsWith(entityPrefix))
          .toList();

      if (entityFiles.isEmpty) {
        debugPrint('[CatalogService] No files found for entity: ${entity.id}');
        continue;
      }

      // Download any file that is missing or has a changed hash.
      bool anyDownloaded = false;

      for (final fileEntry in entityFiles) {
        final key = fileEntry.key;
        final remoteEntry = fileEntry.value;

        if (_localCatalog.catalog.hasFile(key, remoteEntry.md5Hash)) {
          // Verify the file actually exists on disk (could be deleted externally).
          final localPath = await localPathForKey(key);
          if (await File(localPath).exists()) {
            continue; // Up to date and on disk.
          }
          // Hash matches but file is gone - fall through to re-download.
          debugPrint('[CatalogService] Hash matches but file missing, re-downloading: $key');
        }

        // File is new, changed, or missing - download it.
        final localPath = await localPathForKey(key);
        debugPrint('[CatalogService] Downloading: $key');

        try {
          final success = await RemoteFileHandler.downloadFile(
            remoteFilePath: key,
            localFilePath: localPath,
            storageInstance: _storage,
            downloadingFilesSet: _downloadingFiles,
          );

          if (success) {
            await _localCatalog.recordFile(key, remoteEntry.md5Hash, remoteEntry.lastModified);
            anyDownloaded = true;
            debugPrint('[CatalogService] Recorded: $key');
          } else {
            debugPrint('[CatalogService] Download returned false for: $key');
          }
        } catch (e) {
          // Log and continue - partial downloads are recorded; the next sync
          // will pick up anything still missing.
          debugPrint('[CatalogService] Error downloading $key: $e');
        }
      }

      // After processing all files for this entity, check if it is now complete.
      if (anyDownloaded || !_entityIsInNotifier(entity.id)) {
        final entityData = await _buildEntityFromDisk(entity, remoteCatalog);
        if (entityData != null) {
          _upsertEntity(entityData);
          debugPrint('[CatalogService] Entity complete and added to notifier: ${entity.id}');
        }
      }
    }
  }

  /// Removes local files and catalog entries for keys no longer in the remote catalog.
  Future<void> _pruneRemovedFiles(RemoteCatalog remoteCatalog) async {
    final remoteKeys = remoteCatalog.files.keys.toSet();
    final localKeys = _localCatalog.catalog.files.keys.toList();

    for (final key in localKeys) {
      if (!remoteKeys.contains(key)) {
        debugPrint('[CatalogService] Pruning removed file: $key');
        try {
          final localPath = await localPathForKey(key);
          final file = File(localPath);
          if (await file.exists()) {
            await file.delete();
          }
          await _localCatalog.removeFile(key);
        } catch (e) {
          debugPrint('[CatalogService] Error pruning $key: $e');
        }
      }
    }

    // Remove entities from the notifier if their required files were pruned.
    final remainingIds = entities.value
        .where((e) => _entityStillHasRequiredFiles(e, remoteCatalog))
        .toList();
    if (remainingIds.length != entities.value.length) {
      entities.value = List.unmodifiable(remainingIds);
    }
  }

  // -------------------------------------------------------------------------
  // Entity building - assembles EntityData from files on disk
  // -------------------------------------------------------------------------

  /// Attempts to build an [EntityData] from files confirmed on disk.
  /// Returns null if any required file is missing.
  Future<EntityData?> _buildEntityFromDisk(CatalogEntity entity, RemoteCatalog remoteCatalog) async {
    final root = await localRootPath;

    switch (entity.type) {
      case EntityType.tree:
        return _buildTreeEntity(entity, remoteCatalog, root);
      case EntityType.sign:
        return _buildSignEntity(entity, remoteCatalog, root);
    }
  }

  Future<TreeEntityData?> _buildTreeEntity(CatalogEntity entity, RemoteCatalog remoteCatalog, String root) async {
    final base = '${entity.type.remotePrefix}/${entity.id}';
    final thumbnail = File('$root/$base/thumbnail.jpg');
    final description = File('$root/$base/description.md');
    final geoJsonFile = File('$root/$base/geography.geojson');

    // All three required files must exist.
    if (!thumbnail.existsSync() ||
        !description.existsSync() ||
        !geoJsonFile.existsSync()) {
      return null;
    }

    // At least one gallery image must exist.
    final galleryImages = _findGalleryImages(root, base, remoteCatalog);
    if (galleryImages.isEmpty) return null;

    final location = _parseLatLng(await geoJsonFile.readAsString());
    if (location == null) return null;

    return TreeEntityData(
      id: entity.id,
      name: entity.name!,
      thumbnail: thumbnail,
      description: description,
      location: location,
      galleryImages: galleryImages,
    );
  }

  Future<SignEntityData?> _buildSignEntity(CatalogEntity entity, RemoteCatalog remoteCatalog, String root) async {
    final base = '${entity.type.remotePrefix}/${entity.id}';
    final description = File('$root/$base/description.md');
    final geoJsonFile = File('$root/$base/geography.geojson');

    if (!description.existsSync() || !geoJsonFile.existsSync()) return null;

    final location = _parseLatLng(await geoJsonFile.readAsString());
    if (location == null) return null;

    return SignEntityData(
      id: entity.id,
      name: entity.name!,
      description: description,
      location: location,
    );
  }

  /// Returns all gallery image files present on disk for an entity,
  /// sorted by filename so ordering is deterministic.
  List<File> _findGalleryImages(String root, String base, RemoteCatalog remoteCatalog) {
    final galleryKeys = remoteCatalog.files.keys
        .where((k) =>
            k.startsWith('$base/') &&
            k.contains('gallery-') &&
            k.endsWith('.jpg'))
        .toList()
      ..sort();

    final files = <File>[];
    for (final key in galleryKeys) {
      final f = File('$root/$key');
      if (f.existsSync()) files.add(f);
    }
    return files;
  }

  // -------------------------------------------------------------------------
  // Notifier helpers
  // -------------------------------------------------------------------------

  /// Adds or replaces an entity in the notifier by id.
  void _upsertEntity(EntityData updated) {
    final current = List<EntityData>.from(entities.value);
    final idx = current.indexWhere((e) => e.id == updated.id);
    if (idx >= 0) {
      current[idx] = updated;
    } else {
      current.add(updated);
    }
    entities.value = List.unmodifiable(current);

    if (updated is TreeEntityData) {
        treeLocations.value = List.unmodifiable([
          ...treeLocations.value.where((p) => p.id != updated.id),
          PointOfInterest(id: updated.id, name: updated.name, location: updated.location),
        ]);
      } else if (updated is SignEntityData) {
        signLocations.value = List.unmodifiable([
          ...signLocations.value.where((p) => p.id != updated.id),
          PointOfInterest(id: updated.id, name: updated.name, location: updated.location),
        ]);
      }
  }

  bool _entityIsInNotifier(String id) =>
      entities.value.any((e) => e.id == id);

  bool _entityStillHasRequiredFiles(
      EntityData entity, RemoteCatalog remoteCatalog) {
    final base = '${entity.type.remotePrefix}/${entity.id}';
    return remoteCatalog.files.keys.any((k) => k.startsWith('$base/'));
  }

  // -------------------------------------------------------------------------
  // Validation helpers
  // -------------------------------------------------------------------------

  /// Returns true if the entity has all the metadata fields required to
  /// build a complete [EntityData] (e.g. trees require a name).
  bool _entityMetadataComplete(CatalogEntity entity) {
    switch (entity.type) {
      case EntityType.tree:
        return entity.name != null && entity.name!.isNotEmpty;
      case EntityType.sign:
        return true; // Signs have no required metadata beyond id and type.
    }
  }

  // -------------------------------------------------------------------------
  // Catalog I/O helpers
  // -------------------------------------------------------------------------

  /// Reads and parses remote_catalog.json from local disk.
  /// Returns null if the file does not exist or cannot be parsed.
  Future<RemoteCatalog?> _readLocalRemoteCatalog() async {
    try {
      final path = await remoteCatalogLocalPath;
      final file = File(path);
      if (!await file.exists()) return null;
      final contents = await file.readAsString();
      final json = jsonDecode(contents) as Map<String, dynamic>;
      return RemoteCatalog.fromJson(json);
    } catch (e) {
      debugPrint('[CatalogService] Failed to read remote_catalog.json: $e');
      return null;
    }
  }

  static LatLng? _parseLatLng(String geoJson) {
  try {
    final fc = jsonDecode(geoJson);
    final coords = fc['features'][0]['geometry']['coordinates'];
    return LatLng(coords[1] as double, coords[0] as double);
  } catch (e) {
    debugPrint('[CatalogService] Failed to parse LatLng: $e');
    return null;
  }
}
}
