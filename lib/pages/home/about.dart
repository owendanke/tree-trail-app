import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutPage extends StatefulWidget {
  AboutPage({super.key});
  
  final String title = 'About';
  final AssetImage _assetImage = AssetImage('assets/HTT_farm_view.png');
  final AssetImage _placeholder = AssetImage('assets/rotating_leaf.gif');
  
  @override
  State<AboutPage> createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> {

  String _textContent = '';

  @override
  void initState() {
    super.initState();
    _loadTextAsset();
    //_loadImageAsset();
  }

  Future<void> _loadTextAsset() async {
    try {
      final text = await rootBundle.loadString('assets/ABOUT_THE_TRAIL.txt');
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
              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 40.0),
              child: Text(_textContent, style: Theme.of(context).textTheme.bodyMedium,)
            ),
          ]
        ),
      ),
    );
  }
}