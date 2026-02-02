import 'dart:io';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:yaml/yaml.dart';
import 'package:path_provider/path_provider.dart'; // for directory.path

import 'package:httapp/ui/main_navigation.dart';
import 'package:httapp/ui/theme.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'firebase_options.dart';


/// Global Map from [id] to [name]
/// 
/// Used for parsing from tree_manifest.yaml
var treeIdMap = {};

/// Global Map from [id] to the Map {'id': String, 'name': String, 'body': String, 'imageFileList': List`<`File`>`, 'thmFile': File}
/// 
/// This is for the [TreeTemplatePage] constructor
Map<String, Map<String, dynamic >> treePageData = {};

// track current downloads to prevent race conditions
final Set<String> _downloadingFiles = {};

final _remoteTextPath = 'text/';
final _remoteDescriptionPath = 'description/';
final _remoteImagePath = 'images/';
final _remoteThumbnailPath = 'images/thumbnails/';

/// Get path to the Application Support folder on the device.
/// Creates the path if it doesn't exist
Future<String> get _localPath async {
  final directory = await getApplicationSupportDirectory();
  return directory.path;
}

/// Get path to the text directory in ApplicationSupport.
/// Creates the path if it doesn't exist
Future<String> get _localTextPath async {
  final directory = await Directory("${await _localPath}/text").create();
  return directory.path;
}

/// Get path to the descriptions directory in ApplicationSupport.
/// Creates the path if it doesn't exist
Future<String> get _localDescPath async {
  final directory = await Directory("${await _localPath}/descriptions").create();
  return directory.path;
}

/// Get path to the images directory in ApplicationSupport.
Future<String> get _localImagePath async {
  final directory = await Directory("${await _localPath}/images").create();
  return directory.path;
}

/// Get path to the thumbnails directory in ApplicationSupport.
Future<String> get _localThumbnailPath async {
  final directory = await Directory("${await _localPath}/thumbnails").create();
  return directory.path;
}

/// Creates a File object with [fileName] in ApplicationSupport directory
/// and returns the reference to the file.
Future<File> _localFile(Future<String> path, String fileName) async {
  return File('${await path}/$fileName');
}

