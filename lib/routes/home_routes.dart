import 'package:flutter/material.dart';
import 'app_routes.dart';

// Import page files
import 'package:holcomb_tree_trail/pages/home/home.dart';
import 'package:holcomb_tree_trail/pages/home/about.dart';
import 'package:holcomb_tree_trail/pages/home/visitor_info.dart';
import 'package:holcomb_tree_trail/pages/explore/tree_list.dart';

class HomeRoutes implements AppRoutes{
  // Route name constants
  static const String home = '/';
  static const String treeList = '/tree_list';
  static const String about = '/about';
  static const String visitorInfo = '/visitor_info';

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      '/': (context) => HomePage(),
      '/tree_list': (context) => TreeListPage(),
      '/about' : (context) => AboutPage(),
      '/visitor_info' : (context) => VisitorInfoPage(),
    };
  }
}