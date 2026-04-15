// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

// httapp
import 'package:httapp/routes/explore_routes.dart';
import 'package:httapp/services/text_theme_service.dart';
import 'package:httapp/ui/appbar.dart';
import 'package:httapp/launch_url.dart';

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
      appBar: MyAppBar(title: title),
      extendBodyBehindAppBar: true,

      body: Center(
        child: Column(
          children: <Widget>[
            // floating app bar padding cheat
            SizedBox(height: 100),

            // Image from asset bundle
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
            
            // Featured trees description
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
              child: Text("Learn more about select trees at the Holcomb Tree Trail arboretum", style: TextThemeService().bodyStyle,),
            ),

            // Featured trees button
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, ExploreRoutes.treeList);
                },
                child: _buttonContainer('Featured Trees'),
              )
            ),
            
            // Woodland trails description
            Padding(
              padding: EdgeInsetsGeometry.symmetric(vertical: 8, horizontal: 16),
              child: Text("Explore other trails at Holcomb Farm", style: TextThemeService().bodyStyle),
            ),

            // Woodland trails button
            Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: ElevatedButton(
                onPressed: () => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Open In Browser?'),
                    content: const Text('This will bring you to the Holcomb Farm trails page.'),
                    actions: <Widget>[
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      FilledButton(
                        onPressed: () {
                          urlLauncher('https://holcombfarm.org/trails/');
                          Navigator.pop(context, 'Okay');
                          },
                        child: const Text('Okay'),
                      ),
                    ],
                  ),
                ),
                child: _buttonContainer('Woodland Trails'),
              )
            ),
            
            // offset sheet from navigation bar, another hack
            SizedBox(height: 90)
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