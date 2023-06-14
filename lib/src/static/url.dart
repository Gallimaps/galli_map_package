import 'package:latlong2/latlong.dart';

class GalliUrl {
  final String imageUrl = "https://image.gallimap.com";
  final String geoUrl = "https://route-init.gallimap.com";

  String param(String accessToken) => "?accessToken=$accessToken";

  String get360Points(
          LatLng minlatlng, LatLng maxLatlng, zoomLevel, String accessToken) =>
      "/api/v1/streetmarker/${minlatlng.latitude},${minlatlng.longitude}/${maxLatlng.latitude},${maxLatlng.longitude}/$zoomLevel?accessToken=$accessToken";
  String reverseGeoCode(LatLng latLng, String accessToken) =>
      "/api/v1/reverse/generalReverse?accessToken=$accessToken&lat=${latLng.latitude}&lng=${latLng.longitude}";
  String autoComplete(String query, String accessToken, {LatLng? latlng}) =>
      "/api/v1/search/autocomplete?accessToken=$accessToken&word=$query&lat=${latlng == null ? "" : latlng.latitude}&lng=${latlng == null ? "" : latlng.longitude}";
  String search(String place, LatLng latlng, String accessToken) =>
      "/api/v1/search/currentLocation?accessToken=$accessToken&name=$place&currentLat=${latlng.latitude}&currentLng=${latlng.longitude}";
  String getRoute(
          {required LatLng source,
          required LatLng destination,
          required String accessToken}) =>
      "/api/v1/routing?mode=driving&srcLat=${source.latitude}&srcLng=${source.longitude}&dstLat=${destination.latitude}&dstLng=${destination.longitude}&accessToken=$accessToken";
}

final GalliUrl galliUrl = GalliUrl();
