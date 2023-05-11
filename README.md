# Galli Map for Flutter
[![pub package](https://img.shields.io/pub/v/galli_map.svg)](https://pub.dartlang.org/packages/galli_map)


Galli Map is a Flutter package that provides a customizable map widget for displaying Map with custom markers, lines, circles, and polygons. The widget supports zooming in and out, tapping on the map, and showing the user's current location.



## Installation

To use this package, add galli_map as a dependency in your pubspec.yaml file:
```yaml
dependencies:
    galli_map: ${latest_version}
```

Then run flutter pub get to install the package.

## Usage

Import and add the Galli Map widget to your project
```dart
import 'package:galli_map/galli_map.dart';
... ...

  final GalliController controller = GalliController();

@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: GalliMap(
           authKey: "authToken",
           controller: controller,
           zoom: 16,
           onTap: (tap) {},
           circles: [
             GalliCircle(
                 center: LatLng(27.12441, 67.12412),
                 radius: 32,
                 color: Colors.white,
                 borderStroke: 3,
                 borderColor: Colors.black)
           ],
           lines: [
             GalliLine(
                 line: [
                   LatLng(27.12441, 67.12412),
                   LatLng(27.12441, 67.12412),
                   LatLng(27.12441, 67.12412),
                   LatLng(27.12441, 67.12412)
                 ],
                 borderColor: Colors.blue,
                 borderStroke: 1,
                 lineColor: Colors.white,
                 lineStroke: 2)
           ],
           polygons: [
             GalliPolygon(polygon: [
               LatLng(27.12441, 67.12412),
               LatLng(27.12441, 67.12412),
               LatLng(27.12441, 67.12412),
               LatLng(27.12441, 67.12412)
             ], borderColor: Colors.red, borderStroke: 2, color: Colors.green),
           ],
           markers: [
             GalliMarker(
                 latlng: LatLng(27.12441, 67.12412),
                 markerWidget: const Icon(Icons.location_city))
           ],
         ),

    );
  }
 ```
