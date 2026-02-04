import 'dart:io';

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
}



