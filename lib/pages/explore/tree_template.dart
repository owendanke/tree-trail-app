import 'package:flutter/material.dart';

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
        aspectRatio: 16 / 9,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
            child: TapRegion(
              onTapInside: (event) {
                Navigator.pushNamed(context, '/treePage/$id'); // id is the tree number, and key for the page
              },
              child: Stack(children: [
              _buildBackground(context),
              _buildTitle(),
              ],)
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

  Widget _buildTitle() {
    return Positioned(
      left: 20,
      bottom: 20,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            name,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
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
      body: Text("Tree Template Page"),
    );
  }
}