/*
  Methods here retrieve the required assets for the app
*/

// dart
import 'dart:io';
import 'dart:core';

// httapp
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
        print('[loadManifest] File exists locally, reading');
        return await LocalFileHandler.readFile(await manifestPath, localFileName);
      }
      else {
        print('[loadManifest] File does not exists locally, downloading');
        await remoteFileHandler.downloadFile(await manifestPath, localFileName, instance, remoteFileName, downloadingFilesSet);

        print('[loadManifest] File downloaded, reading');
        return await LocalFileHandler.readFile(await manifestPath, localFileName);
      }
    } on FirebaseException catch(e) {
      print('[loadManifest] Firebase Exception: $e');
      return '';
    } catch (e) {
      print('[loadManifest] Unexpected Exception: $e');
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

          print("[treeDescription $id] downloading description");
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
      print('[treeDescription $id] FirebaseException occured: $e');
      // return empty string
      return "An error occured when fetching the description.";
    } catch (e) {
      print('[treeDescription $id] $e');
      // return empty string
      return "An error occured when fetching the description.";
    }
  }



  Future<List<File>> treeImgFileList(String id, ListResult resultList) async {
    // images have the format '{tree-id}_{number}.jpg'
    // tree-id format:' {incremental count starting with 1}-{year planted}'
    RegExp filePattern = RegExp(r'^\d+-\d{2}_\d+\.jpg$');

    List<File> imageFileList = List.empty(growable: true);  // list to return

    print('[treeImgFileList $id] resultList length: ${resultList.items.length}');
    try {
      for (var item in resultList.items) {
        var fileName = item.name;
        var remoteFileName = '$remoteImagePath/$fileName';

        if (fileName.startsWith('${id}_')) {
          // Check if file with the correct tree ID exists in resultList
          print('[treeImgFileList $id] Matching file: $fileName');

          // create file object
          final localFile = await LocalFileHandler.localFile(localImagePath, fileName);
          print('[treeImgFileList $id] created local file reference: ${localFile.path}');

          //check if file exists locally or needs to be downloaded
          if (localFile.existsSync()) {
            // no need to download, just add to the list and return at the end
            print('[treeImgFileList $id] adding local file to list: $fileName');
            imageFileList.add(localFile);
          }
          else { // file is not on device and needs to be downloaded
            if (await remoteFileHandler.remoteFileExists(remoteFileName)) {
              // download image to the local image directory
              print('[treeImgFileList $id] downloading file: $remoteFileName');
              await remoteFileHandler.downloadFile(await localImagePath, fileName, instance, remoteFileName, downloadingFilesSet);
      
              // append a File object that points to the newly downloaded file
              print('[treeImgFileList $id] adding downloaded file to list: $remoteFileName');
              imageFileList.add(localFile);
            }
            else {
              print('[treeImgFileList $id] remote file does not exist: $remoteFileName');
            }
          }
        }
      } // for

      print('[treeImgFileList $id] number of images found: ${imageFileList.length}');

      return imageFileList;

    } on FirebaseException catch(e) {
      print('[treeImgFileList $id] FirebaseException occured: $e');
      // return empty list
      return imageFileList;
    } catch (e) {
      print('[treeImgFileList $id] $e');
      // return empty list
      return imageFileList;
    }
  }


  Future<File> thumbnailFile(String id) async {
    final fileName = '${id}_thm.jpg';    // thumbnails have the format '{tree-id}_thm.jpg'
    final remoteFileName = '$remoteThumbnailPath/$fileName';  // directory to the remote file

    File thmFile = await LocalFileHandler.localFile(localThumbnailPath, fileName);    // File object to return

    try {
      
        // check if file exists locally or needs to be downloaded
        if (thmFile.existsSync()) {
          // no need to download, just return file
          print('[thmFile $id] Returning matching file: ${thmFile.path}');
          return thmFile;
        }
        else { 
          // file is not on device and needs to be downloaded
          if (await remoteFileHandler.remoteFileExists(remoteFileName)){
            print('[thmFile $id] downloading file: $remoteFileName');
            // download thumbnail to the local directory
            await remoteFileHandler.downloadFile(await localThumbnailPath, fileName, instance, remoteFileName, downloadingFilesSet);
            // return file
            print('[thmFile $id] Returning downloaded file: ${thmFile.path}');
            return thmFile;
          }
          else {
            throw Exception('Remote file does not exist');
          }
        }

    } on FirebaseException catch(e) {
      print('[thmFile $id] FirebaseException occured: $e');
      // return empty list
      return thmFile;
    } catch (e) {
      print('[thmFile $id] $e');
      // return empty list
      return thmFile;
    }
  }
}