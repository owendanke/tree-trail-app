import 'package:flutter/material.dart';
import 'app_routes.dart';

// Import page files
import 'package:httapp/pages/settings/settings.dart';

class SettingsRoutes implements AppRoutes{
  // Route name constants
  static const String settings = '/';

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {Function(int)? onTabChange}) {
    return {
      '/': (context) => SettingsPage(),
    };
  }
}