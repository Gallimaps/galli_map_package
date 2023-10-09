import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:galli_map/galli_map.dart';

/// A class representing a line on a map.
class GalliLine {
  final List<LatLng> line;
  final Color lineColor;
  final Color borderColor;
  final double lineStroke;
  final double borderStroke;

  /// Creates a new `GalliLine` instance.
  ///
  /// `line` is a list of [LatLng] points that define the line.
  ///
  /// `lineColor` is the color of the line.
  ///
  /// `borderColor` is the color of the line's border.
  ///
  /// `lineStroke` is the width of the line stroke in pixels.
  ///
  /// `borderStroke` is the width of the line border stroke in pixels.
  GalliLine(
      {this.lineColor = Colors.white,
      this.borderColor = Colors.black,
      this.lineStroke = 4,
      this.borderStroke = 1,
      required this.line});

  /// Converts the `GalliLine` instance to a [Polyline] that can be added to a map.
  Polyline toPolyline() {
    return Polyline(
        points: line,
        color: lineColor,
        borderColor: borderColor,
        borderStrokeWidth: borderStroke,
        strokeWidth: lineStroke);
  }
}
