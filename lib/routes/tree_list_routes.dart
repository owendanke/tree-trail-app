import 'package:flutter/material.dart';
import 'app_routes.dart';

/*
  Creates routes for navigating generated tree list items and pages
*/

// Import Pages
import 'package:httapp/pages/explore/tree_list.dart';

class TreeListRoutes implements AppRoutes{
  // Route name constants
  static const String treeList = '/';

  var externalRoutes;
  
  TreeListRoutes({required this.externalRoutes});


  @override
  String get initialRoute => treeList;

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName})? onTabChange}) {
    return {
      initialRoute: (context) => TreeListPage()
      };
  }
}