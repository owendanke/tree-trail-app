import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';

class TreeTemplateItem extends StatelessWidget {
  /*
  TreeListItem builds a widget that can be displayed in a list
  The item will allow navigation to the relevant tree information page
  */
  const TreeTemplateItem({
    super.key,
    required this.id,
    required this.name,
  });

  final String id;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: AspectRatio(
        aspectRatio: 4/3, //16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
            child: TapRegion(
              onTapInside: (event) {
                Navigator.pushNamed(context, '/treePage/$id'); // id is the tree number, and key for the page
              },
              child: LayoutBuilder(
            builder: (context, constraints) {
              return Stack(
                children: [
                  _buildBackground(context),
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
    return Positioned.fill(child: SizedBox(width: 50, height: 100, child: ColoredBox(color: Colors.grey)));
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



class TreeTemplatePage extends StatelessWidget {
  /*
   TreeTemplatePage defines the layout for every tree information page.
   The page will contain a the name, an image, and a description of the tree.
  */
  const TreeTemplatePage({
    super.key,
    required this.id,
    required this.name,
    required this.body,
    //required this.imageName
  });

  final String id;
  final String name;
  final String body;
  //final String imageName; //imageName will be used to access a local file downloaded from firebase
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(name, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      //body: Text("Tree Template Page"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            /*
            AspectRatio(
              aspectRatio: aspectRatio,
              child: CarouselView(itemExtent: itemExtent, children: children),
            )
            */
            MarkdownBody(data: body)
          ],
        )
      ),
    );
  }
}