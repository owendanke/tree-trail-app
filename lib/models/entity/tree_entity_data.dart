import 'dart:io';

import 'package:latlong2/latlong.dart';

import 'package:httapp/models/entity/entity.dart';
import 'package:httapp/models/remote_path.dart';

class TreeEntityData extends EntityData {
  final File thumbnail;
  final File description;
  final LatLng location;
  final List<File> galleryImages;

  const TreeEntityData({
    required super.id,
    required super.name,
    required this.thumbnail,
    required this.description,
    required this.location,
    required this.galleryImages,
  }) : super(type: EntityType.tree);
}