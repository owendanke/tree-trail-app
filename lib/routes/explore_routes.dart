import 'package:flutter/material.dart';
import 'app_routes.dart';

// Import page files
import 'package:httapp/pages/explore/explore.dart';
import 'package:httapp/pages/explore/tree_list.dart';
import 'package:httapp/ui/template_tree_page.dart';

class ExploreRoutes implements AppRoutes{
  // Route name constants
  static const String explore = '/';
  static const String treeList = '/tree_list';
  final Map<String, Widget Function(BuildContext)> routes = {
      '/': (context) => ExplorePage(),
      '/tree_list': (context) => TreeListPage(),
    };

  Map<dynamic, dynamic> externalRoutes;
  
  ExploreRoutes({required this.externalRoutes});

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName})? onTabChange}) {

    for (var page in externalRoutes.entries) {
      // add '/treePage/' before each key as to not confuse what the route is for
      final routeName = '/${page.key}';
      routes[routeName] = (context) => TemplateTreePage(
          id: page.value['id'], 
          name: page.value['name'], 
          body: page.value['body'],
          location: page.value['location'],
          imageFileList: page.value['imageFileList'],
          onTabChange: onTabChange,
        );
    }

    return routes;
  }
}