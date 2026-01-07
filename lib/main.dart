import 'dart:io';

import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'package:path_provider/path_provider.dart'; // for directory.path

import 'package:holcomb_tree_trail/ui/main_navigation.dart';
import 'package:holcomb_tree_trail/ui/theme.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


/// Global Map from [id] to [name]
/// 
/// Used for parsing from tree_manifest.yaml
var treeIdMap = {};

/// Global Map from [id] to the Map {'id': String, 'name': String, 'body': String}
/// 
/// This is for the [TreeTemplatePage] constructor
Map<String, Map<String, String >> treePageData = {};

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

/// Get path to the images directory in ApplicationSupport.
Future<String> get _localImagePath async {
  final directory = await Directory("${getApplicationSupportDirectory()}/images").create();
  return directory.path;
}

/// Creates a File object with [fileName] in ApplicationSupport directory
/// and returns the reference to the file.
Future<File> _localFile(String fileName) async {
  final path = await _localPath;
  return File('$path/$fileName');
}

/// Creates a File object with [fileName] in ApplicationSupport/text directory
/// and returns the reference to the file.
Future<File> _localTextFile(String fileName) async {
  final path = await _localTextPath;
  return File('$path/$fileName');
}

/// Creates a File object with [fileName] in ApplicationSupport/images directory
/// and returns the reference to the file.
Future<File> _localImageFile(String fileName) async {
  final path = await _localImagePath;
  return File('$path/$fileName');
}

/*
Future<void> downloadFile(String localFileName, String fileToDownload) async {
  // Downloads a file from firebase and saves it with the given name
  File downloadToFile = await _localFile(localFileName);

  final storage = FirebaseStorage.instance;

  //Now you can try to download the specified file, and write it to the downloadToFile.
  try {
    // try to download the specified file and write to the file
    await storage.ref(fileToDownload).writeToFile(downloadToFile);
  } on FirebaseException catch (e) {
    // e.g, e.code == 'canceled'
    print('Download error: $e');
  }
}
*/

///
///
/// Returns true or false if a file exists or does not
Future<bool> remoteFileExists(String remoteFile) async {
  final storageRef = FirebaseStorage.instance.ref();

  try {
    // if the file exists getMetadata() will succeed and won't throw an exception
    await storageRef.child(remoteFile).getMetadata();
    return true;
  } on FirebaseException catch (e) {
    // getMetadata() threw an exception
    if (e.code == 'storage/object-not-found') {
      // This exception indicates the file does not exist
      return false;
    }
    else {
      // Something else happened and we don't know if the file does or does not exist
      rethrow;
    }
  }
}

/// Using [firebase_storage], downloads [fileToDownload] from the configured storage bucket to [localFileName].
/// [localFileName] has the Application Support directory as its root.
/// 
/// Firebase must be initialized prior to invoking [downloadFile], otherwise an exception is thrown.
Future<void> downloadFile(String localPath, String localFileName, String fileToDownload) async {
  print('[$fileToDownload] Starting download: $fileToDownload -> $localFileName');

  try {
    // Check if remote file exists before attempting a download
    if (!await remoteFileExists(fileToDownload)) {
      // file doesn't exist
      throw Exception('[$fileToDownload] Remote file does not exist');
    }
    //File downloadToFile = await _localFile(localFileName);
    File downloadToFile = File('$localPath/$localFileName');
    print('[$fileToDownload] File reference created: ${downloadToFile.path}');
    
    final storage = FirebaseStorage.instance;
    final ref = storage.ref(fileToDownload);
    print('[$fileToDownload] Firebase reference: ${ref.fullPath}');

    // Method 1: getData() - Best for small/medium files (avoids threading issue)
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
      print('[$fileToDownload] WARNING: File not found after write');
    }
    
    /* Alternative Method 2: writeToFile with proper error handling
    // Use this for large files if needed (but upgrade plugin first!)
    try {
      final task = ref.writeToFile(downloadToFile);
      await task;
      print('Download successful: $localFileName');
    } catch (e) {
      // Ignore threading warnings, check if file was written
      if (await downloadToFile.exists()) {
        print('File downloaded despite threading warning');
      } else {
        rethrow;
      }
    }
    */
  } on FirebaseException catch (e) {
    print('[$fileToDownload] Firebase error code: ${e.code}');
    print('[$fileToDownload] Firebase error message: ${e.message}');
    print('[$fileToDownload] Full error: $e');
  } catch (e) {
    print('[$fileToDownload] Unexpected error during download: $e');
    rethrow;
  }
}

/// Reads [localFileName] from Application Support directory and returns the contents as a string.
/// 
/// Returns empty string on exception.
Future<String> readFile(String localPath, String localFileName) async {
  print('Attempting to read file: $localFileName');
  
  try {
    //final file = await _localFile(localFileName);
    File fileToRead = File('$localPath/$localFileName');
    print('File path: ${fileToRead.path}');
    
    // Check if file exists
    if (!await fileToRead.exists()) {
      print('File does not exist: ${fileToRead.path}');
      return "";
    }
    
    print('File exists, reading...');
    final contents = await fileToRead.readAsString();
    print('File read successfully, length: ${contents.length}');
    return contents;
  } catch (e) {
    print('Read error: $e');
    return "";
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
      final file = await _localTextFile(localFileName);
      
      // check if local file with extension exists
      if (await file.exists()) {
        // TODO: make this check for file changes too (metadata, checksum, etc.)
        // return the contents of the file as a string
        return await readFile(await _localTextPath, localFileName);
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

        print("downloading description for tree $id");
        // download the file to the appropriate location
        downloadFile(await _localTextPath, localFileName, remoteFileName);
        // return the contents of the file as a string
        return await readFile(await _localTextPath, localFileName);
      }
      // else: continue search and either find it and return or come up empty and move on
    }
    // if we haven't returned any string yet it means we haven't found a local or remote file (Bad!)
    throw Exception('No description exists locally or remote.');

  } on FirebaseException catch(e) {
    print('[$id] FirebaseException occured: $e');
    // return empty string
    return "An error occured when fetching the description.";
  } catch (e) {
    print('[$id] $e');
    // return empty string
    return "An error occured when fetching the description.";
  }
}

Future<void> main() async {
  String yamlString;
  var treeIdMap = {};
  final treeManifestFile = "tree_manifest.yaml";
  var treeManifestFirebasePath = "text/$treeManifestFile";

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

  // check if tree_manifest.yaml exists in local text directory, otherwise download from firebase
  var file = await _localTextFile(treeManifestFile);
  if (await file.exists()) {  // TODO: make this check for file changes too (metadata, checksum, etc.)
    print('File exists on disk');
  } 
  else {
    print("downloading the YAML manifest!");
    downloadFile(await _localTextPath, treeManifestFile, treeManifestFirebasePath);
  }
  
  print("reading contents of YAML manifest to string");
  yamlString = await readFile(await _localTextPath, treeManifestFile);

  try {
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
  // TODO Where do images go? 
  try{
    for (var id in treeIdMap.keys) {
      var descriptionString = await _treeDescription(id); //_treeDescription handles missing files
      
      treePageData[id] = {'id': id, 'name': treeIdMap[id], 'body': descriptionString};
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