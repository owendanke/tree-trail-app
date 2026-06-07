// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:httapp/ui/appbar.dart';
import 'package:httapp/launch_url.dart';

// httapp
import 'package:httapp/services/text_theme_service.dart';

class AboutPage extends StatelessWidget {
  AboutPage({super.key});
  
  final String title = 'About';
  final String _assetImage = 'assets/HTT_farm_view.png';
  final Future<String> _textContent = rootBundle.loadString('assets/ABOUT_THE_TRAIL.markdown');

  @override
  Widget build(BuildContext context) {

    // create futurebuilder because the string is loaded in as a future
    return FutureBuilder(
      future: _textContent,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: MyAppBar(title: title),
          extendBodyBehindAppBar: true,
          
          body: SingleChildScrollView(
            child: Column(
              children: [
                // floating app bar padding cheat
                SizedBox(height: 100),
                
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
                    ? MarkdownBody(
                      data: snapshot.data!,
                      onTapLink: (text, href, title) => showDialog<String>(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
                          title: const Text('Open link in browser?'),
                          actions: <Widget>[
                            OutlinedButton(
                              onPressed: () => Navigator.pop(context, 'Cancel'),
                              child: const Text('Cancel'),
                            ),
                            FilledButton(
                              onPressed: () {
                                urlLauncher(href!);
                                Navigator.pop(context, 'Okay');
                                },
                              child: const Text('Okay'),
                            ),
                          ],
                        ),
                      ),
                      )
                    : CircularProgressIndicator()
                ),

                // offset sheet from navigation bar, another hack
                SizedBox(height: 90)
              ]
            ),
          ),
        );
      }
    );
  }
}