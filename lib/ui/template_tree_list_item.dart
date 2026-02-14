// Dart
import 'dart:io';

// Flutter
import 'package:flutter/material.dart';

// httapp
import 'package:httapp/models/placeholder_image.dart';

class TemplateTreeListItem extends StatelessWidget {
  /*
  TreeListItem builds a widget that can be displayed in a list
  The item will allow navigation to the relevant tree information page
  */
  const TemplateTreeListItem({
    super.key,
    required this.id,
    required this.name,
    required this.imageFile
  });

  final String id;
  final String name;
  final File? imageFile;

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
                Navigator.pushNamed(context, '/$id'); // id is the tree number, and key for the page
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
      return Image.file(imageFile!,
      fit: BoxFit.cover,
      cacheWidth: MediaQuery.sizeOf(context).width.toInt()
      );
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