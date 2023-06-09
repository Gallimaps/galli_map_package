import 'package:galli_map/galli_map.dart';

/// This class represents a geographic feature, consisting of a `type`,
/// `properties`, and `geometry`. It can be parsed from and converted to JSON.
class FeatureModel {
  String? type;
  Properties? properties;
  Geometry? geometry;

  /// Constructor that creates a new `FeatureModel` with the given `type`,
  /// `properties`, and `geometry`.
  FeatureModel({
    this.type,
    this.properties,
    this.geometry,
  });

  /// Constructor that creates a new `FeatureModel` from a JSON map.
  FeatureModel.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    properties = json['properties'] != null
        ? Properties.fromJson(json['properties'])
        : null;
    geometry =
        json['geometry'] != null ? Geometry.fromJson(json['geometry']) : null;
  }

  /// Converts the `FeatureModel` to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (properties != null) {
      data['properties'] = properties!.toJson();
    }
    if (geometry != null) {
      data['geometry'] = geometry!.toJson();
    }
    return data;
  }
}

/// This class represents the properties of a geographic feature, consisting
/// of a `distance` and a `category`. It can be parsed from and converted to JSON.
class Properties {
  double? distance;
  String? category;

  /// Constructor that creates a new `Properties` object with the given
  /// `distance` and `category`.
  Properties({this.distance, this.category});

  /// Constructor that creates a new `Properties` object from a JSON map.
  Properties.fromJson(Map<String, dynamic> json) {
    distance = json['distance'];
    category = json['category'];
  }

  /// Converts the `Properties` object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['distance'] = distance;
    data['category'] = category;
    return data;
  }
}

/// This class represents the geometric shape of a geographic feature, consisting
/// of a `type`, `coordinates`, and `listOfCoordinates`. It can be parsed from
/// and converted to JSON.
class Geometry {
  FeatureType? type;
  List<LatLng>? coordinates;
  List<List<LatLng>>? listOfCoordinates;

  /// Constructor that creates a new `Geometry` object with the given `type`,
  /// `coordinates`, and `listOfCoordinates`.
  Geometry({this.type, this.coordinates, this.listOfCoordinates});

  /// Constructor that creates a new `Geometry` object from a JSON map.
  Geometry.fromJson(Map<String, dynamic> json) {
    type = stringToFeatureType(json['type'].toString().toLowerCase());
    listOfCoordinates = type != FeatureType.point
        ? jibbrishToCoordinates(json['coordinates'], type!)[1]
        : [jibbrishToCoordinates(json['coordinates'], type!)[0]];
    coordinates = type == FeatureType.point
        ? jibbrishToCoordinates(json['coordinates'], type!)[0]
        : [_calculateCenterCoordinate(listOfCoordinates!.first)];
  }

  LatLng _calculateCenterCoordinate(List<LatLng> coordinates) {
    double xSum = 0.0;
    double ySum = 0.0;
    for (int i = 0; i < coordinates.length; i++) {
      xSum += coordinates[i].latitude;
      ySum += coordinates[i].longitude;
    }
    double xCenter = xSum / coordinates.length;
    double yCenter = ySum / coordinates.length;
    return LatLng(xCenter, yCenter);
  }

  /// Converts the `Geometry` object to a JSON map.
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    if (coordinates != null) {
      data['coordinates'] = coordinates!.map((v) => v.toJson()).toList();
    }
    data['list_of_coordinates'] = listOfCoordinates ?? [];
    return data;
  }
}

/// Convert a string to a [FeatureType] enum
FeatureType stringToFeatureType(String string) {
  if (string == "point") {
    return FeatureType.point;
  } else if (string == "multilinestring") {
    return FeatureType.multilinestring;
  } else if (string == "multipolygon") {
    return FeatureType.multipolygon;
  } else if (string == "polygon") {
    return FeatureType.polygon;
  } else {
    return FeatureType.other;
  }
}

/// Convert a list of coordinates in "jibbrish" format to a list of [LatLng] objects
/// If the [FeatureType] is a multipolygon or multilinestring, then the function returns
/// a list of [List<LatLng>] representing the holes and polygons respectively
List<dynamic> jibbrishToCoordinates(List jibbrish, FeatureType type) {
  List<LatLng> coordinates = [];
  List<List<LatLng>> listOfCoordinates = [];

  switch (type) {
    case FeatureType.point:
      LatLng latlng = LatLng(jibbrish[1], jibbrish[0]);
      coordinates.add(latlng);
      break;
    case FeatureType.multilinestring:
      List<LatLng> data = [];
      for (var mainData in jibbrish) {
        for (var childData in mainData) {
          LatLng latLng = LatLng(childData[1], childData[0]);
          data.add(latLng);
        }
      }
      listOfCoordinates.add(data);
      break;
    case FeatureType.multipolygon:
      List<LatLng> data = [];
      for (var mainData in jibbrish) {
        for (var childData in mainData) {
          for (var innerChildData in childData) {
            LatLng latLng = LatLng(innerChildData[1], innerChildData[0]);
            data.add(latLng);
          }
        }
      }
      listOfCoordinates.add(data);
      break;
    case FeatureType.polygon:
      List<LatLng> data = [];
      for (var mainData in jibbrish) {
        for (var childData in mainData) {
          LatLng latLng = LatLng(childData[1], childData[0]);
          data.add(latLng);
        }
      }
      listOfCoordinates.add(data);
      break;
    case FeatureType.other:
      break;
  }
  return [coordinates, listOfCoordinates];
}

/// An enum to represent the different types of features in GeoJSON
enum FeatureType { point, multilinestring, multipolygon, polygon, other }
