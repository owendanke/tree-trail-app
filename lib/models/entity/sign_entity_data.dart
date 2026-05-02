import 'dart:io';

import 'package:latlong2/latlong.dart';

import 'package:httapp/models/entity/entity.dart';
import 'package:httapp/models/remote_path.dart';

class SignEntityData extends EntityData {
  final File description;
  final LatLng location;

  const SignEntityData({
    required super.id,
    required super.name,
    required this.description,
    required this.location,
  }) : super(type: EntityType.sign);
}