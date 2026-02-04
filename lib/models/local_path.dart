import 'dart:io';
import 'package:path_provider/path_provider.dart';
/*
  Basic getters for finding local application support directories

*/

/// Get path to the Application Support folder on the device.
/// Creates the path if it doesn't exist
Future<String> get localPath async {
  final directory = await getApplicationSupportDirectory();
  return directory.path;
}

/// Get path to the text directory in ApplicationSupport.
/// Creates the path if it doesn't exist
Future<String> get localTextPath async {
  final directory = await Directory("${await localPath}/text").create();
  return directory.path;
}

/// Get path to the descriptions directory in ApplicationSupport.
/// Creates the path if it doesn't exist
Future<String> get localDescPath async {
  final directory = await Directory("${await localPath}/descriptions").create();
  return directory.path;
}

/// Get path to the images directory in ApplicationSupport.
Future<String> get localImagePath async {
  final directory = await Directory("${await localPath}/images").create();
  return directory.path;
}

/// Get path to the thumbnails directory in ApplicationSupport.
Future<String> get localThumbnailPath async {
  final directory = await Directory("${await localPath}/thumbnails").create();
  return directory.path;
}