// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';


// httapp
import 'package:httapp/routes/app_routes.dart';
import 'package:httapp/main.dart';
import 'package:httapp/pages/map/map.dart';
import 'package:httapp/ui/tree_page_template.dart';
import 'package:httapp/models/entity/tree_entity_data.dart';
import 'package:httapp/models/remote_path.dart';

class MapRoutes implements AppRoutes{
  // Route name constants
  static const String map = '/';
  // Map<dynamic, dynamic> externalRoutes;
  
  // MapRoutes({required this.externalRoutes});
  MapRoutes();

  @override
  String get initialRoute => map;

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {void Function(int newIndex, {String? routeName})? onTabChange}) {
    
    final Map<String, WidgetBuilder> routes = {
      map: (context) => MapPage(),
      };

    for (var entity in catalogService.entities.value.where((e) => e.type == EntityType.tree)) {
      final routeName = '/map/${entity.id}';
      routes[routeName] = (context) => TreePageTemplate(
          entity: entity as TreeEntityData,
          onTabChange: onTabChange,
        );
    }

    return routes;
  }
}