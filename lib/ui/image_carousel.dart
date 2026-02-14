import 'dart:io';
import 'package:flutter/material.dart';
import 'package:httapp/models/placeholder_image.dart';

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

  @override
  initState() {
    super.initState();
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
                    child: widget.imageFileList[currentpage] != null
                      ? Image.file(widget.imageFileList[currentpage]!, fit: BoxFit.cover)
                      : placeholderImage()
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
            padding: EdgeInsetsGeometry.symmetric(vertical: 8.0),
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
                  if (widget.imageFileList.isNotEmpty)
                    ...[
                      for (File img in widget.imageFileList.whereType<File>()) // Filter out nulls
                        Padding(
                          padding: EdgeInsetsGeometry.symmetric(horizontal: 8.0),
                          child: GestureDetector(
                            onTap: () {
                              _previewImage();
                            },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: Image.file(
                              img,
                              fit: BoxFit.cover,
                              cacheHeight: MediaQuery.sizeOf(context).width.toInt(),
                            ),
                          ),
                        )
                      )
                    ]
                  else 
                    placeholderImage()
                ],
              )
            ),
          )
        )
      ),
    );
  }
}