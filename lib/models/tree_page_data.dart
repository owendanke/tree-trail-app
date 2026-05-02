import 'dart:io';

import 'package:latlong2/latlong.dart';

/// TreePageData holds information requred for creating tree pages from the template
/// 
///
class TreePageData {
  final String id;
  final String name;
  final String body;
  final LatLng location;
  final List<File> imageFileList;
  final File thumbnailFile;

  TreePageData({
    required this.id,
    required this.name,
    required this.body,
    required this.location,
    required this.imageFileList,
    required this.thumbnailFile,
  });

  
}