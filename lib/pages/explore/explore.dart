import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:holcomb_tree_trail/routes/explore_routes.dart';

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
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            CupertinoButton.filled(
              borderRadius: BorderRadius.circular(5.0),
              onPressed: () {
                Navigator.pushNamed(context, ExploreRoutes.treeList);
              },
              child: const Text('Featured Trees'),
            ),
          ],
        ),
      ),
    );
  }
}