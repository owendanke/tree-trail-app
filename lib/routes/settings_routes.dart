import 'package:flutter/material.dart';
import 'app_routes.dart';

// Import page files
import 'package:holcomb_tree_trail/pages/settings/settings.dart';

class SettingsRoutes implements AppRoutes{
  // Route name constants
  static const String settings = '/';

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    return {
      '/': (context) => SettingsPage(),
    };
  }
}