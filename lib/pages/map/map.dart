import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:geolocator/geolocator.dart';

import 'package:httapp/services/location/geolocator.dart';
import 'package:httapp/services/version_service.dart';
import 'package:httapp/models/poi.dart';
import 'package:httapp/models/poi_node.dart';
import 'package:httapp/models/map_compass.dart';

class MapPage extends StatefulWidget {
  final String title = 'Map';
  final List<PointOfInterest> poiList;

  static const LatLng center = LatLng(41.947186, -72.832672);         // Center (over kiosk)
  static const LatLng boundsCorner1 = LatLng(41.959917, -72.849722);  // NW
  static const LatLng boundsCorner2 = LatLng(41.934444, -72.815611);  // SE

  static MapController mapController = MapController();
  
  //final void Function(int, {String? routeName})? onTabChange;

  MapPage({
    super.key, 
    required this.poiList,
    //required this.onTabChange,
    });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late PackageInfo packageInfo;
  double _rotation = 0.0;
  Stream<Position> _positionStream = const Stream.empty();
  LatLng _userLocation = MapPage.center;

  late Marker _userLocationMarker;

  /// Keeps track of the selected PoiNode
  PointOfInterest? _selectedPoi;

  /// 
  PersistentBottomSheetController? _bottomSheetController;

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
  void dispose() {
    // Clean up controller on dispose, dismissing the bottom sheet
    _bottomSheetController?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Stack(
        children: [

          // Map widget
          FlutterMap(
            mapController: MapPage.mapController,
            options: MapOptions(
              // Center the map over kiosk
              initialCenter: MapPage.center,
              initialZoom: 17,
              // Constraint the zoom
              minZoom: 15,
              maxZoom: 20,
              // Constrain the camera to the regional focus of the app
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
              // Tile layer, the map itself, using OSM
              TileLayer( // Bring your own tiles
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: VersionService().packageName, // app identifier
                tileProvider: NetworkTileProvider(
                  cachingProvider: BuiltInMapCachingProvider.getOrCreateInstance(maxCacheSize: 512_000_000)
                  ),
              ),

              // Marker layer for trees, user location, etc.
              MarkerLayer(markers: [
                //
                ...widget.poiList.map((poi) {
                  return PoiNode.build(
                    context, 
                    poi,
                    //widget.onTabChange,
                    isSelected: (_selectedPoi == poi),
                    onShowBottomSheet: (controller) {
                        _bottomSheetController = controller;  // Store the controller
                      },
                    onSelect: () {
                      setState(() {
                        _selectedPoi = poi;
                        _bottomSheetController?.close();  // Close sheet on deselect
                        _bottomSheetController = null;    // set controller to null
                        debugPrint('[MapPage] selected poi ${poi.name}');
                      });},
                    onDeselect: () {
                      setState(() {
                        _selectedPoi = null;
                        debugPrint('[MapPage] deselected poi ${poi.name}');
                      });},
                    onLearnMore: () {
                      Navigator.pushNamed(context, '/map/${poi.id}');
                    }
                  );}
                ),
                ...UserLocationMarker.build(_userLocation),
                ]),

              // attributions to give credit to map creators
              SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors'),
              ),
            ],
          ),

          // Map control buttons
          // Show hide specific layers
          _layerButton(context), 
          // When map is rotated, show north and return to north facing if pressed
          MapCompass(mapController: MapPage.mapController),
        ],
      ),
    );
  }
}

Widget _layerButton(BuildContext context) {
  return Positioned(
    top: 16,
    right: 16,
    child: FloatingActionButton.small(
      shape: CircleBorder(),
      backgroundColor: Colors.white,
      onPressed: () {
        // Hide or show a modal that allows modifying layers on the map
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return Dialog(
              child: SizedBox(
                width: (MediaQuery.of(context).size.width) / 2,
                height: (MediaQuery.of(context).size.height) / 2,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.layers_sharp),
                          Text('Modify Visible Layers'),
                          IconButton(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.close),
                            )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            );
          }
        );
      },
      child: const Icon(Icons.layers_outlined),
    )
  );
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