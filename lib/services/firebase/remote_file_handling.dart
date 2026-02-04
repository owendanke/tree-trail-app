/*
  Handle remote file operations
*/
// dart
import 'dart:io';
import 'dart:core';

// httapp
import 'package:httapp/models/remote_path.dart';

// firebase
import 'package:firebase_storage/firebase_storage.dart';

class remoteFileHandler {
  /// List all the image files at the _remoteImagePath
  /// 
  /// [instance], FirebaseStorage instance to use for remote file operations
  static Future<ListResult> listRemoteImageFiles(FirebaseStorage instance) async {
    try {
      print('[listRemoteImgFiles] Calling listAll()');
      return await instance.ref(remoteImagePath).listAll();
    } catch (e) {
      print('[listRemoteImgFiles] $e');
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
      // if the file exists getMetadata() will succeed and won't throw an exception
      await FirebaseStorage.instance.ref(remoteFile).getMetadata();
      print('[remoteFileExists] File exists: $remoteFile');
      return true;
    } on FirebaseException catch (e) {
      // getMetadata() threw an exception
      if (e.code == 'storage/object-not-found' || 
          e.code == 'object-not-found' ||
          e.code == 'not-found') {
        // This exception indicates the file does not exist
        print('[remoteFileExists] File does not exist: $remoteFile');
        return false;
      }
      else {
        // Something else happened and we don't know if the file does or does not exist
        print('[remoteFileExists] Unexpected error: ${e.code} - ${e.message}');
        rethrow;
      }
    } catch (e) {
      print('[remoteFileExists] Unexpected non-Firebase error: $e');
      rethrow;
    }
  }

  /// Using [firebase_storage], downloads [fileToDownload] from the configured storage bucket to [localFileName].
  /// 
  /// [pathToLocalFile], the directory that the downloaded file will be written to, does not include the file name.
  /// 
  /// [localFileName], the file name that will be used when saving the downloaded file to local path.
  /// 
  /// [storageInstance], the Firebase Storage instance that will be used to download the remote file from (FirebaseStorage.instance).
  /// 
  /// [fileToDownload], reference to remote file that is desired to be downloaded.
  /// 
  /// [downloadingFilesSet], used to track asynchronous file downloads to prevent race conditions when downloading multiple files.
  /// 
  /// Firebase must be initialized prior to invoking [downloadFile], otherwise an exception is thrown.
  static Future<void> downloadFile(
    String pathToLocalFile, 
    String localFileName, 
    FirebaseStorage storageInstance,
    String fileToDownload,
    Set<String> downloadingFilesSet) async {
    print('[$fileToDownload] Starting download: $fileToDownload -> $localFileName');
    
    final downloadToFile = File('$pathToLocalFile/$localFileName');
    
    // Check if file already exists locally
    if (await downloadToFile.exists()) {
      final fileSize = await downloadToFile.length();
      print('[$fileToDownload] File already exists locally ($fileSize bytes), skipping download');
      return;
    }

    // Prevent duplicate simultaneous downloads of the same file
    if (downloadingFilesSet.contains(fileToDownload)) {
      print('[$fileToDownload] Download already in progress, waiting...');
      // Wait for the other download to complete
      while (downloadingFilesSet.contains(fileToDownload)) {
        await Future.delayed(Duration(milliseconds: 100));
      }
      // Check if file now exists after waiting
      if (await downloadToFile.exists()) {
        print('[$fileToDownload] File downloaded by concurrent request');
        return;
      } else {
        print('[$fileToDownload] WARNING: Concurrent download completed but file not found');
      }
      return;
    }
    
    try {
      downloadingFilesSet.add(fileToDownload);
      
      // Check if remote file exists before attempting a download
      if (!await remoteFileExists(fileToDownload)) {
        throw Exception('[$fileToDownload] Remote file does not exist');
      }
      
      // Ensure directory exists before writing
      await downloadToFile.parent.create(recursive: true);
      print('[$fileToDownload] File reference created: ${downloadToFile.path}');
      
      // create storage reference
      final ref = storageInstance.ref(fileToDownload);
      print('[$fileToDownload] Firebase reference: ${ref.fullPath}');
      
      // use getData() to download the data in chunks
      final bytes = await ref.getData();
      if (bytes == null) {
        throw Exception('[$fileToDownload] Failed to download file: no data received');
      }
      
      print('[$fileToDownload] Downloaded ${bytes.length} bytes');

      // Using the bytes recieved from getData(), write them to the local file
      await downloadToFile.writeAsBytes(bytes);
      print('[$fileToDownload] File written successfully to: ${downloadToFile.path}');
      
      // Verify file exists
      if (await downloadToFile.exists()) {
        final fileSize = await downloadToFile.length();
        print('[$fileToDownload] File verified on disk: $fileSize bytes');
      } else {
        throw Exception('[$fileToDownload] File not found after write');
      }
      
    } on FirebaseException catch (e) {
      print('[$fileToDownload] Firebase exception: $e');
      rethrow;
    } catch (e) {
      print('[$fileToDownload] Unexpected error during download: $e');
      rethrow;
    } finally {
      // Always remove from set when done (success or failure)
      downloadingFilesSet.remove(fileToDownload);
    }
  }
}

