import 'package:flutter/material.dart';
import 'app_routes.dart';

// Import page files
import 'package:holcomb_tree_trail/pages/explore/explore.dart';
import 'package:holcomb_tree_trail/pages/explore/tree_list.dart';

class ExploreRoutes implements AppRoutes{
  // Route name constants
  static const String explore = '/';
  static const String treeList = '/tree_list';

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      '/': (context) => ExplorePage(),
      '/tree_list': (context) => TreeListPage(),
    };
  }
}