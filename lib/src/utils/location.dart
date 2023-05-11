import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

bool isFromNepal(LatLng locationPoint) {
  final p1 = LatLng(29.017537, 79.419947);
  final p2 = LatLng(30.937683, 80.922656);
  final p3 = LatLng(28.351873, 88.272535);
  final p4 = LatLng(25.969353, 88.093995);
  LatLngBounds nepal = LatLngBounds.fromPoints([p1, p2, p3, p4]);
  return nepal.contains(locationPoint);
}
