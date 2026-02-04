import 'package:flutter/material.dart';

class AdvancedSettings extends StatelessWidget {
  final String title = 'Advanced Settings';

  const AdvancedSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary, 
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

class LocalFileSection extends StatefulWidget {
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
          onTap: () {
            // Open dialog asking to confirm action
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Confirm Choice'),
                  content: const Text(
                    '''
This will permanently delete local asset data and download new copies.
If the app is unable to make downloads, functionality will be extremely limited.
                    ''',
                  ),
                  actions: [
                    FilledButton.tonal(
                      onPressed: () {
                        Navigator.of(context).pop(); // close dialog
                      },
                      child: const Text('Cancel'),
                      style: FilledButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        backgroundColor: Theme.of(context).colorScheme.error,
                        )
                    ),
                    FilledButton(
                      onPressed: () {
                        // TODO: perform reload logic
                        Navigator.of(context).pop(); // close dialog
                      },
                      child: const Text('Confirm'),
                    ),
                  ],
                );
              }
            );
          },
        )
      ],
    );
  }
}