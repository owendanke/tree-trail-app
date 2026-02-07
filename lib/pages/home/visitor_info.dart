import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VisitorInfoPage extends StatefulWidget {
  VisitorInfoPage({super.key});
  
  final String title = 'Visitor Info';
  final AssetImage _assetImage = AssetImage('assets/north_field_fall_vista.jpg');
  final AssetImage _placeholder = AssetImage('assets/rotating_leaf.gif');
  
  @override
  State<VisitorInfoPage> createState() => _VisitorInfoPageState();
}

class _VisitorInfoPageState extends State<VisitorInfoPage> {
  String _textContent = '';

  @override
  void initState() {
    super.initState();
    _loadTextAsset();
  }

  Future<void> _loadTextAsset() async {
    try {
      final text = await rootBundle.loadString('assets/VISITOR_INFO.txt');
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
    return Scaffold(
      appBar: AppBar(title: Text(widget.title),),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Image from asset bundle with no horizontal padding
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: AspectRatio(
                aspectRatio: 4/3,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: FadeInImage(
                    placeholder: widget._placeholder,
                    placeholderFit: BoxFit.scaleDown,
                    image: widget._assetImage,
                    fit: BoxFit.cover,
                  )
                ),
              ),
            ),

            // Text displayed under the image
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
              child: Text(_textContent)
            ),
          ]
        ),
      ),
    );
  }
}