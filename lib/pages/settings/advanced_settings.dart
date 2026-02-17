// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

// httapp
import 'package:httapp/models/local_path.dart';
import 'package:httapp/services/local_file_handling.dart';

class AdvancedSettings extends StatelessWidget {
  final String title = 'Advanced Settings';

  const AdvancedSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
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
  late String _localPath;
  late String _localDescPath;
  late String _localImagePath;
  
  void _setPaths() async {
    _localPath = await localPath;
    _localDescPath = await localDescPath;
    _localImagePath = await localImagePath;
  }

  @override
  Widget build(BuildContext context) {
    _setPaths();

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
                      style: FilledButton.styleFrom(
                        foregroundColor: Theme.of(context).colorScheme.onError,
                        backgroundColor: Theme.of(context).colorScheme.error,
                        ),
                      onPressed: () {
                        Navigator.of(context).pop(); // close dialog
                      },
                      child: const Text('Cancel')
                    ),
                    FilledButton(
                      onPressed: () {
                        // Delete all local files

                        // Delete manifest file
                        LocalFileHandler.deleteFileSync('tree_manifest.yaml', _localPath);

                        // Delete image files
                        LocalFileHandler.deleteAllFilesSync(_localImagePath);

                        // Delete description files
                        LocalFileHandler.deleteAllFilesSync(_localDescPath);

                        // Start downloading files again

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