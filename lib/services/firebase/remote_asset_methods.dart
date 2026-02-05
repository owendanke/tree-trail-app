/*
  Methods here retrieve the required assets for the app
*/

// dart
import 'dart:collection';
import 'dart:io';
import 'dart:core';

// httapp
import 'package:flutter/foundation.dart';
import 'package:httapp/models/local_path.dart';
import 'package:httapp/models/remote_path.dart';
import 'package:httapp/services/firebase/remote_file_handling.dart';
import 'package:httapp/services/local_file_handling.dart';

// Firebase
import 'package:firebase_storage/firebase_storage.dart';


class RemoteAssets {
  final FirebaseStorage instance;
  final Set<String> downloadingFilesSet;

  RemoteAssets ({required this.instance, required this.downloadingFilesSet});
  
  /// On success: returns yaml manifest as string
  ///
  /// On exception: returns empty string
  Future<String> loadManifest(String localFileName) async {
    var manifestPath = localPath;
    var remoteFileName = '$remoteTextPath/tree_manifest.yaml';

    try {
      var localManifestFile = await LocalFileHandler.localFile(manifestPath, localFileName);

      // check file exists locally
      if (await localManifestFile.exists()) {
        debugPrint('[loadManifest] File exists locally, reading');
        return await LocalFileHandler.readFile(await manifestPath, localFileName);
      }
      else {
        debugPrint('[loadManifest] File does not exists locally, downloading');
        await remoteFileHandler.downloadFile(await manifestPath, localFileName, instance, remoteFileName, downloadingFilesSet);

        debugPrint('[loadManifest] File downloaded, reading');
        return await LocalFileHandler.readFile(await manifestPath, localFileName);
      }
    } on FirebaseException catch(e) {
      debugPrint('[loadManifest] Firebase Exception: $e');
      return '';
    } catch (e) {
      debugPrint('[loadManifest] Unexpected Exception: $e');
      return '';
    }
  }

  /// Getter for tree description files from firebase or Application Support directory.
  /// 
  /// Requires the firebase side file name to follow the scheme {id}_description.markdown
  /// and be located at descriptions/{id}_description
  /// 
  /// Returns the contents of the file as a string
  Future<String> treeDescription(String id) async {
    // extensions hold possible markdown file extensions
    // descFileTilte is only the name, doesn't include extension, example: '88-22_description'
    var extensions = ['.md', '.markdown'];
    var descFileTitle = '${id}_description';

    try {
      // iterate through markdown file extension possibilites
      for (final ext in extensions) {
        // localFileName is the full file, example: '88-22_description.md'
        var localFileName = '$descFileTitle$ext';
        var localDescFile = await LocalFileHandler.localFile(localDescPath, localFileName);
        
        // check if local file with extension exists
        if (localDescFile.existsSync()) {
          // TODO: make this check for file changes too (metadata, checksum, etc.)
          // return the contents of the file as a string
          return await LocalFileHandler.readFile(await localDescPath, localFileName);
        }
        // else: continue search and either find it and return or come up empty and move on
      }

      // incremental search fails to find local file
      // download file, but we don't know the extension
      // again we iterate through markdown file extension possibilites
      for (final ext in extensions) {
        var localFileName = '$descFileTitle$ext';
        var remoteFileName = '$remoteDescriptionPath/$localFileName';

        if (await remoteFileHandler.remoteFileExists(remoteFileName)) {

          debugPrint("[treeDescription $id] downloading description");
          // download the file to the appropriate location
          await remoteFileHandler.downloadFile(await localDescPath, localFileName, instance, remoteFileName, downloadingFilesSet);
          // return the contents of the file as a string
          return await LocalFileHandler.readFile(await localDescPath, localFileName);
        }
        // else: continue search and either find it and return or come up empty and move on
      }
      // if we haven't returned any string yet it means we haven't found a local or remote file (Bad!)
      throw Exception('No description exists locally or remote.');

    } on FirebaseException catch(e) {
      debugPrint('[treeDescription $id] FirebaseException occured: $e');
      // return empty string
      return "An error occured when fetching the description.";
    } catch (e) {
      debugPrint('[treeDescription $id] $e');
      // return empty string
      return "An error occured when fetching the description.";
    }
  }



