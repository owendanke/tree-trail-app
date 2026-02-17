// Flutter
import 'package:flutter/material.dart';

// pub.dev
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

// httapp
import 'package:httapp/exceptions/map_service_exception.dart';

class MapControllerService {
  static final MapControllerService _singleton = MapControllerService._internal();
  factory MapControllerService() => _singleton;
  MapControllerService._internal();

  late final MapController mapController;
  bool _initialized = false;
  String? selectedPoiId;
  
  /// Initialize the service
  /// 
  /// creates a new MapController if init has never been called before
  void init() {
    if (_initialized) return;

    // load default values
    mapController = MapController();

    _initialized = true;
  }

  /// Set the [selectedPoiId] to the provided id value.
  void selectPoi(String poiId) {
    selectedPoiId = poiId;
  }

  /// Deselects the current [selectedPoiId] to null
  void deselectPoi() {
    selectedPoiId = null;
  }

  // moveAndRotate(LatLng center, double zoom, double degree, {String? id}) → MoveAndRotateResult 
  void moveAndRotate(LatLng center, double zoom, double degree) {
    try {
      // check if init has been called,
      // indicates if a MapController exists
      if (!_initialized) {
        throw MapServiceException(
          method: 'moveAndRotate',
          result: 'uninitialized',
          message: 'Please call init() to start the service before attempting to use any methods.'
        );
      }

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