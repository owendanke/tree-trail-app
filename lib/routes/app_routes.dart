import 'package:flutter/material.dart';

abstract class AppRoutes {
  Map<String, WidgetBuilder> getRoutes(BuildContext context) {
    throw UnimplementedError();
  }
  
  String get initialRoute => '/';
}