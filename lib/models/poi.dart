import 'package:latlong2/latlong.dart';

class PointOfInterest {
  final String name;
  final String description;
  final LatLng location;

  PointOfInterest({
    required this.name,
    required this.description,
    required this.location,
  });
}