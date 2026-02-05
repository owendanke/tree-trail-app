import 'package:flutter/material.dart';
import 'package:httapp/main.dart';
import 'package:httapp/pages/explore/tree_template.dart';

class TreeListPage extends StatefulWidget {
  TreeListPage({
    super.key,
    this.onTabChange,
    });
  
  final String title = 'Featured Trees';
  final void Function(int, {String? routeName})? onTabChange;
  
  @override
  State<TreeListPage> createState() => _TreeListPageState();
}

class _TreeListPageState extends State<TreeListPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
              //mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (var id in treePageData.keys)
                  TreeTemplateItem(
                    id: id,
                    name: treePageData[id]!['name']!,
                    imageFile: (treePageData[id]!['thmFile']!.existsSync()) ? treePageData[id]!['thmFile'] : null,
                  ),
              ]
            ),
          );
        },
      ),
    );
  }
}