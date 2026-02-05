import 'package:flutter/material.dart';
import 'package:httapp/models/poi.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:httapp/routes/map_routes.dart';

class PoiNode {

  static void _showDetails(BuildContext context, PointOfInterest poi, Function(int, {String? routeName})? onTabChange) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Title
              Padding(
                padding: EdgeInsetsGeometry.only(bottom: 32),
                child: Text(
                  '${poi.name} (${poi.id})',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // layout tree info and close buttons in a row
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: ElevatedButton(
                      onPressed: () {
                        onTabChange?.call(1, routeName: '/treePage/${poi.id}');
                      },
                      child: const Text('Learn More'),
                      ),
                    )
                  ),


                  Expanded(
                    child: Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                      child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  static Marker build(BuildContext context, PointOfInterest poi, Function(int, {String? routeName})? onTabChange) {
    final Color markerColor = Colors.orange;
    return Marker(
        point: poi.location,
        width: 40,
        height: 40,
        child: GestureDetector(
          //onTap:() => _showDetails(context, poi, onTabChange),
          onTap:() => showBottomSheet(
            context: context, 
            enableDrag: true,
            showDragHandle: true,
            builder: (BuildContext context) {
              return IntrinsicHeight(
                //height: (MediaQuery.of(context).size.width) / 3,
                //width: (MediaQuery.of(context).size.width),
                //padding: const EdgeInsets.all(16),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      // Title
                      Padding(
                        padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 8),
                        child: Text(
                          '${poi.name} (${poi.id})',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      
                      // layout tree info and close buttons in a row
                      Row(
                        children: [
                          // Learn more button
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 16),
                              child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                                onTabChange?.call(1, routeName: '/treePage/${poi.id}');
                              },
                              child: const Text('Learn More'),
                              ),
                            )
                          ),

                          // close button
                          Expanded(
                            child: Padding(
                              padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                              child: ElevatedButton(
                              onPressed: () => Navigator.pop(context),
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
          child: Container(
            decoration: BoxDecoration(
            color: markerColor,
            shape: BoxShape.circle,
            border: Border.all(color: Color(markerColor.hashCode - 0x102C00), width: 3),
      ),
          )
        )
      );
  }
}