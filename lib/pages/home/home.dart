import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:holcomb_tree_trail/routes/home_routes.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key, 
    this.onTabChange,
  });
  
  final String title = 'Welcome';
  final void Function(int, {String? routeName})? onTabChange;
  
  // TODO, clean this up
  // getting screen pixels
  // first get the FlutterView.
  final FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

  // pixel dimensions
  late final Size size = view.physicalSize;
  late final double screenWidth = size.width;
  late final double screenHeight = size.height;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        title: Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),

            // image from asset bundle with 20 pixel horizontal padding
            Image.asset('lib/assets/tree_trail_logo.png', fit: BoxFit.scaleDown, width: (screenWidth - 40)),

            Padding(padding: EdgeInsets.symmetric(vertical: 20.0)),

            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(5.0),
              onPressed: () {
                Navigator.pushNamed(context, HomeRoutes.about);
              },
              child: Text('About Us'),
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),

            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(5.0),
              onPressed: () {
                Navigator.pushNamed(context, HomeRoutes.visitorInfo);
              },
              child: const Text('Visitor Info'),
            ),

            Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),

            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(5.0),
              onPressed: () {
                onTabChange?.call(1, routeName: HomeRoutes.treeList);
              },
              child: const Text('Featured Trees'),
            ),
          ],
        ),
      ),
    );
  }
}