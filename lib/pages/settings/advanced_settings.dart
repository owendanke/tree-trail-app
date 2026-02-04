import 'package:flutter/material.dart';

class AdvancedSettings extends StatelessWidget {
  final String title = 'Advanced Settings';

  const AdvancedSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
        children: [
          _LocalFileSection().build(context),
          //const Divider(),
          
        ],
      ),
    );
  }
}

abstract class LocalFileSection extends StatefulWidget {
  const LocalFileSection({super.key});

  @override
  State<LocalFileSection> createState() => _LocalFileSection();
}

class _LocalFileSection extends State<LocalFileSection> {
  
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Content
        ListTile(
          title: Text('Reload Local Files', style: Theme.of(context).textTheme.titleMedium),
          subtitle: Text('Permanently deletes asset data the app needs to function and downloads new copies.', style: TextStyle(fontSize: 12)),
          onTap: () {},
        )
      ],
    );
  }
}
