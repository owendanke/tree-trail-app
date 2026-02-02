import 'package:flutter/material.dart';
import 'app_routes.dart';

// Import page files
import 'package:httapp/pages/home/home.dart';
import 'package:httapp/pages/home/about.dart';
import 'package:httapp/pages/home/visitor_info.dart';
import 'package:httapp/pages/explore/tree_list.dart';

class HomeRoutes implements AppRoutes{
  // Route name constants
  static const String home = '/';
  static const String treeList = '/tree_list';
  static const String about = '/about';
  static const String visitorInfo = '/visitor_info';
  Function(int, {String? routeName})? onTabChange;

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName})? onTabChange}) {
    return {
      '/': (context) => HomePage(onTabChange: onTabChange),
      '/tree_list': (context) => TreeListPage(onTabChange: onTabChange),
      '/about' : (context) => AboutPage(),
      '/visitor_info' : (context) => VisitorInfoPage(),
    };
  }
}