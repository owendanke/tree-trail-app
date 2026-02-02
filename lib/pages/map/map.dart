import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:geolocator/geolocator.dart';

import 'package:httapp/services/location/geolocator.dart';

class MapPage extends StatefulWidget {
  final String title = 'Map';
  final List<Marker> markerList;

  static const LatLng center = LatLng(41.947186, -72.832672);         // Center (over kiosk)
  static const LatLng boundsCorner1 = LatLng(41.959917, -72.849722);  // NW
  static const LatLng boundsCorner2 = LatLng(41.934444, -72.815611);  // SE

  static MapController mapController = MapController();
  
  MapPage({
    super.key, 
    required this.markerList
    });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late PackageInfo packageInfo;
  String _packageName = 'org.odanke.HTTapp';
  double _rotation = 0.0;
  Stream<Position> _positionStream = const Stream.empty();
  LatLng _userLocation = MapPage.center;

  late Marker _userLocationMarker;

  /*
  Future<void> _loadVersionNumber() async {
    try {
      packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _packageName = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        _packageName = '';
      });
    }
    */

  Future<void> _getPositionStream() async {
    try {
      _positionStream = await getPositionStream();
    } catch (e) {
      print('An exception was thrown while initalizing _positionStream:');
      print(e);
    }
    
  }

  @override
  void initState() {
    super.initState();
    //determinePosition();

    _userLocationMarker = Marker(point: _userLocation, 
      child: Icon(Icons.gps_fixed, color: Colors.blue,),
      width: 40,
      height: 40
    );
  
    _getPositionStream().then((_) {
    _positionStream.listen((position) {
      setState(() {
        _userLocation = LatLng(
          position.latitude,
          position.longitude,
        );
      });
    });
  });

    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: MapPage.mapController,
            options: MapOptions(
              initialCenter: MapPage.center, // Center the map over kiosk
              initialZoom: 17,
              minZoom: 15,
              maxZoom: 20,
              cameraConstraint: CameraConstraint.contain(bounds: LatLngBounds(MapPage.boundsCorner1, MapPage.boundsCorner2)),
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all, // includes rotate
              ),

              onPositionChanged: (position, hasGesture) {
                setState(() {
                  _rotation = position.rotation;  // record the current rotation of the map
                });
              },
            ),
            children: [
              TileLayer( // Bring your own tiles
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: _packageName, // app identifier
                tileProvider: NetworkTileProvider(
                  cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(maxCacheSize: 512_000_000)
                  ),
              ),
              /*
              RichAttributionWidget(
                attributions: [
                  TextSourceAttribution(
                    'OpenStreetMap contributors',
                    onTap: () => _osmDialogBuilder(context),
                  ),
                ],
              ),*/
              MarkerLayer(markers: [...widget.markerList, ...UserLocationMarker.build(_userLocation)]),  // markers placed on map
              SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors'),
              ),
            ],
          ),

          MapCompass(mapController: MapPage.mapController),
        ],
      ),
    );
  }
}

Future<void> _osmDialogBuilder(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Map Attribution'),
        content: const Text(
          '© OpenStreetMap contributors',
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(textStyle: Theme.of(context).textTheme.labelLarge),
            child: const Text('Close'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}

class MapCompass extends StatelessWidget {
  final MapController mapController;

  const MapCompass({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: StreamBuilder<MapEvent>(
        stream: mapController.mapEventStream,
        builder: (context, snapshot) {
          final rotation = mapController.camera.rotation;

          return AnimatedOpacity(
            opacity: rotation.abs() < 0.5 ? 0 : 1,
            duration: const Duration(milliseconds: 250),
            child: IgnorePointer(
              ignoring: rotation.abs() < 0.5,
              child: FloatingActionButton(
                mini: true,
                backgroundColor: Colors.white,
                onPressed: () {
                  mapController.rotate(0);
                },
                child: Transform.rotate(
                  angle: -rotation * pi / 180,
                  child: const Icon(
                    Icons.navigation,
                    color: Colors.red,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class UserLocationMarker {
  static List<Marker> build(LatLng? location) {
    if (location == null) return const [];

    return [
      
      Marker(
        point: location,
        width: 40,
        height: 40,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Icon(Icons.gps_fixed, color: Colors.blue, size: 32)
        ),
      ),
    ];
  }
}