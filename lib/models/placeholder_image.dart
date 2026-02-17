// Copyright (c) 2026, Owen Danke

// Flutter
import 'package:flutter/material.dart';

Widget placeholderImage() {
  return SizedBox(
    width: 400,
    height: 300,
    child: ColoredBox(
      color: Colors.grey.shade700,
      child: Icon(Icons.image_outlined, color: Colors.grey.shade200, size: 100,)
      )
  );
}