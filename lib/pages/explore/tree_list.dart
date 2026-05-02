// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

// httapp
import 'package:httapp/main.dart';
import 'package:httapp/models/entity/tree_entity_data.dart';
import 'package:httapp/models/remote_path.dart';
import 'package:httapp/ui/tree_list_item_template.dart';
import 'package:httapp/ui/appbar.dart';

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
      appBar: MyAppBar(title: widget.title),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
        return SingleChildScrollView(
          child: Column(
              children: [
                // floating app bar padding cheat
                SizedBox(height: 100),

                for (var entity in catalogService.entities.value.where((e) => e.type == EntityType.tree))
                  TreeListItemTemplate(
                    entity: entity as TreeEntityData,
                  ),

                // Padding to make the space between the end of the list and bottom 
                // navigation bar match the space between elements in the list
                Padding(padding: EdgeInsetsGeometry.only(bottom: 4)),

                // offset sheet from navigation bar, another hack
                SizedBox(height: 100)
              ]
            ),
          );
        },
      ),
    );
  }
}