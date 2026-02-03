import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class VisitorInfoPage extends StatefulWidget {
  VisitorInfoPage({super.key});
  
  final String title = 'Visitor Info';
  final AssetImage _assetImage = AssetImage('lib/assets/north_field_fall_vista.jpg');
  
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
      final text = await rootBundle.loadString('lib/assets/VISITOR_INFO.txt');
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
        title: Text(widget.title, style: TextStyle(color: Theme.of(context).colorScheme.onPrimary)),
        ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // image from asset bundle with no horizontal padding
            AspectRatio(
              aspectRatio: (2.21 / 1), // replace
              child: FadeInImage(
                placeholder: AssetImage('lib/assets/rotating_leaf.gif'),
                placeholderFit: BoxFit.scaleDown,
                image: widget._assetImage,
                fit: BoxFit.cover,
              )
            ),

            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
              child: Text(_textContent)
            ),
          ]
        ),
      ),
    );
  }
}