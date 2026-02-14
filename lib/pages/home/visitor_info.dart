import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:httapp/services/text_theme_service.dart';

class VisitorInfoPage extends StatelessWidget {
  VisitorInfoPage({super.key});
  
  final String title = 'Visitor Info';
  final String _assetImage = 'assets/north_field_fall_vista.jpg';
  final Future<String> _textContent = rootBundle.loadString('assets/VISITOR_INFO.txt');

  @override
  Widget build(BuildContext context) {

    // create futurebuilder because the string is loaded in as a future
    return FutureBuilder(
      future: _textContent,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(title: Text(title),),
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
                      child: Image.asset(
                        _assetImage,
                        fit: BoxFit.cover,
                        cacheWidth: MediaQuery.sizeOf(context).width.toInt()
                        )
                    ),
                  ),
                ),

                // Text displayed under the image
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                  //child: Text(_textContent, style: Theme.of(context).textTheme.bodyMedium,)
                  child: snapshot.hasData
                    ? Text(snapshot.data!, style: TextThemeService().bodyStyle)
                    : CircularProgressIndicator()
                ),
              ]
            ),
          ),
        );
      }
    );
  }
}