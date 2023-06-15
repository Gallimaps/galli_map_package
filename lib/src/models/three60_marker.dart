import 'package:flutter/material.dart';

class Three60Marker {
  final Widget? three60Widget;
  final double three60MarkerSize;
  final bool show360ImageOnMarkerClick;
  final Function(String image)? on360MarkerTap;

  const Three60Marker({
    this.three60Widget,
    this.three60MarkerSize = 20,
    this.show360ImageOnMarkerClick = true,
    this.on360MarkerTap,
  });
}
