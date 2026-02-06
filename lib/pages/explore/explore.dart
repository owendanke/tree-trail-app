import 'package:flutter/material.dart';

import 'package:httapp/routes/explore_routes.dart';

class ExplorePage extends StatefulWidget {
  const ExplorePage({super.key});
  
  final String title = 'Explore';
  
  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
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