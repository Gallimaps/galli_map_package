import 'package:flutter/material.dart';

class Three60Marker {
  final Widget? three60Widget;
  final double? three60MarkerSize;
  final bool? show360ImageOnMarkerClick;
  final Function(String image)? on360MarkerTap;
  final Color? three60MarkerColor;

  const Three60Marker({
    this.three60Widget,
    this.three60MarkerSize,
    this.show360ImageOnMarkerClick,
    this.on360MarkerTap,
    this.three60MarkerColor,
  });
}
