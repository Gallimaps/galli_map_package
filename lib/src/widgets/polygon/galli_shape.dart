import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GalliPolygon {
  final List<LatLng> polygon;
  final Color color;
  final Color borderColor;
  final double borderStroke;

  GalliPolygon(
      {this.color = Colors.white,
      this.borderColor = Colors.black,
      this.borderStroke = 1,
      required this.polygon});
  Polygon toPolygon() {
    return Polygon(
      points: polygon,
      color: color,
      borderColor: borderColor,
      borderStrokeWidth: borderStroke,
    );
  }

  bool containsPoint(LatLng latlng) {
    LatLngBounds bounds = LatLngBounds.fromPoints(polygon);
    if (bounds.contains(latlng)) {
      return true;
    } else {
      return false;
    }
  }
}
