import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'package:httapp/main.dart';

// Import page files
import 'package:httapp/pages/map/map.dart';
import 'package:httapp/pages/explore/tree_list.dart';
import 'package:httapp/pages/explore/tree_template.dart';

class MapRoutes implements AppRoutes{
  // Route name constants
  static const String map = '/';
  static const String treePage = '/tree_list/treePage';

  late final Map<String, Widget Function(BuildContext)> routes;

  Function(int, {String? routeName})? _onTabChange;
  Map<dynamic, dynamic> externalRoutes;
  
  MapRoutes({required this.externalRoutes});

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName})? onTabChange}) {
    
    routes = {
      '/': (context) => MapPage(poiList: poiData, onTabChange: onTabChange),
      '/tree_list': (context) => TreeListPage(),
    };

    for (var page in externalRoutes.entries) {
      // add '/treePage/' before each key as to not confuse what the route is for
      var routeName = '/treePage/${page.key}';
      routes[routeName] = (context) => TreeTemplatePage(
          id: page.value['id'], 
          name: page.value['name'], 
          body: page.value['body'],
          imageFileList: page.value['imageFileList'],
        );
    }

    return routes;
  }
}