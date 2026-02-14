// Dart
import 'dart:async';

// Flutter
import 'package:flutter/material.dart';

// pub.dev
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:geolocator/geolocator.dart';

// httapp
import 'package:httapp/services/map_controller_service.dart';
import 'package:httapp/services/location/geolocator.dart';
import 'package:httapp/services/version_service.dart';
import 'package:httapp/models/poi.dart';
import 'package:httapp/models/poi_node.dart';
import 'package:httapp/ui/map_compass.dart';
import 'package:httapp/ui/map_marker_styles.dart';

class MapPage extends StatefulWidget {
  /// Title of the page, will appear on the appbar
  final String title = 'Map';

  /// Data for the tree locations
  final Map<String, PointOfInterest> poiMap;

  /// Data for interpretive signs
  final List<PointOfInterest> signList;

  /// Initial location where the map will be centered
  /// 
  /// Kiosk : [41.947186, -72.832672]
  static const LatLng center = LatLng(41.947186, -72.832672);

  /// Map boundary 1, northwest corner
  /// 
  /// [41.959917, -72.849722]
  /// 
  /// This defines one extreme of the map, limiting the scope
  static const LatLng boundsCorner1 = LatLng(41.959917, -72.849722);

  /// Map boundary 1, southeast corner
  /// 
  /// [41.934444, -72.815611]
  /// 
  /// This defines one extreme of the map, limiting the scope
  static const LatLng boundsCorner2 = LatLng(41.934444, -72.815611);

  /// MapController provided by MapControllerService
  static MapController mapController = MapControllerService().mapController;

  MapPage({
    super.key, 
    required this.poiMap,
    required this.signList,
    });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late PackageInfo packageInfo;
  Stream<Position> _positionStream = const Stream.empty();
  LatLng _userLocation = MapPage.center;

  /// Keeps track of the selected PoiNode
  PointOfInterest? _selectedPoi;
  bool _treeMarkerVisible = true;
  bool _signMarkerVisible = true;

  Future<void> _getPositionStream() async {
    try {
      _positionStream = await getPositionStream();
    } catch (e) {
      print('An exception was thrown while initalizing _positionStream:');
      print(e);
    }
  }

  void selectPoi(PointOfInterest poi) {
    setState(() {
      _selectedPoi = poi;
    });
  }

  void deselectPoi() {
    setState(() {
      _selectedPoi = null;
    });
  }

  @override
  void initState() {
    super.initState();
  
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
                // Tree markers
                if (_treeMarkerVisible)
                  ...widget.poiMap.entries.map((MapEntry<String, PointOfInterest> poi) {
                    return PoiNode.build(
                      poi: poi.value,
                      isSelected: (_selectedPoi == poi.value) || (MapControllerService().selectedPoiId == poi.key),
                      onTap: () => selectPoi(poi.value),
                      style: treeMarkerTheme
                    );
                  }),

                // Sign markers
                if(_signMarkerVisible)
                  ...widget.signList.map((poi) {
                    return PoiNode.build(
                      poi: poi,
                      isSelected: _selectedPoi == poi,
                      onTap: () => selectPoi(poi),
                      //onTap: () {},
                      style: signMarkerTheme
                    );
                  }),

                // User location
                UserLocationMarker.build(_userLocation),
                ]),

              // attributions to give credit to map creators
              SimpleAttributionWidget(
                source: Text('OpenStreetMap contributors'),
              ),
            ],
          ),

          // Map control buttons
          _layerButton(context), 
          MapCompass(mapController: MapPage.mapController),

          // Draggable bottom sheet
          if (_selectedPoi != null)
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomSheet(
              enableDrag: false,
              onClosing: () {},
              builder: (BuildContext context) {
                return IntrinsicHeight(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[

                        // Common name
                        Padding(
                          padding: EdgeInsetsGeometry.fromLTRB(8, 8, 8, 4),
                          child: Text(_selectedPoi!.name, style: Theme.of(context).textTheme.titleLarge),
                        ),

                        // Accession number
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(vertical: 4, horizontal: 8),
                          child: Text('(${_selectedPoi!.id})', style: Theme.of(context).textTheme.titleMedium),
                        ),
                        
                        // layout tree info and close buttons in a row
                        Row(
                          children: [
                            // Learn more button
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 16),
                                child: ElevatedButton(
                                  onPressed: () => Navigator.pushNamed(context, '/map/${_selectedPoi!.id}'),
                                  child: const Text('Learn More'),
                                ),
                              )
                            ),

                            // close button
                            Expanded(
                              child: Padding(
                                padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 16),
                                child: ElevatedButton(
                                  onPressed: () {
                                    // deselect the poi, prevents this widget from rendering
                                    deselectPoi();
                                    MapControllerService().deselectPoi();
                                  },
                                  child: const Text('Close'),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _layerButton(BuildContext context) {
    return Positioned(
      top: 16,
      right: 16,
      child: FloatingActionButton.small(
        shape: CircleBorder(),
        backgroundColor: Colors.white,
        onPressed: () async {

          // Hide or show a modal that allows modifying layers on the map
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return StatefulBuilder(
                builder: (context, setDialogState) {
                  return Dialog(
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width) / 2,
                      height: (MediaQuery.of(context).size.height) / 2,
                      child: Column(
                        children: [

                          // Header
                          Padding(
                            padding: EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Container holds icon and title together for proper alignment
                                Container(
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                                        child: Icon(Icons.layers_sharp),
                                        ),
                                      Padding(
                                        padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                                        child: Text('Map Layers'),
                                        ),
                                    ]
                                  )
                                ),
                                Padding(
                                  padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
                                  child: IconButton(
                                    onPressed: () => Navigator.pop(context),
                                    icon: const Icon(Icons.close),
                                  )
                                ),
                              ],
                            ),
                          ),

                          /* Layer options */
                          // Tree Layer
                          CheckboxListTile(
                            value: _treeMarkerVisible,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                _treeMarkerVisible = value!;
                              });
                              setState(() {});
                            },
                            title: const Text('Featured Trees'),
                            //subtitle: const Text('Supporting text'),
                          ),
                          const Divider(height: 0),
                          CheckboxListTile(
                            value: _signMarkerVisible,
                            onChanged: (bool? value) {
                              setDialogState(() {
                                _signMarkerVisible = value!;
                              });
                              setState(() {});
                            },
                            title: const Text('Interpretive Signs'),
                            //subtitle: const Text('Supporting text'),
                          ),
                        ],
                      ),
                    )
                  );
                }
              );
            }
          );
        },
        child: const Icon(Icons.layers_outlined),
      )
    );
  }
}

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