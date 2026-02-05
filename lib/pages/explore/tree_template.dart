import 'dart:io';
import 'package:flutter/foundation.dart';
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
    required this.imageFile
  });

  final String id;
  final String name;
  //final File? imageFile;
  final Uint8List? imageFile;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
    /*
    if (imageFile == null) {
      return Positioned.fill(child: SizedBox(width: 50, height: 100, child: ColoredBox(color: Colors.grey)));
    }
    else {
      //return Image.file(imageFile!, fit: BoxFit.cover);
      return Image.memory(imageFile!, fit: BoxFit.cover);
    }
    */
    if (imageFile == null) {
      return Positioned.fill(child: SizedBox(width: 50, height: 100, child: ColoredBox(color: Colors.grey)));
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

class ImageCarousel extends StatefulWidget {
    const ImageCarousel ({
    super.key,
    required this.imageFileList,
  });

  final List<File?>? imageFileList;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController controller;
  int currentpage = 0;

  Future<void> _preloadImages() async {}

  @override
  initState() {
    super.initState();
    controller = PageController(
      initialPage: currentpage,   // The page to show when first creating the [PageView].
      keepPage: false,            // Save the current [page] with [PageStorage] and restore it if this controller's scrollable is recreated.
      viewportFraction: 0.75,     // The fraction of the viewport that each page should occupy.
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    body: Center(
      child: AspectRatio(
        aspectRatio: 4/ 3,
        child: PageView(
          onPageChanged: (value) {
            setState(() {
              currentpage = value;
            });
          },
          controller: controller,
          children: [
            if (widget.imageFileList != null && widget.imageFileList!.isNotEmpty)
              ...[
                for (File imgFile in widget.imageFileList!.whereType<File>()) // Filter out nulls
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.file(imgFile, fit: BoxFit.contain,),
                  ),
              ]
            else 
              Padding(
                padding: EdgeInsetsDirectional.symmetric(horizontal: 20),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: SizedBox(
                    width: 50, 
                    height: 100, 
                    child: ColoredBox(color: Colors.grey),
                  ),
                ),
              ),
          ],
        )
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
        title: Text(widget.name, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      //body: Text("Tree Template Page"),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(0, 40, 0, 40),
              child: AspectRatio(
                aspectRatio: 16/ 9,
                child: ImageCarousel(imageFileList: widget.imageFileList),
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.fromLTRB(20, 40, 20, 40),
              child: MarkdownBody(data: widget.body)
            )
          ],
        )
      ),
    );
  }
}