import 'dart:convert';
import 'package:httapp/models/poi.dart';
import 'package:latlong2/latlong.dart';

class GeojsonParse {
  /*
    Parses a GeoJSON file specifically for this project so it doesn't implement everything.
    Implements feature collections, features, points, and properties.
  */
  static List<PointOfInterest> parsePointOfInterests(String geoJsonString) {
    final Map<String, dynamic> geoJson = jsonDecode(geoJsonString);

    return parseFeatureCollection(geoJson);
  }

  /*
    Parse feature collection in GeoJSON,
    {
      "type": "FeatureCollection",
      "features": [{
        "type": "Feature",
        "geometry": {
          "type": "Point",
          "coordinates": [102.0, 0.5]
        },
        "properties": {
          "prop0": "value0"
          "prop1": "value1"
        }
      }]
    }
  */
  static List<PointOfInterest> parseFeatureCollection(Map<String, dynamic> geoJson) {
    List<Map<String, dynamic>> features;

    if (geoJson['type'] != 'FeatureCollection') {
      throw FormatException('GeoJSON is not a FeatureCollection');
    }

    features = (geoJson['features'] as List)
      .map((e) => Map<String, dynamic>.from(e))
      .toList();
    
    return features
        .where((f) => f['type'] == 'Feature')
        .map(parseFeature)
        .whereType<PointOfInterest>()
        .toList();
  }

  /*
    Parse a feature section of GeoJSON,
    {
	   "type": "Feature",
	   "geometry": {
		   "type": "Point",
		   "coordinates": [102.0, 0.5]
	   },
	   "properties": {
		   "prop0": "value0"
       "prop1": "value1"
	   }
   }
  */
  static PointOfInterest? parseFeature(Map<String, dynamic> feature) {
    final geometry = feature['geometry'];
    Map<String, String> properties;
    LatLng point;

    /*
    if (geometry['type'] != 'Point' || geometry == null) {
      return null;
    }
    */

    if (geometry['type'] == 'Point') {
      point = parsePoint(geometry);

      properties = (feature['properties'] is Map)
        ? parseProperties(feature['properties'])
        : {};

      return PointOfInterest(
        id: properties['id'] ?? '',
        name: properties['name'] ?? '',
        location: point,
      );
    }
    else {
      return null;
    }
  }

  /*
    Parse a point from GeoJSON,
    {
      "type": "Point",
      "coordinates": [102.0, 0.5]
    }
  */
  static LatLng parsePoint(Map<String, dynamic> geometry) {
    final List coordinates = geometry['coordinates'];
    double latitude, longitude;

    if (coordinates.length < 2) {
      throw FormatException('[parsePoint] Invalid Point coordinates');
    }

    latitude = coordinates[1];
    longitude = coordinates[0];

    return LatLng(latitude, longitude);
  }

  /*
    Parse properties from GeoJSON,
    "properties": {
		   "prop0": "value0"
       "prop1": "value1"
	   }
  */
  static Map<String, String> parseProperties(Map<String, dynamic> properties) {

    return properties.map(
      (key, value) => MapEntry(
        key.toString(),
        value?.toString() ?? '',
      ),
    );
  }
}