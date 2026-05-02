// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';
import 'package:httapp/main.dart';
import 'package:httapp/models/entity/tree_entity_data.dart';
import 'package:httapp/models/remote_path.dart';

// httapp
import 'package:httapp/routes/app_routes.dart';
import 'package:httapp/pages/explore/explore.dart';
import 'package:httapp/pages/explore/tree_list.dart';
import 'package:httapp/ui/tree_page_template.dart';

class ExploreRoutes implements AppRoutes{
  // Route name constants
  static const String explore = '/';
  static const String treeList = '/tree_list';
  final Map<String, Widget Function(BuildContext)> routes = {
      '/': (context) => ExplorePage(),
      '/tree_list': (context) => TreeListPage(),
    };

  // Map<dynamic, dynamic> externalRoutes;
  
  // ExploreRoutes({required this.externalRoutes});
  ExploreRoutes();

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName})? onTabChange}) {

    for (var entity in catalogService.entities.value.where((e) => e.type == EntityType.tree)) {
      final routeName = '/${entity.id}';
      routes[routeName] = (context) => TreePageTemplate(
          entity: entity as TreeEntityData,
          onTabChange: onTabChange,
        );
    }

    return routes;
  }
}