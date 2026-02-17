// Copyright (c) 2026, Owen Danke

// pub.dev
import 'package:latlong2/latlong.dart';

class PointOfInterest {
  final String id;
  final String name;
  final LatLng location;

  PointOfInterest({
    required this.id,
    required this.name,
    required this.location,
  });
}