import 'package:flutter/material.dart';

enum Size {small, medium, large}

enum BodySize {bodySmall, bodyMedium, bodyLarge}


class TextThemeService {
  static final TextThemeService _singleton = TextThemeService._internal();
  factory TextThemeService() => _singleton;
  TextThemeService._internal();

  late final TextTheme textTheme;
  bool _initialized = false;

  final List<double> _textScales = [1.0, 1.12, 1.22];

  //
  // body sizes
  TextStyle? displayStyle = TextStyle();
  TextStyle? headlineStyle = TextStyle();
  TextStyle? bodyStyle = TextStyle();
  TextScaler markdownTextScale = TextScaler.noScaling;
  
  
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

  set setMarkdownTextScale(Size size) {
    switch (size) {
      case Size.small:
        // set no scale
        markdownTextScale = TextScaler.linear(_textScales[0]);
        
      case Size.medium:
        // set medium
        markdownTextScale = TextScaler.linear(_textScales[1]);

      case Size.large:
        // set large
        markdownTextScale = TextScaler.linear(_textScales[2]);
      }
  }

  TextStyle? get getBodySize {
    return bodyStyle;
  }
}