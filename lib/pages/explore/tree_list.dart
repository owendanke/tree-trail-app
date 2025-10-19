import 'package:flutter/material.dart';

class TreeEntry extends StatelessWidget {
  const TreeEntry({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
            leading: SizedBox(width: 50, height: 100, child: ColoredBox(color: Colors.grey)), // Image placeholder
            title: Text(name),
            subtitle: Text('Tap to learn more'),
            minTileHeight: 100,
            onTap: () {
              // Navigate using named route
            }
          );
  }
}

class TreeListPage extends StatefulWidget {
  const TreeListPage({super.key});
  
  final String title = 'Featured Trees';
  
  @override
  State<TreeListPage> createState() => _TreeListPageState();
}

class _TreeListPageState extends State<TreeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TreeEntry(name: 'Test Tree Name'),
          ],
        ),
      ),
    );
  }
}