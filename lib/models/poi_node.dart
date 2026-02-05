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
    return Marker(
        point: poi.location,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap:() => _showDetails(context, poi, onTabChange),
          child: Container(
            decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xFFEF6C00), width: 3),
      ),
          )
        )
      );
  }
}