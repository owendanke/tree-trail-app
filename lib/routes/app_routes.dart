// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

/*
  AppRoutes is an abstract base class for defining navigation routes within a tab.

  Each tab in the bottom navigation bar should have its own implementation
  of AppRoutes that defines its route map and initial route.

  Implement [getRoutes] to define the route map for a navigation tab.
  Use [onTabChange] callback to switch between tabs programmatically.
*/
abstract class AppRoutes {
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName}) onTabChange});
  //{ throw UnimplementedError(); }
  
  String get initialRoute => '/';
}