// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

// httapp
import 'package:httapp/routes/settings_routes.dart';
import 'package:httapp/services/version_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  
  final String title = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: [
          // customization settings
          _navigationTile(
            context,
            icon: Icons.edit_square,
            title: 'Customization Settings',
            subtitle: 'Text and display settings',
            onTap: () => Navigator.pushNamed(context, SettingsRoutes.customization),
          ),

          Divider(),

          // advanced settings
          _navigationTile(
            context,
            icon: Icons.tune,
            title: 'Advanced Settings',
            subtitle: 'Manage local files',
            onTap: () => Navigator.pushNamed(context, SettingsRoutes.advanced),
          ),

          Divider(),

          // Version
          Padding(
            padding: EdgeInsetsGeometry.symmetric(),
            child: Text('Version: ${VersionService().version}', textAlign: TextAlign.center,))
        ],
      )
    );
  }
}

Widget _navigationTile(BuildContext context, 
  {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }