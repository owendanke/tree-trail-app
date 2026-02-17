// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

// httapp
import 'package:httapp/routes/explore_routes.dart';

//class ExplorePage extends StatefulWidget {
class ExplorePage extends StatelessWidget {
  ExplorePage({super.key});
  
  final String title = 'Explore';
  final AssetImage assetImage = AssetImage('assets/explore_page.jpg');
  /*
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {

  @override
  void initState() {
    super.initState();
    widget._assetImage = AssetImage('assets/explore_page.jpg');
    precacheImage(widget.assetImage, context);
  }
*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[

            // Image from asset bundle with no horizontal padding
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: AspectRatio(
                aspectRatio: 4/3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.asset(
                    'assets/explore_page.jpg',
                    cacheHeight: MediaQuery.sizeOf(context).width.toInt(),
                    filterQuality: FilterQuality.medium,
                    fit: BoxFit.cover
                  )
                )
              )
            ),
            
            // Featured trees button
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, ExploreRoutes.treeList);
              },
              child: _buttonContainer('Featured Trees'),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _buttonContainer(String text) {
  return SizedBox(
    width: 128.0,
    //height: 24.0,
    child: Column(
      children: [Text(text),],
    )
  );
}