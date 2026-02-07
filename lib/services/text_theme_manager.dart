import 'package:flutter/material.dart';

enum Size {small, medium, large}

enum BodySize {bodySmall, bodyMedium, bodyLarge}


class TextThemeService {
  static final TextThemeService _singleton = TextThemeService._internal();
  factory TextThemeService() => _singleton;
  TextThemeService._internal();

  late final TextTheme textTheme;
  bool _initialized = false;

  //
  // body sizes
  TextStyle? displayStyle = TextStyle();
  TextStyle? headlineStyle = TextStyle();
  TextStyle? bodyStyle = TextStyle();
  
  
  /// Initialize the service by loading a TextTheme
  /// 
  void init(TextTheme textTheme) {
    if (_initialized) return;

    this.textTheme = textTheme;

    // load default values
    displayStyle = textTheme.displayMedium;
    headlineStyle = textTheme.headlineMedium;
    bodyStyle = textTheme.bodyMedium;

    _initialized = true;
  }

  set setBodySize(Size size) {
    switch (size) {
      case Size.small:
        // set bodySmall
        bodyStyle = textTheme.bodySmall;
        
      case Size.medium:
        // set bodyMedium
        bodyStyle = textTheme.bodyMedium;

      case Size.large:
        // set bodyLarge
        bodyStyle = textTheme.bodyLarge;
      }
  }

  TextStyle? get getBodySize {
    return bodyStyle;
  }
}