/// Returns true or false if a file exists or does not
/// 
/// Passes exceptions through
Future<bool> remoteFileExists(String remoteFile) async {
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
/// [localFileName] has the Application Support directory as its root.
/// 
/// Firebase must be initialized prior to invoking [downloadFile], otherwise an exception is thrown.
Future<void> downloadFile(String pathToLocalFile, String localFileName, String fileToDownload) async {
  print('[$fileToDownload] Starting download: $fileToDownload -> $localFileName');
  
  final downloadToFile = File('$pathToLocalFile/$localFileName');
  
  // Check if file already exists locally
  if (await downloadToFile.exists()) {
    final fileSize = await downloadToFile.length();
    print('[$fileToDownload] File already exists locally ($fileSize bytes), skipping download');
    return;
  }
  
  // Prevent duplicate simultaneous downloads of the same file
  if (_downloadingFiles.contains(fileToDownload)) {
    print('[$fileToDownload] Download already in progress, waiting...');
    // Wait for the other download to complete
    while (_downloadingFiles.contains(fileToDownload)) {
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
    _downloadingFiles.add(fileToDownload);
    
    // Check if remote file exists before attempting a download
    if (!await remoteFileExists(fileToDownload)) {
      throw Exception('[$fileToDownload] Remote file does not exist');
    }
    
    // Ensure directory exists before writing
    await downloadToFile.parent.create(recursive: true);
    print('[$fileToDownload] File reference created: ${downloadToFile.path}');
    
    final storage = FirebaseStorage.instance;
    final ref = storage.ref(fileToDownload);
    print('[$fileToDownload] Firebase reference: ${ref.fullPath}');
    
    // Method 1: getData() - Best for small/medium files
    final bytes = await ref.getData();
    if (bytes == null) {
      throw Exception('[$fileToDownload] Failed to download file: no data received');
    }
    
    print('[$fileToDownload] Downloaded ${bytes.length} bytes');
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
    _downloadingFiles.remove(fileToDownload);
  }
}

/// Reads [localFileName] from Application Support directory and returns the contents as a string.
/// 
/// Returns empty string on exception.
Future<String> readFile(String pathToLocalFile, String localFileName) async {
  try {
    //final file = await _localFile(localFileName);
    File fileToRead = File('$pathToLocalFile/$localFileName');
    print('[readFile] File path: ${fileToRead.path}');
    
    // Check if file exists
    if (!await fileToRead.exists()) {
      print('[readFile] File does not exist: ${fileToRead.path}');
      throw Exception('[readFile] File does not exist');
    }
    
    print('[readFile] File exists, reading');
    //final contents = await fileToRead.readAsString();
    //print('File read successfully, length: ${contents.length}');
    return await fileToRead.readAsString();
  } catch (e) {
    print('[readFile] Unexpected exception: $e');
    rethrow;
  }
}

/// Getter for tree description files from firebase or Application Support directory.
/// 
/// Requires the firebase side file name to follow the scheme {id}_description.markdown
/// and be located at descriptions/{id}_description
/// 
/// Returns the contents of the file as a string
Future<String> _treeDescription(String id) async {
  // extensions hold possible markdown file extensions
  // descFileTilte is only the name, doesn't include extension, example: '88-22_description'
  var extensions = ['.md', '.markdown'];
  var descFileTitle = '${id}_description';

  try {
    // iterate through markdown file extension possibilites
    for (final ext in extensions) {
      // localFileName is the full file, example: '88-22_description.md'
      final localFileName = '$descFileTitle$ext';
      final file = await _localFile(_localDescPath, localFileName);
      
      // check if local file with extension exists
      if (await file.exists()) {
        // TODO: make this check for file changes too (metadata, checksum, etc.)
        // return the contents of the file as a string
        return await readFile(await _localDescPath, localFileName);
      }
      // else: continue search and either find it and return or come up empty and move on
    }
    // incremental search fails to find local file
    // download file, but we don't know the extension
    // again we iterate through markdown file extension possibilites
    for (final ext in extensions) {
      final localFileName = '$descFileTitle$ext';
      final remoteFileName = 'descriptions/$localFileName';

      if (await remoteFileExists(remoteFileName)) {

        print("[treeDescription $id] downloading description");
        // download the file to the appropriate location
        await downloadFile(await _localDescPath, localFileName, remoteFileName);
        // return the contents of the file as a string
        return await readFile(await _localDescPath, localFileName);
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

Future<ListResult> get _listRemoteImageFiles async {
  try {
    print('[listRemoteImgFiles] Calling listAll()');
    return await FirebaseStorage.instance.ref(_remoteImagePath).listAll();
  } catch (e) {
    print('[listRemoteImgFiles] $e');
    rethrow;
  }
}

Future<List<File>> _treeImgFileList(String id, ListResult resultList) async {
  // images have the format '{tree-id}_{number}.jpg'
  //RegExp filePattern = RegExp(r'^\d{2,3}-\d{2}_\d+\.jpg$');

  List<File> imageFileList = List.empty(growable: true);  // list to return

  print('[treeImgFileList $id] resultList length: ${imageFileList.length}');
  try {
    for (var item in resultList.items) {
      final fileName = item.name;
      final remoteFileName = '$_remoteImagePath$fileName';

      //if (fileName.startsWith('${id}_') && filePattern.hasMatch(fileName)) { 
      if (fileName.startsWith('${id}_')) {
        // Check if file matches pattern and starts with the correct tree ID
        print('[treeImgFileList $id] Matching file: $fileName');

        // create file object
        final localFile = await _localFile(_localImagePath, fileName);
        print('[treeImgFileList $id] created local file reference: ${localFile.path}');

        //check if file exists locally or needs to be downloaded
        if (await localFile.exists()) {
          // no need to download, just add to the list and return at the end
          print('[treeImgFileList $id] adding local file to list: $fileName');
          imageFileList.add(localFile);
        }
        else { // file is not on device and needs to be downloaded
          if (await remoteFileExists(remoteFileName)) {
            // download image to the local image directory
            print('[treeImgFileList $id] downloading file: remoteFileName');
            await downloadFile(await _localImagePath, fileName, remoteFileName);
    
            // append a File object that points to the newly downloaded file
            print('[treeImgFileList $id] adding downloaded file to list: remoteFileName');
            imageFileList.add(localFile);
          }
          else {
            print('[treeImgFileList $id] remote file does not exist: remoteFileName');
          }
        }
      }
      else {
        print('[treeImgFileList $id] No matching files');
      }
    } // for

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


Future<File> _thmFile(String id) async {
  final fileName = '${id}_thm.jpg';    // thumbnails have the format '{tree-id}_thm.jpg'
  final remoteFileName = '$_remoteThumbnailPath$fileName';  // directory to the remote file

  File thmFile = await _localFile(_localThumbnailPath, fileName);    // File object to return

  try {
    
      // check if file exists locally or needs to be downloaded
      if (thmFile.existsSync()) {
        // no need to download, just return file
        print('[thmFile $id] Returning matching file: ${thmFile.path}');
        return thmFile;
      }
      else { 
        // file is not on device and needs to be downloaded
        if (await remoteFileExists(remoteFileName)){
          print('[thmFile $id] downloading file: $remoteFileName');
          // download thumbnail to the local directory
          await downloadFile(await _localThumbnailPath, fileName, remoteFileName);
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

///
/// On success: returns yaml manifest as string
///
/// On exception: returns empty string
Future<String> _loadManifest(String localFileName, remoteFileName) async {
  var manifestPath = _localPath;

  try {
    var localFile = await _localFile(manifestPath, localFileName);
    // check file is local
    if (await localFile.exists()) {
      print('[loadManifest] File exists locally, reading');
      return await readFile(await manifestPath, localFileName);
    }
    else {
      print('[loadManifest] File does not exists locally, downloading');
      await downloadFile(await manifestPath, localFileName, remoteFileName);
      print('[loadManifest] File downloaded, reading');
      return await readFile(await manifestPath, localFileName);
    }
  } on FirebaseException catch(e) {
    print('[loadManifest] Firebase Exception: $e');
    return '';
  } catch (e) {
    print('[loadManifest] Unexpected Exception: $e');
    return '';
  }
}

Future<void> main() async {
  String yamlString;
  var treeIdMap = {};
  final treeManifestFile = "tree_manifest.yaml";
  final remoteTreeManifest = "text/$treeManifestFile";

  /*
   Begin building map of ID to Tree name
   First step reads YAML stream into treeIdMap. Converts list of Maps to a single Map
   Next step builds treePageData that holds everything a page needs 
   */

  // initialize Firebase  
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Activate App Check with automatic provider selection
  await FirebaseAppCheck.instance.activate(
    // On Android, use debug provider in debug mode, Play Integrity in release
    providerAndroid: kDebugMode
        ? AndroidDebugProvider()
        : AndroidPlayIntegrityProvider(),
    
    // On iOS, use debug provider in debug mode, App Attest in release
    //providerApple: kDebugMode 
    //    ? AppleProvider.debug 
    //    : AppleProvider.appAttest,
    providerApple: kDebugMode
      ? AppleDebugProvider()
      : AppleDeviceCheckProvider()
  );

  try {
    // read tree_manifest.yaml
    yamlString = await _loadManifest(treeManifestFile, remoteTreeManifest);

    // read the YAML Stream
    var treeDoc = loadYamlStream(yamlString);

    // convert the YamlList into a Map<dynamic, dynamic>
    for (var entry in treeDoc) {
      treeIdMap.addAll(entry);
    }
  }
  catch(e) {
    // TODO better error handling than this
    print("An error occured while parsing the YAML manifest!");
    print(e);
  }
  
  // create treePageData entries for expected trees in the yaml manifest
  try{
    // save a ListResult to reference during loop
    final imageListResult = await _listRemoteImageFiles;

    for (var id in treeIdMap.keys) {
      // retrieve the description, images, and thumbnails
      var descriptionString = await _treeDescription(id);   // description is pulled from internet here
      File thmFile = await _thmFile(id);   // thumbnail is pulled from internet here
      List<File> imageFileList = await _treeImgFileList(id, imageListResult);   // image is pulled from internet here
      

      print('[main][treePageData $id] imageFileList: $imageFileList');
      
      // add the matching remote data to the 
      treePageData[id] = {'id': id, 'name': treeIdMap[id], 'body': descriptionString, 'imageFileList': imageFileList, 'thmFile': thmFile};
    }
  }
  catch(e) {
    // TODO better error handling than this
    print("An error occured while building tree info pages!");
    print(e);
  }
  
  // begin rendering the app widget, bootstrap the render tree
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holcomb Tree Trail',
      //theme: ThemeData.from(colorScheme: MaterialTheme.lightScheme(), textTheme: GoogleFonts.latoTextTheme()),
      theme: MaterialTheme().light(),
      //home: HomePage(title: 'Home Page'),
      home: const MainNavigation(), // use MainNavigation instead of HomePage
    );
  }
}