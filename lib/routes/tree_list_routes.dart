import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'package:httapp/ui/tree_template.dart';

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
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName})? onTabChange}) {
    final Map<String, Widget Function(BuildContext)> routes = {'/': (context) => TreeListPage()};

    print('External routes: ${externalRoutes.keys}');

    for (var page in externalRoutes.entries) {
      // add '/treePage/' before each key as to not confuse what the route is for
      final routeName = '/treePage/${page.key}';
      routes[routeName] = (context) => TreeTemplatePage(
          id: page.value['id'], 
          name: page.value['name'], 
          body: page.value['body'],
          location: page.value['location'],
          imageFileList: page.value['imageFileList'],
          onTabChange: onTabChange,
        );
    }

    print('Final routes: ${routes.keys}');
    return routes;
  }
}