import 'dart:io'; // for File

import 'package:flutter/material.dart';
import 'package:yaml/yaml.dart';
import 'package:path_provider/path_provider.dart'; // for directory.path

import 'package:holcomb_tree_trail/ui/main_navigation.dart';
import 'package:holcomb_tree_trail/ui/theme.dart';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


// Create global lists for featured tree list items and pages
var treeIdMap = {};
Map<String, Map<String, String >> treePageData = {};

Future<String> get _localPath async {
  // get path to the documents folder on the device
  final directory = await getApplicationDocumentsDirectory();
  return directory.path;
}

Future<File> _localFile(String fileName) async {
  // create reference to file location
  final path = await _localPath;
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

Future<void> downloadFile(String localFileName, String fileToDownload) async {
  print('Starting download: $fileToDownload -> $localFileName');
  
  try {
    File downloadToFile = await _localFile(localFileName);
    print('File path created: ${downloadToFile.path}');
    
    final storage = FirebaseStorage.instance;
    final ref = storage.ref(fileToDownload);
    print('Firebase reference: ${ref.fullPath}');
    
    // Method 1: getData() - Best for small/medium files (avoids threading issue)
    final bytes = await ref.getData();
    if (bytes == null) {
      throw Exception('Failed to download file: no data received');
    }
    
    print('Downloaded ${bytes.length} bytes');
    await downloadToFile.writeAsBytes(bytes);
    print('File written successfully to: ${downloadToFile.path}');
    
    // Verify file exists
    if (await downloadToFile.exists()) {
      final fileSize = await downloadToFile.length();
      print('File verified on disk: $fileSize bytes');
    } else {
      print('WARNING: File not found after write');
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
    print('Firebase error code: ${e.code}');
    print('Firebase error message: ${e.message}');
    print('Full error: $e');
  } catch (e) {
    print('Unexpected error during download: $e');
    rethrow;
  }
}

Future<String> readFile(String localFileName) async {
  print('Attempting to read file: $localFileName');
  
  try {
    final file = await _localFile(localFileName);
    print('File path: ${file.path}');
    
    // Check if file exists
    if (!await file.exists()) {
      print('File does not exist: ${file.path}');
      return "";
    }
    
    print('File exists, reading...');
    final contents = await file.readAsString();
    print('File read successfully, length: ${contents.length}');
    return contents;
  } catch (e) {
    print('Read error: $e');
    return "";
  }
}

Future<void> main() async {

  /* TODO:
    * implement firebase initialization
    * load and verify assets
    * build list of Trees - DONE
    * build pages and routes for every Tree - DONE
  */

  var treeIdMap = {};
  String yamlString;
  var treeManifestFile = "tree_manifest.yaml";
  var treeManifestFirebasePath = "text/$treeManifestFile";

  var testBody = "**shingle oak** (1-18)\n\n*Quercus imbricaria*\n\nNative to North America, found mainly in the Midwestern and Upper South regions.\n\nThe shingle oak has oval-shaped leaves which look very different than the lobed leaves of most oak species. Its name derives from early Midwestern settlers’ use of this oak to make shingles, *imbricaria* means to place in overlapping pattern, like shingles.\n\nThis shingle oak was one of the first 16 trees planted in 2018, establishing the Holcomb Tree Trail arboretum at Holcomb Farm.";

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

  // check if tree_manifest.yaml exists locally
  // otherwise download from firebase
  final file = await _localFile(treeManifestFile);
  if (await file.exists()) {  // TODO: make this check for file changes too (metadata, checksum, etc.)
    print('File exists on disk');
  } else {
    print("downloading the YAML manifest!");
    downloadFile(treeManifestFile, treeManifestFirebasePath);
  }
  
  print("reading contents of YAML manifest to string");
  yamlString = await readFile(treeManifestFile);

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
  
  try{
    // create treePageData entries for expected trees in the yaml manifest
    for (var id in treeIdMap.keys) {
      /* TODO 
        'body' value will need to be pulled from firebase
        Where should images go?
      */
      treePageData[id] = {'id': id, 'name': treeIdMap[id], 'body': testBody};
    }
  }
  catch(e) {
    // TODO better error handling than this
    print("An error occured while building tree info pages!");
    print(e);
  }
  
  

  var testMap = {'1-18': "shingle oak"};

  for (var id in testMap.keys) {
    
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