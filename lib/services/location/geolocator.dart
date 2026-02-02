import 'dart:async';

import 'package:geolocator/geolocator.dart';

Future<void> _checkLocationEnabled() async {
   // Test if location services are enabled.
  final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

  if (!serviceEnabled) {
    // Location services are not enabled don't continue
    // accessing the position and request users of the 
    // App to enable the location services.
    
    throw LocationServiceDisabledException();
    //return Future.error('Location services are disabled.');
  }
}

Future<void> _checkPermission() async {
  // Test if location permissions are allowed
  LocationPermission permission = await Geolocator.checkPermission();

  // Permissions are denied
  if (permission == LocationPermission.denied) {
    // request permission to use location
    permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      // Permissions are denied, next time you could try
      // requesting permissions again (this is also where
      // Android's shouldShowRequestPermissionRationale 
      // returned true. According to Android guidelines
      // your App should show an explanatory UI now.

      throw PermissionDeniedException('Location permissions are denied.');
      //return Future.error('Location permissions are denied');
    }
  }
  
  // Permissions are denied forever
  if (permission == LocationPermission.deniedForever) {
    // Cannot request permission because permission has been permanently denied.

    throw PermissionDeniedException('Location permissions are permanently denied, we cannot request permissions.');
    //return Future.error('Location permissions are permanently denied, we cannot request permissions.');
  }
}

Future<Position> determinePosition() async {
  try {
    // Test if location services are enabled.
    await _checkLocationEnabled();

    // Test if permission is granted
    await _checkPermission();
  } catch(e) {
    rethrow;
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return await Geolocator.getCurrentPosition();
}

Future<Stream<Position>> getPositionStream() async {
  try {
    // Test if location services are enabled.
    await _checkLocationEnabled();

    // Test if permission is granted
    await _checkPermission();
  } catch(e) {
    print('[getPositionStream] is returning Stream<Position>.empty() because an exception occured checking permissions:');
    print(e);

    return Stream<Position>.empty();
  }

  // When we reach here, permissions are granted and we can
  // continue accessing the position of the device.
  return Geolocator.getPositionStream();
}