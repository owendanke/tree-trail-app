import 'package:flutter/material.dart';
import 'package:httapp/routes/settings_routes.dart';
import 'package:httapp/services/version_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  
  final String title = 'Settings';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary, 
        title: Text(title,)
        ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: [
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
      /*
      SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SwitchListTile(
              title: Text('Example Switch'),
              value: _value,
              onChanged: (bool value) {
                setState(() {
                _value = value;
                });
              },
            ),
            ListTile(title: Text("Reset cached data"), 
              onTap: () {
                // TODO call method from file manager class
              },
            ),

            Text("Version: $_versionNumber")
          ],
        ),
      ),
      */
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