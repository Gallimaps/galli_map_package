import 'package:latlong2/latlong.dart';

class RouteInfo {
  double? distance;
  int? duration;
  List<LatLng>? latlngs;

  RouteInfo({this.distance, this.duration, this.latlngs});

  RouteInfo.fromJson(Map<String, dynamic> json) {
    distance = ((json['distance'] / 1000));
    duration = ((json['duration'] / 60).truncate());
    if (json['latlngs'] != null) {
      latlngs = <LatLng>[];
      json['latlngs'].forEach((v) {
        latlngs!.add(LatLng(v[1] * 1.0, v[0] * 1.0));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['duration'] = duration;
    if (latlngs != null) {
      data['latlngs'] = latlngs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
