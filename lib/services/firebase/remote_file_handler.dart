/*
  Handle remote file operations
*/
// dart
import 'dart:io';
import 'dart:core';

// httapp
//import 'package:httapp/models/remote_path.dart';
import 'package:httapp/models/local_path.dart';

// firebase
import 'package:firebase_storage/firebase_storage.dart';

class RemoteFileHandler {
  /// Returns the [FullMetadata] for a remote file.
  ///
  /// Callers use this to compare the remote catalog's custom metadata
  /// (e.g. master_md5_hash) against the locally cached value, avoiding
  /// a full catalog download when nothing has changed.
  ///
  /// [remotePath], the full remote path to the file, e.g. 'catalog.json'.
  ///
  /// Throws [FirebaseException] if the file does not exist or another
  /// storage error occurs - callers should handle appropriately.
  static Future<FullMetadata> getMetadata(String remotePath) async {
    try {
      return await FirebaseStorage.instance.ref(remotePath).getMetadata();
    } catch (e) {
      print('[getMetadata] Error fetching metadata for $remotePath: $e');
      rethrow;
    }
  }

  /// Returns true or false if a file exists or does not
  /// 
  /// [remoteFile], the remote path to test if it exists or does not exist.
  /// 
  /// Passes exceptions through
  static Future<bool> remoteFileExists(String remoteFile) async {
    try {
      await FirebaseStorage.instance.ref(remoteFile).getMetadata();
      print('[remoteFileExists] File exists: $remoteFile');

      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'storage/object-not-found' || 
          e.code == 'object-not-found' ||
          e.code == 'not-found') {

        // This exception indicates the file does not exist
        print('[remoteFileExists] File does not exist: $remoteFile');
        return false;
      }

      print('[remoteFileExists] Unexpected error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      print('[remoteFileExists] Unexpected non-Firebase error: $e');
      rethrow;
    }
  }

  /// Downloads a remote file and writes it to a local path derived from
  /// [localFilePath] (the full absolute local destination path).
  ///
  /// [remoteFilePath], the full path in the storage bucket.
  ///
  /// [localFilePath], the full absolute local path to write to.
  ///   The containing directory is created automatically if it does not exist.
  ///
  /// [storageInstance], the [FirebaseStorage] instance to use.
  ///
  /// [downloadingFilesSet], shared set used to prevent concurrent duplicate
  ///   downloads of the same remote file.
  ///
  /// Returns true on success, false if the remote file does not exist.
  /// Throws on unexpected errors.
  static Future<bool> downloadFile({
    required String remoteFilePath,
    required String localFilePath,
    required FirebaseStorage storageInstance,
    required Set<String> downloadingFilesSet,
  }) async {
    final localFile = File(localFilePath);

    // File already on disk - skip.
    if (await localFile.exists()) {
      print('[downloadFile] Already exists locally, skipping: $remoteFilePath');
      return true;
    }

    // Another coroutine is already downloading this file - wait for it.
    if (downloadingFilesSet.contains(remoteFilePath)) {
      print('[downloadFile] Download in progress, waiting: $remoteFilePath');
      while (downloadingFilesSet.contains(remoteFilePath)) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      // Return true whether or not the concurrent download succeeded;
      // the caller will verify the file exists in local_catalog.
      return await localFile.exists();
    }

    downloadingFilesSet.add(remoteFilePath);

    try {
      // Confirm file exists remotely before attempting download.
      if (!await remoteFileExists(remoteFilePath)) {
        print('[downloadFile] Remote file does not exist: $remoteFilePath');
        return false;
      }

      // Ensure destination directory exists.
      await ensureDirectoryExists(localFilePath);

      final ref = storageInstance.ref(remoteFilePath);

      // use getData() to download the data in chunks
      final bytes = await ref.getData();

      if (bytes == null) {
        throw Exception('[downloadFile] No data received for: $remoteFilePath');
      }

      // Using the bytes recieved from getData() - write to the local file
      await localFile.writeAsBytes(bytes);

      // Verify write succeeded.
      if (!await localFile.exists()) {
        throw Exception('[downloadFile] File not found after write: $localFilePath');
      }

      print('[downloadFile] Success (${bytes.length} bytes): $remoteFilePath → $localFilePath');
      return true;
    } on FirebaseException catch (e) {
      print('[downloadFile] Firebase exception for $remoteFilePath: $e');
      rethrow;
    } catch (e) {
      print('[downloadFile] Unexpected error for $remoteFilePath: $e');
      rethrow;
    } finally {
      // Always remove from set when done (success or failure)
      downloadingFilesSet.remove(remoteFilePath);
    }
  }
}

