import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'package:holcomb_tree_trail/pages/explore/tree_template.dart';

/*
  Creates routes for navigating generated tree list items and pages
*/

// Import Pages
import 'package:holcomb_tree_trail/pages/explore/tree_list.dart';

class TreeListRoutes implements AppRoutes{
  // Route name constants
  static const String treeList = '/';

  var externalRoutes;
  
  TreeListRoutes({required this.externalRoutes});


  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {Function(int)? onTabChange}) {
    final Map<String, Widget Function(BuildContext)> routes = {'/': (context) => TreeListPage()};

    print('External routes: ${externalRoutes.keys}');

    for (var page in externalRoutes.entries) {
      // add '/treePage/' before each key as to not confuse what the route is for
      final routeName = '/treePage/${page.key}';
      routes[routeName] = (context) => TreeTemplatePage(
          id: page.value['id'], 
          name: page.value['name'], 
          body: page.value['body'],
          imageFileList: page.value['imageFileList'],
        );
    }

    print('Final routes: ${routes.keys}');
    return routes;
  }
}