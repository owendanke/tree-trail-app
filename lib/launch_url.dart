// Copyright (c) 2026, Owen Danke

import 'package:url_launcher/url_launcher.dart';

void urlLauncher(String url) async {
   final Uri uri = Uri.parse(url);

   if (!await launchUrl(uri)) {
        throw Exception('Could not launch $uri');
    }
}