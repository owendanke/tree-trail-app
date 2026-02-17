// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

// httapp
import 'package:httapp/routes/home_routes.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key, 
    this.onTabChange,
  });
  
  final String title = 'Welcome';
  final AssetImage _assetLogo = AssetImage('assets/HTT_dropshadow.png');
  final AssetImage _assetBackground = AssetImage('assets/HTT_map_background.png');
  final void Function(int, {String? routeName})? onTabChange;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),

      // Background image with decorated box
      body: DecoratedBox(
        // image of decorated box is background
        decoration: BoxDecoration(
          image: DecorationImage(image: _assetBackground, fit: BoxFit.cover)
        ),

        // Home screen contents
        child: Center(
          child: Column(
            children: <Widget>[

              // header logo
              Padding(
                padding: EdgeInsets.fromLTRB(20, 8, 20, 80),
                child: Image(image: _assetLogo,fit: BoxFit.cover)
              ),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeRoutes.about);
                },
                child: _buttonContainer('About Us'),
              ),

              Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, HomeRoutes.visitorInfo);
                },
                child: _buttonContainer('Visitor Info'),
              ),

              Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),

              ElevatedButton(
                onPressed: () {
                  onTabChange?.call(1, routeName: HomeRoutes.treeList);
                },
                child: _buttonContainer('Featured Trees'),
              ),
            ],
          ),
        ),
      )
    );
  }
}

Widget _buttonContainer(String text) {
  return SizedBox(
    width: 128.0,
    child: Column(
      children: [Text(text),],
    )
  );
}