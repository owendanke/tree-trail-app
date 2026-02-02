import 'package:flutter/material.dart';
//import 'package:flutter/cupertino.dart';
import 'package:package_info_plus/package_info_plus.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  
  final String title = 'Settings';
  
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _value = false;
  late PackageInfo packageInfo;
  late String _versionNumber;

  Future<void> _loadVersionNumber() async {
    try {
      packageInfo = await PackageInfo.fromPlatform();
      setState(() {
        _versionNumber = packageInfo.version;
      });
    } catch (e) {
      setState(() {
        _versionNumber = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    _loadVersionNumber();
    
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: SingleChildScrollView(
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
    );
  }
}