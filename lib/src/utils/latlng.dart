import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

extension LatLngParse on Position {
  LatLng toLatLng() {
    return LatLng(latitude, longitude);
  }
}
