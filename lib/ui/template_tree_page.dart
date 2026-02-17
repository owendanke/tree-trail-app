// Dart
import 'dart:io';

// Flutter
import 'package:flutter/material.dart';

// pub.dev
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

// httapp
import 'package:httapp/ui/image_carousel.dart';
import 'package:httapp/services/map_controller_service.dart';
import 'package:latlong2/latlong.dart';


class TemplateTreePage extends StatefulWidget {
  TemplateTreePage({
    super.key,
    required this.id,
    required this.name,
    required this.body,
    required this.location,
    required this.imageFileList,
    this.onTabChange,
  });
  
  final String id;
  final String name;
  final String body;
  final LatLng? location;
  final List<File> imageFileList;
  bool _didPrecache = false;

  final void Function(int, {String? routeName})? onTabChange;

  @override
  State<TemplateTreePage> createState() => _TemplateTreePage();
}

class _TemplateTreePage extends State<TemplateTreePage> {
  /*
   TreeTemplatePage defines the layout for every tree information page.
   The page will contain a the name, an image, and a description of the tree.
  */
  
  Future<void> _precacheImages() async {
    for (final file in widget.imageFileList) {
      await precacheImage(FileImage(file), context);
    }
  }

  @override
    void initState() {
      super.initState();
    }

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      if (!widget._didPrecache) {
        widget._didPrecache = true;
        _precacheImages();
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        //title: Text(widget.name, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      //body: Text("Tree Template Page"),
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Image Carousel
            Padding(
              padding: EdgeInsetsGeometry.zero,
              child: SizedBox(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: ImageCarousel(imageFileList: widget.imageFileList),
              ),
            ),

            // Markdown body
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16.0, horizontal: 24.0),
              child: MarkdownBody(
                data: widget.body,
                styleSheet: MarkdownStyleSheet(
                  //textScaler: TextThemeService().markdownTextScale,
                ),
                )
            ),

            // Find on map
            // conditional if a location for this tree has been provided
            if (widget.location != null)
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16.0, horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  // Call moveAndRotate from MapControllerService
                  //
                  // Move map center to the point
                  // Zoom in to the point
                  // Rotate map to north
                  MapControllerService().moveAndRotate(widget.location!, 19.0, 0.0);

                  // select the poi to highlight on the map
                  MapControllerService().selectPoi(widget.id);

                  // navigate to the map
                  // Do not use the routeName as it pushes a new map page onto the stack
                  // This will create:
                  //    setState() called after dispose()
                  //    markNeedsBuild()
                  //widget.onTabChange?.call(2, routeName: MapRoutes.map);
                  widget.onTabChange?.call(2);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [

                    // Button icon
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0),
                      child: Icon(Icons.location_pin)
                    ),

                    // Text
                    Padding(
                      padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0),
                      child: Text('Find On Map')
                    ),
                  ])
                )
            ),
          ],
        )
      ),
    );
  }
}