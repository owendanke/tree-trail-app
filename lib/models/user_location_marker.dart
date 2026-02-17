// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

// pub.dev
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class UserLocationMarker {
  static Marker build(LatLng? location) {

    return Marker(
        point: (location == null)
          ? LatLng(51.507433, -0.076658)  // London
          : location,   // user location
        width: 40,
        height: 40,
        child: Icon(Icons.gps_fixed, color: Colors.blue, size: 32)
      );
  }
}