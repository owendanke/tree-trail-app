// Flutter
import 'package:flutter/material.dart';

// pub.dev
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:httapp/models/entity/tree_entity_data.dart';


// httapp
import 'package:httapp/ui/image_carousel.dart';
import 'package:httapp/services/map_controller_service.dart';
import 'package:httapp/ui/appbar.dart';
// import 'package:httapp/models/entity/tree_entity_data.dart';


class TreePageTemplate extends StatefulWidget {
  TreePageTemplate({
    super.key,
    required this.entity,
    this.onTabChange,
  });
  
  final TreeEntityData entity;
  late final String description;
  bool _didPrecache = false;

  final void Function(int, {String? routeName})? onTabChange;

  @override
  State<TreePageTemplate> createState() => _TreePageTemplate();
}

class _TreePageTemplate extends State<TreePageTemplate> {
  /*
   TreeTemplatePage defines the layout for every tree information page.
   The page will contain a the name, an image, and a description of the tree.
  */
  
  Future<void> _precacheImages() async {
    for (final file in widget.entity.galleryImages) {
      await precacheImage(FileImage(file), context);
    }
    widget._didPrecache = true;
  }

  @override
    void initState() {
      super.initState();
    }

    @override
    void didChangeDependencies() {
      super.didChangeDependencies();
      if (!widget._didPrecache) {
        _precacheImages();
      }
    }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: widget.entity.name),
      /*
      AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        //title: Text(widget.name, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      */
      body: SingleChildScrollView(
        child: Column(
          children: [

            // Image Carousel
            Padding(
              padding: EdgeInsetsGeometry.zero,
              child: SizedBox(
                height: MediaQuery.of(context).size.width,
                width: MediaQuery.of(context).size.width,
                child: ImageCarousel(imageFileList: widget.entity.galleryImages),
              ),
            ),

            // Markdown body
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16.0, horizontal: 24.0),
              child: MarkdownBody(
                data: widget.entity.description.readAsStringSync(),
                styleSheet: MarkdownStyleSheet(
                  //textScaler: TextThemeService().markdownTextScale,
                ),
                )
            ),

            // Find on map
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16.0, horizontal: 24.0),
              child: ElevatedButton(
                onPressed: () {
                  // Call moveAndRotate from MapControllerService
                  //
                  // Move map center to the point
                  // Zoom in to the point
                  // Rotate map to north
                  MapControllerService().moveAndRotate(widget.entity.location, 19.0, 0.0);

                  // select the poi to highlight on the map
                  MapControllerService().selectPoi(widget.entity.id);

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

            // offset sheet from navigation bar
            SizedBox(height: 100)
          ],
        )
      ),
    );
  }
}