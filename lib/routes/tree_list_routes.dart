// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

// httapp
import 'package:httapp/routes/app_routes.dart';
import 'package:httapp/pages/explore/tree_list.dart';

class TreeListRoutes implements AppRoutes{
  // Route name constants
  static const String treeList = '/';

  var externalRoutes;
  
  TreeListRoutes({required this.externalRoutes});


  @override
  String get initialRoute => treeList;

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName})? onTabChange}) {
    return {
      initialRoute: (context) => TreeListPage()
      };
  }
}