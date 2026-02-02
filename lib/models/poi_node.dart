import 'package:flutter/material.dart';
import 'package:httapp/models/poi.dart';
import 'package:flutter_map/flutter_map.dart';

class PoiNode {

  static void _showDetails(BuildContext context, PointOfInterest poi) {
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
                padding: EdgeInsetsGeometry.only(bottom: 8),
                child: Text(
                  poi.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Description
              Padding(
                padding: EdgeInsetsGeometry.only(bottom: 8),
                child: Text(
                  poi.description,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              
              // Close button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      },
    );
  }

  static Marker build(BuildContext context, PointOfInterest poi) {
    return Marker(
        point: poi.location,
        width: 40,
        height: 40,
        child: GestureDetector(
          onTap:() => _showDetails(context, poi),
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