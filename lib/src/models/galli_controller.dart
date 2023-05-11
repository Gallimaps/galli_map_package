import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class GalliController {
  final String authKey;
  final double zoom;
  final double maxZoom;
  final double minZoom;
  final LatLng? initialPosition;
  MapController map = MapController();
  GalliController({
    required this.authKey,
    this.zoom = 16,
    this.maxZoom = 18,
    this.minZoom = 10,
    this.initialPosition,
  });
}

final GalliController galliController =
    GalliController(authKey: "89a40903-b75a-46b6-822b-86eebad4fa36");
