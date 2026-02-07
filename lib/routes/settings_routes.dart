import 'package:flutter/material.dart';
import 'app_routes.dart';

// Import page files
import 'package:httapp/pages/settings/settings.dart';
import 'package:httapp/pages/settings/advanced_settings.dart';
import 'package:httapp/pages/settings/customization_settings.dart';

class SettingsRoutes implements AppRoutes{
  // Route name constants
  static const String settings = '/';
  static const String advanced = '/advanced';
  static const String customization = '/customization';

  @override
  String get initialRoute => '/';

  @override
  Map<String, WidgetBuilder> getRoutes(BuildContext context, {Function(int)? onTabChange}) {
    return {
      '/': (context) => SettingsPage(),
      '/advanced' : (context) => AdvancedSettings(),
      '/customization' : (context) => CustomizationSettings(),
    };
  }
}