  Future<List<File>> treeImgFileList(String id, ListResult resultList) async {
    // images have the format '{tree-id}_{incremental-number}.jpg'

    List<File> imageFileList = List.empty(growable: true);  // list to return

    debugPrint('[treeImgFileList $id] resultList length: ${resultList.items.length}');
    try {
      for (var item in resultList.items) {
        var fileName = item.name;
        var remoteFileName = '$remoteImagePath/$fileName';

        if (fileName.startsWith('${id}_')) {
          // Check if file with the correct tree ID exists in resultList
          debugPrint('[treeImgFileList $id] Matching file: $fileName');

          // create file object
          final localFile = await LocalFileHandler.localFile(localImagePath, fileName);
          debugPrint('[treeImgFileList $id] created local file reference: ${localFile.path}');

          //check if file exists locally or needs to be downloaded
          if (localFile.existsSync()) {
            // no need to download, just add to the list and return at the end
            debugPrint('[treeImgFileList $id] adding local file to list: $fileName');
            imageFileList.add(localFile);
          }
          else { // file is not on device and needs to be downloaded
            if (await remoteFileHandler.remoteFileExists(remoteFileName)) {
              // download image to the local image directory
              debugPrint('[treeImgFileList $id] downloading file: $remoteFileName');
              await remoteFileHandler.downloadFile(await localImagePath, fileName, instance, remoteFileName, downloadingFilesSet);
      
              // append a File object that points to the newly downloaded file
              debugPrint('[treeImgFileList $id] adding downloaded file to list: $remoteFileName');
              imageFileList.add(localFile);
            }
            else {
              debugPrint('[treeImgFileList $id] remote file does not exist: $remoteFileName');
            }
          }
        }
      } // for

      debugPrint('[treeImgFileList $id] number of images found: ${imageFileList.length}');

      return imageFileList;

    } on FirebaseException catch(e) {
      debugPrint('[treeImgFileList $id] FirebaseException occured: $e');
      // return empty list
      return imageFileList;
    } catch (e) {
      debugPrint('[treeImgFileList $id] $e');
      // return empty list
      return imageFileList;
    }
  }

  /// Loads the thumbnail image required for TreeTemplateItem
  /// 
  /// [id] the tree-id needed for finding correct file
  /// 
  /// This method returns `Future<Uint8List>` if the file is successfully aquired,
  /// otherwise `null` is returned.
  Future<Uint8List?> loadThumbnailFile(String id) async {
    // thumbnails have the format '{tree-id}_thm.jpg'
    final fileName = '${id}_thm.jpg';

    // directory to the remote file
    final remoteFileName = '$remoteThumbnailPath/$fileName';

    // local thumbnail file
    File thmFile = await LocalFileHandler.localFile(localThumbnailPath, fileName);

    try {
        // check if file exists locally or needs to be downloaded
        if (thmFile.existsSync()) {
          // local file exists
          debugPrint('[loadThumbnailFile $id] Local file exists: \'${thmFile.path}\'.');

          debugPrint('[loadThumbnailFile $id] Reading entire file as list of bytes.');

          // read and return the file
          return thmFile.readAsBytes();
        }
        else { 
          // file is not on device and needs to be downloaded
          debugPrint('[loadThumbnailFile $id] Local file does not exist, attempting download.');

          if (await remoteFileHandler.remoteFileExists(remoteFileName)){
            // the thumbnail file exists on the server
            debugPrint('[loadThumbnailFile $id] Downloading file: \'$remoteFileName\'.');

            // download thumbnail to the local directory

            await remoteFileHandler.downloadFile(await localThumbnailPath, fileName, instance, remoteFileName, downloadingFilesSet);

            // read and return the file
            debugPrint('[loadThumbnailFile $id] Reading entire file as list of bytes.');
            
            return thmFile.readAsBytes();
          }
          else {
            throw Exception('Remote file does not exist');
          }
        }

    } on FirebaseException catch(e) {
      debugPrint('[loadThumbnailFile $id] FirebaseException occured: $e');

      // return empty list
      return null;
    } catch (e) {
      debugPrint('[loadThumbnailFile $id] An exception occurred: $e');
      
      // return empty list
      return null;
    }
  }
}