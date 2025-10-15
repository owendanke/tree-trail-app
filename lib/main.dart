import 'package:flutter/material.dart';
import 'package:holcomb_tree_trail/ui/nav_bar.dart';
import 'package:holcomb_tree_trail/ui/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Holcomb Tree Trail',
      theme: ThemeData.from(colorScheme: MaterialTheme.lightScheme()),
      //home: HomePage(title: 'Home Page'),
      home: const MainNavigation(), // use MainNavigation instead of HomePage
    );
  }
}
