import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class ImageCarousel extends StatefulWidget {
    const ImageCarousel ({
    super.key,
    required this.imageFileList,
  });

  final List<File?> imageFileList;

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late PageController controller;
  int currentpage = 0;
  late List<Uint8List> imageList;

  /// Load carousel images
  void _loadImages() {
    try {
      /*
      for (File imgFile in widget.imageFileList.whereType<File>()) {
        imageList.add(imgFile.readAsBytesSync());
      }
      */
      imageList = List.generate(widget.imageFileList.length, (img) => widget.imageFileList[img]!.readAsBytesSync());
    } catch(e) {
      rethrow;
    }
  }

  @override
  initState() {
    super.initState();
    // load the images into memory
    _loadImages();
    controller = PageController(
      // The page to show when first creating the [PageView].
      initialPage: currentpage,

      // Save the current [page] with [PageStorage] and restore it if this controller's scrollable is recreated.
      keepPage: false,

      // The fraction of the viewport that each page should occupy.
      viewportFraction: 0.75,
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }

  dynamic _previewImage() {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (BuildContext context) {
        return SizedBox.expand(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => Navigator.of(context).pop(),
            child: Center(
              child: GestureDetector(
                onTap: () {}, // absorb taps on the image
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.6,
                  child: InteractiveViewer(
                    panEnabled: true,
                    minScale: 1.0,
                    maxScale: 4.0,
                    child: Image.memory(
                      imageList[currentpage],
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          //color: Colors.black54,
          child: Padding(
            padding: EdgeInsetsGeometry.all(8),
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
                  if (imageList.isNotEmpty)
                    ...[
                      for (var img in imageList)
                      Padding(
                        padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0),
                        child: GestureDetector(
                          onTap: () {
                            _previewImage();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.memory(img, fit: BoxFit.cover),
                          ),
                        )
                      )
                    ]
                  else 
                    ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        width: 50, 
                        height: 100, 
                        child: ColoredBox(color: Colors.grey),
                      ),
                    ),
                ],
              )
            ),
          )
        )
      ),
    );
  }
}