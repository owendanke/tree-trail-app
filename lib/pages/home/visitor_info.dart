import 'package:flutter/material.dart';

class VisitorInfoPage extends StatefulWidget {
  const VisitorInfoPage({super.key});
  
  final String title = 'Visitor Info';
  final String textData = 'text data';
  
  @override
  State<VisitorInfoPage> createState() => _VisitorInfoPageState();
}

class _VisitorInfoPageState extends State<VisitorInfoPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
        ),
      body: Center(
        child: Column(
          children: [
            Padding(padding: EdgeInsets.symmetric(vertical: 16.0)),
            Text(widget.textData),
            ]
        ),
      ),
    );
  }
}