import 'package:flutter/material.dart';
import 'package:httapp/models/poi.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:httapp/routes/map_routes.dart';

class PoiNode {

  static void _modalShowDetails(BuildContext context, PointOfInterest poi, VoidCallback? onSelect, VoidCallback? onDeselect, Function(int, {String? routeName})? onTabChange) {
    showModalBottomSheet(
      context: context,
      enableDrag: true,
      showDragHandle: true,
      isDismissible: false,  // Don't dismiss on barrier tap
      barrierColor: Colors.transparent,  // Transparent so map is visible
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
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
                        // deselct marker to reset size
                        onDeselect?.call();
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
                      padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 16),
                      child: ElevatedButton(
                      onPressed: () {
                        // deselct marker to reset size
                        onDeselect?.call();
                        // close sheet
                        Navigator.pop(context);
                        },
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
    ).then((value) {
      // this is the missing detail that allows dismissing when 
      onDeselect?.call();
    },);
  }

  static PersistentBottomSheetController _showDetails(BuildContext context, PointOfInterest poi, VoidCallback? onSelect, VoidCallback? onDeselect, Function(int, {String? routeName})? onTabChange) {
    return showBottomSheet(
              context: context, 
              enableDrag: true,
              showDragHandle: true,
              builder: (BuildContext context) {
                return IntrinsicHeight(
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
                                  // deselct marker to reset size
                                  onDeselect?.call();
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
                                padding: EdgeInsetsGeometry.directional(start: 8, end: 8, bottom: 16),
                                child: ElevatedButton(
                                onPressed: () {
                                  // deselct marker to reset size
                                  onDeselect?.call();
                                  // close sheet
                                  Navigator.pop(context);
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
            );
  }

  static Marker build(
    BuildContext context,
    PointOfInterest poi,
    Function(int, {String? routeName})? onTabChange,
    {
      bool isSelected = false,
      Function(PersistentBottomSheetController)? onShowBottomSheet,
      VoidCallback? onSelect,
      VoidCallback? onDeselect,
    }) {
    final double size = isSelected ? 35 : 25;
    return Marker(
        point: poi.location,
        width: size,
        height: size,
        child: GestureDetector(
          //onTap:() => _showDetails(context, poi, onTabChange),
          onTap:() {
            onSelect?.call();
            final controller = _showDetails(context, poi, onSelect, onDeselect, onTabChange);
            //_modalShowDetails(context, poi, onSelect, onDeselect, onTabChange);
            onShowBottomSheet?.call(controller);
          },
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
              : 3),
          boxShadow: isSelected
          ? [BoxShadow(
                color: Color(0x66000000),
                blurRadius: 4,
                spreadRadius: 3,
                //offset: Offset(0, 3)
              )
            ]
            : null,
          ),
        )
      )
    );
  }
}