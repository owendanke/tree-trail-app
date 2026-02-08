import 'package:flutter/material.dart';
import 'package:httapp/main.dart';
import 'package:httapp/models/tree_template.dart';

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
      appBar: AppBar(title: Text(widget.title)),
      body: LayoutBuilder(
        builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
              children: [
                // Padding to make the space between appBar and top of the list 
                // match the space between elements in the list
                Padding(padding: EdgeInsetsGeometry.only(top: 4)),

                for (var id in treePageData.keys)
                  TreeTemplateItem(
                    id: id,
                    name: treePageData[id]!['name']!,
                    imageFile: treePageData[id]!['thumbnail'],
                  ),

                // Padding to make the space between the end of the list and bottom 
                // navigation bar match the space between elements in the list
                Padding(padding: EdgeInsetsGeometry.only(bottom: 4)),
              ]
            ),
          );
        },
      ),
    );
  }
}