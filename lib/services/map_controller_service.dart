import 'package:flutter/material.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapControllerService {
  static final MapControllerService _singleton = MapControllerService._internal();
  factory MapControllerService() => _singleton;
  MapControllerService._internal();

  late final MapController mapController;
  bool _initialized = false;
  
  /// Initialize the service
  /// 
  void init() {
    if (_initialized) return;

    // load default values
    mapController = MapController();

    _initialized = true;
  }

  // moveAndRotate(LatLng center, double zoom, double degree, {String? id}) → MoveAndRotateResult 
  void moveAndRotate(LatLng center, double zoom, double degree) {
    try {
      // attempt to rotate and/or move the map
      var result = mapController.moveAndRotate(center, zoom, degree);

      /*
      if (!result.rotateSuccess) {
        // throw an exception because the map failed to rotate
        throw MapServiceException(method: 'moveAndRotate', result: 'rotateSuccess: ${result.rotateSuccess.toString()}');
      }
      */

      if (!result.moveSuccess) {
        // throw an exception because the map failed to move
        throw MapServiceException(method: 'moveAndRotate', result: 'moveSuccess: ${result.moveSuccess.toString()}');
      }

    } catch(e) {
      debugPrint('[MapControllerService] $e');
    }
  }
}

/// Exception thrown when the MapControllerService fails
class MapServiceException implements Exception {
  /// A message describing the exception 
  final String message;

  /// The method the exception is for
  final String method;

  /// The method's result that created the exception
  final String result;

  MapServiceException({
    required this.method,
    required this.result,
    this.message = '',
    });



    @override
  String toString() {
    String output = '[$method] -> $result\n\t $message';

    return output;
  }
}