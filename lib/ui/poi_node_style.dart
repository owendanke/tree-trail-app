import 'dart:ui';

import 'package:flutter/material.dart';

class PoiNodeStyle {
  final Color fillColor;
  final Color selectedFillColor;
  final Color borderColor;
  final Color selectedBorderColor;
  final double borderWidth;
  final double selectedBorderWidth;
  final List<BoxShadow>? selectedShadow;

  const PoiNodeStyle({
    required this.fillColor,
    required this.selectedFillColor,
    required this.borderColor,
    required this.selectedBorderColor,
    this.borderWidth = 3,
    this.selectedBorderWidth = 5,
    this.selectedShadow,
  });

  /// Optional: default orange style
  /*
  factory PoiNodeStyle.defaultStyle() {
    return const PoiNodeStyle(
      fillColor: Colors.orange,
      selectedFillColor: Colors.orange,
      borderColor: Color(0xFFFB8C00),
      selectedBorderColor: Color(0xFFEF6C00),
      selectedShadow: [
        BoxShadow(
          color: Color(0x66000000),
          blurRadius: 4,
          spreadRadius: 3,
        )
      ],
    );
  }
  */
}
