import 'package:flutter/material.dart';
import 'package:httapp/models/poi.dart';
import 'package:flutter_map/flutter_map.dart';

class PoiNode {

  /// Builds the bottom sheet content
  static Widget buildBottomSheet(
    BuildContext context,
    PointOfInterest poi,
    {
      required VoidCallback onClose,
      required VoidCallback onLearnMore,
    }
  ) {
    return IntrinsicHeight(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Common name
            Padding(
              padding: EdgeInsetsGeometry.symmetric(horizontal: 8),
              child: Text(poi.name, style: Theme.of(context).textTheme.titleLarge),
            ),

            // Accession number
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 4, horizontal: 8),
              child: Text('(${poi.id})', style: Theme.of(context).textTheme.titleMedium),
            ),
            
            // layout tree info and close buttons in a row
            Row(
              children: [
                // Learn more button
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 16),
                    child: ElevatedButton(
                      onPressed: onLearnMore,
                      child: const Text('Learn More'),
                    ),
                  )
                ),

                // close button
                Expanded(
                  child: Padding(
                    padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 16),
                    child: ElevatedButton(
                      onPressed: onClose,
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
  }

  /// Builds the marker on the map
  static Marker build(
    BuildContext context,
    PointOfInterest poi,
    {
      bool isSelected = false,
      required VoidCallback onTap,
    }
  ) {
    final double size = isSelected ? 35 : 25;
    return Marker(
        point: poi.location,
        width: size,
        height: size,
        child: GestureDetector(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.orange,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected
                  ? Color(0xFFEF6C00)
                  : Color(0xFFFB8C00), 
                width: isSelected
                  ? 5
                  : 3
              ),
              boxShadow: isSelected
                ? [BoxShadow(
                      color: Color(0x66000000),
                      blurRadius: 4,
                      spreadRadius: 3,
                    )
                  ]
                : null,
            ),
          )
        )
    );
  }
}