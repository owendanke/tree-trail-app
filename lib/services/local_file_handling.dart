import 'dart:io';

import 'package:flutter/foundation.dart';

/*
  Handle local file I/O
*/

class LocalFileHandler {
  /// Creates a File object with [fileName] in ApplicationSupport directory
  /// and returns the reference to the file.
  static Future<File> localFile(Future<String> path, String fileName) async {
    return File('${await path}/$fileName');
  }

  /// Check if a file exists locally
  /// 
  // Future<bool> localFileExists() {}

  /// Reads [localFileName] from Application Support directory and returns the contents as a string.
  /// 
  /// Returns empty string on exception.
  static Future<String> readFile(String pathToLocalFile, String localFileName) async {
    try {
      //final file = await localFile(localFileName);
      File fileToRead = File('$pathToLocalFile/$localFileName');
      debugPrint('[readFile] File path: ${fileToRead.path}');
      
      // Check if file exists
      if (!await fileToRead.exists()) {
        debugPrint('[readFile] File does not exist: ${fileToRead.path}');
        throw Exception('[readFile] File does not exist');
      }
      
      debugPrint('[readFile] File exists, reading');
      //final contents = await fileToRead.readAsString();
      //debugPrint('File read successfully, length: ${contents.length}');
      return await fileToRead.readAsString();
    } catch (e) {
      debugPrint('[readFile] Unexpected exception: $e');
      rethrow;
    }
  }

  /// List number of files in the given directory
  /// 
  static int countFiles(String directoryPath) {
    try {
      var entityList = Directory(directoryPath).listSync(recursive: false, followLinks: false);
      return entityList.length;
    } catch(e) {
      rethrow;
    }
  }
  
  /// Retrieve all the files in the given directory
  /// 
  /// Returns a `List<File>`
  static List<File> listFiles(String directoryPath) {
    List<File> fileList = List.empty(growable: true);
    try {
      var entityList = Directory(directoryPath).listSync(recursive: false, followLinks: false);

      for (var entity in entityList) {
        if (entity is File) {
          fileList.add(entity);
        }
      }

      return fileList;
    } catch(e) {
      rethrow;
    }
  }

  /// Delete a single file, synchonously.
  /// 
  /// [fileName], the name of the file to be deleted (only file name, no path).
  /// 
  /// [directoryPath], directory where the file is located (only path, no file name).
  static bool deleteFileSync(String fileName, String directoryPath) {
    final fileToDelete = File('$directoryPath/$fileName');
    
    if (!Directory(directoryPath).existsSync()) {
      throw Exception('[deleteAllFilesSync] Directory not found: $directoryPath');
    }
    
    if (!fileToDelete.existsSync()) {
      debugPrint('[deleteAllFilesSync] $directoryPath/$fileName does not exist, exiting');
      return true;
    }

    try {
      fileToDelete.deleteSync();
    } catch (e) {
      debugPrint('[deleteAllFilesSync]Error deleting ${fileToDelete.path}: $e');
    }
    
    return true;
  }

  /// Delete multiple files at once, synchonously.
  /// 
  /// [directoryPath], directory where the file is located (only path, no file names).
  static int deleteAllFilesSync(String directoryPath, {bool recursive = false}) {
    final directory = Directory(directoryPath);
    
    if (!directory.existsSync()) {
      throw Exception('[deleteAllFilesSync] Directory not found: $directoryPath');
    }
    
    int deletedCount = 0;
    
    for (final entity in directory.listSync(recursive: recursive, followLinks: false)) {
      if (entity is File) {
        try {
          entity.deleteSync();
          deletedCount++;
        } catch (e) {
          debugPrint('[deleteAllFilesSync]Error deleting ${entity.path}: $e');
        }
      }
    }
    
    return deletedCount;
  }
}



