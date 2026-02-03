import 'package:flutter/material.dart';
import 'app_routes.dart';
import 'package:httapp/main.dart';

// Import page files
import 'package:httapp/pages/map/map.dart';

class MapRoutes implements AppRoutes{
  // Route name constants
  static const String map = '/';

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {Function(int)? onTabChange}) {
    return {
      '/': (context) => MapPage(poiList: poiData,),
    };
  }
}