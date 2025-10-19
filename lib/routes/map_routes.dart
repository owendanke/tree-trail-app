import 'package:flutter/material.dart';
import 'app_routes.dart';

// Import page files
import 'package:holcomb_tree_trail/pages/map/map.dart';

class MapRoutes implements AppRoutes{
  // Route name constants
  static const String map = '/';

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      '/': (context) => MapPage(),
    };
  }
}