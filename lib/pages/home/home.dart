import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:holcomb_tree_trail/routes/home_routes.dart';

class HomePage extends StatelessWidget {
  HomePage({
    super.key, 
    this.onTabChange,
  });
  
  final String title = 'Welcome';
  final AssetImage _assetLogo = AssetImage('lib/assets/tree_trail_logo.png');
  final void Function(int, {String? routeName})? onTabChange;

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
            Padding(
              padding: EdgeInsets.fromLTRB(20, 40, 20, 80),
              child: AspectRatio(
                aspectRatio: (1.762 / 1), // replace
                child: Image(
                  image: _assetLogo,
                  fit: BoxFit.cover,
                )
              ),
            ),

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