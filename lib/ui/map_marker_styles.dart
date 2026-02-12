import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:httapp/ui/poi_node_style.dart';

PoiNodeStyle treeMarkerTheme = PoiNodeStyle(
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

PoiNodeStyle signMarkerTheme = PoiNodeStyle(
  fillColor: Colors.blue,
  selectedFillColor: Colors.lightBlue,
  borderColor: Colors.blueAccent,
  selectedBorderColor: Colors.deepPurple,
  selectedShadow: [
    BoxShadow(
      color: Color(0x66000000),
      blurRadius: 4,
      spreadRadius: 3,
    )
  ],
);