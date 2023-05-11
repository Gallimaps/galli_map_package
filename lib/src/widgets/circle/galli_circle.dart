import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

/// A class that represents a circle with a center point and a radius.
class GalliCircle {
  /// The radius of the circle in meters.
  final double radius;

  /// The center point of the circle.
  final LatLng center;

  /// The fill color of the circle.
  final Color color;

  /// The border color of the circle.
  final Color borderColor;

  /// The width of the border of the circle.
  final double borderStroke;

  /// Creates a new instance of the [GalliCircle] class.
  ///
  /// [radius] The radius of the circle in meters.
  /// [center] The center point of the circle.
  /// [color] The fill color of the circle.
  /// [borderColor] The border color of the circle.
  /// [borderStroke] The width of the border of the circle.
  GalliCircle({
    this.color = Colors.white,
    this.borderColor = Colors.black,
    this.borderStroke = 1,
    required this.center,
    required this.radius,
  });

  /// Converts this instance of the [GalliCircle] class to a [CircleMarker] for use with [FlutterMap].
  CircleMarker toCircleMarker() {
    return CircleMarker(
      radius: radius,
      point: center,
      color: color,
      borderColor: borderColor,
      borderStrokeWidth: borderStroke,
      useRadiusInMeter: true,
    );
  }

  /// Determines whether a given point is inside the circle.
  ///
  /// [point] The point to check.
  ///
  /// Returns true if the point is inside the circle, false otherwise.
  bool containsPoint(LatLng point) {
    double distance = Geolocator.distanceBetween(
      point.latitude,
      point.longitude,
      center.latitude,
      center.longitude,
    );
    if (distance > radius) {
      return false;
    } else {
      return true;
    }
  }
}
