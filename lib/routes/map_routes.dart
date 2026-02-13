import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'package:httapp/main.dart';

// Import page files
import 'package:httapp/pages/map/map.dart';
import 'package:httapp/pages/explore/tree_list.dart';
import 'package:httapp/ui/tree_template.dart';

class MapRoutes implements AppRoutes{
  // Route name constants
  static const String map = '/';
  Map<dynamic, dynamic> externalRoutes;
  
  MapRoutes({required this.externalRoutes});

  @override
  String get initialRoute => map;

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName})? onTabChange}) {
    
    final Map<String, WidgetBuilder> routes = {
      map: (context) => MapPage(poiMap: poiData, signList: interpretiveSignData,),
      };

    for (var page in externalRoutes.entries) {
      var routeName = '/map/${page.key}';
      routes[routeName] = (context) => TreeTemplatePage(
          id: page.value['id'], 
          name: page.value['name'], 
          body: page.value['body'],
          //location: page.value['location'],
          location: null,
          imageFileList: page.value['imageFileList'],
        );
    }

    return routes;
  }
}