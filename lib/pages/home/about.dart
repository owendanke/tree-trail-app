import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutPage extends StatefulWidget {
  AboutPage({super.key});
  
  final String title = 'About';

  // TODO, clean this up
  // getting screen pixels
  // first get the FlutterView.
  final FlutterView view = WidgetsBinding.instance.platformDispatcher.views.first;

  // pixel dimensions
  late final Size size = view.physicalSize;
  late final double screenWidth = size.width;
  late final double screenHeight = size.height;
  
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  String _textContent = '';

  @override
  void initState() {
    super.initState();
    _loadTextAsset();
  }

  Future<void> _loadTextAsset() async {
    try {
      final text = await rootBundle.loadString('lib/assets/ABOUT_THE_TRAIL.txt');
      setState(() {
        _textContent = text;
      });
    } catch (e) {
      setState(() {
        _textContent = 'Error loading text: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image from asset bundle with no horizontal padding
            Image.asset('lib/assets/HTT_farm_view.png', fit: BoxFit.scaleDown, width: widget.screenWidth),

            Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
            
            Container(
              width: (widget.screenWidth - 40),
              child: Text(_textContent),
              ),
          ]
        ),
      ),
    );
  }
}