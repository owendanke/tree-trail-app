import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

class MapCompass extends StatelessWidget {
  final MapController mapController;

  const MapCompass({super.key, required this.mapController});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 64,
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
              child: FloatingActionButton.small(
                shape: CircleBorder(),
                backgroundColor: Colors.white,
                onPressed: () {
                  mapController.rotate(0);
                },
                child: Transform.rotate(
                  angle: -rotation * 3.14 / 180,
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