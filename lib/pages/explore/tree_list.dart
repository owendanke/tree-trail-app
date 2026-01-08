import 'package:flutter/material.dart';
import 'package:holcomb_tree_trail/main.dart';
import 'package:holcomb_tree_trail/pages/explore/tree_template.dart';

/*
class TreeEntry extends StatelessWidget {
  const TreeEntry({super.key, required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    return ListTile(
            leading: SizedBox(width: 128, height: 128, child: ColoredBox(color: Colors.grey)), // Image placeholder
            title: Text(name),
            minTileHeight: 256,
            onTap: () {
              // Navigate using named route
            }
          );
  }
}
*/

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
                    imageFile: (treePageData[id]!['imageFileList'] != null && 
                                treePageData[id]!['imageFileList']!.isNotEmpty)
                                ? treePageData[id]!['imageFileList']![0]
                                : null,
                  ),
              ]
            ),
          );
        },
      ),
    );
  }
}