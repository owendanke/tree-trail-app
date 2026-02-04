import 'package:flutter/material.dart';
import 'package:httapp/routes/home_routes.dart';

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

    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
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
    );
  }
}

Widget _buttonContainer(String text) {
  return Container(
    width: 96.0,
    //height: 24.0,
    child: Column(
      children: [Text(text),],
    )
  );
}