import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:httapp/ui/image_carousel.dart';
import 'package:httapp/models/placeholder_image.dart';
import 'package:httapp/services/text_theme_service.dart';

class TreeTemplateItem extends StatelessWidget {
  /*
  TreeListItem builds a widget that can be displayed in a list
  The item will allow navigation to the relevant tree information page
  */
  const TreeTemplateItem({
    super.key,
    required this.id,
    required this.name,
    required this.imageFile
  });

  final String id;
  final String name;
  final Uint8List? imageFile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(horizontal: 8, vertical: 4),
      child: AspectRatio(
        aspectRatio: 4/3, //16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
            child: GestureDetector(
              onTap: () {
                Navigator.pushNamed(context, '/treePage/$id'); // id is the tree number, and key for the page
              },
              child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  _buildBackground(context),
                  _buildGradient(),
                  _buildTitle(constraints), // Pass constraints
                ],
              );
            },
          ),
            ),
        ),
      ),
    );
  }

  /*
  // 
  Widget _buildParallaxBackground(BuildContext context) {
    return Positioned.fill(child: Image.network(imageUrl, fit: BoxFit.cover));
  }
  */

  Widget _buildBackground(BuildContext context) {
    if (imageFile == null) {
      return Positioned.fill(child: placeholderImage());
    }
    else {
      return Image.memory(imageFile!, fit: BoxFit.cover);
    }
  }

  Widget _buildGradient() {
    return Positioned.fill(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.6, 0.95],
          ),
        ),
      ),
    );
  }

  Widget _buildTitle(BoxConstraints constraints) {
    return Positioned(
      left: 20,
      right: 20,
      bottom: 20,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.bottomLeft,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: constraints.maxWidth - 40, // Subtract left + right padding
          ),
          child: Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 2,
            softWrap: true,
          ),
        ),
      ),
    );
  }
}



class TreeTemplatePage extends StatefulWidget {
  const TreeTemplatePage({
    super.key,
    required this.id,
    required this.name,
    required this.body,
    required this.imageFileList
  });
  
  final String id;
  final String name;
  final String body;
  final List<File> imageFileList;

  @override
  State<TreeTemplatePage> createState() => _TreeTemplatePage();
}

class _TreeTemplatePage extends State<TreeTemplatePage> {
  /*
   TreeTemplatePage defines the layout for every tree information page.
   The page will contain a the name, an image, and a description of the tree.
  */
  
  @override
    void initState() {
      super.initState();
    }
  
  //final String imageName; //imageName will be used to access a local file downloaded from firebase

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
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  // Call MapController()
                  // moveAndRotate(LatLng center, double zoom, double degree, {String? id}) → MoveAndRotateResult 
                },
                child: Row(children: [
                  // Button icon
                  Icon(Icons.location_pin),

                  // Text
                  Text('Find On Map')
                  ])
                )
            ),
          ],
        )
      ),
    );
  }
}