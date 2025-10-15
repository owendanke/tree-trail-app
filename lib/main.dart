import 'package:flutter/material.dart';
import 'package:holcomb_tree_trail/pages/home/home.dart';
import 'package:holcomb_tree_trail/ui/nav_bar.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Holcomb Tree Trail',
      
      //home: HomePage(title: 'Home Page'),
      home: MainNavigation(), // use MainNavigation instead of HomePage
    );
  }
}
