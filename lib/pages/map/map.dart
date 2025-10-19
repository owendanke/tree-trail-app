import 'package:flutter/material.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  
  final String title = 'Map';
  
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Placeholder()
    );
  }
}