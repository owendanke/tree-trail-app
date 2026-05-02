// Copyright (c) 2026, Owen Danke

import 'dart:ui' as ui;
// Flutter
import 'package:flutter/material.dart';
// httapp

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    super.key,
    required this.title,
    this.actions,
    this.leading,
  });

  final String title;
  final List<Widget>? actions;
  final Widget? leading;

  @override
  ui.Size get preferredSize => const ui.Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final topInset = MediaQuery.of(context).padding.top;
    
    return AppBar(
      toolbarHeight: preferredSize.height,
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,

      automaticallyImplyLeading: true,
      leading: leading,
      actions: actions,

      title: Text(title, style: TextStyle()),
      
      flexibleSpace: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
                
              ),
            ),
          ),
        ),
      ),
    );
  }
}