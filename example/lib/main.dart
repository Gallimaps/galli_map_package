import 'package:example/key_constant.dart';
import 'package:flutter/material.dart';
import 'package:galli_map/galli_map.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(DevicePreview(
    enabled: false,
    builder: (context) => const MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Galli Package',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  final GalliController controller = GalliController(
    authKey: KeyConstant.key,
    zoom: 16,
    initialPosition: LatLng(27.672905, 85.312215),
  );
  final GalliMethods galliMethods = GalliMethods(KeyConstant.key);
  final Three60Marker three60Marker = Three60Marker(
    on360MarkerTap: () {},
  );
  final ViewerClass viewer = ViewerClass(
    viewer: Viewer(
        accessToken: KeyConstant.key,
        pinIcon: const Icon(
          Icons.abc,
          size: 48,
        ),
        animSpeed: 2,
        height: 300,
        width: 300,
        onSaved: (x, y) {}),
    viewerPosition: const Offset(32, 32),
  );
  final SearchClass search = SearchClass(
    searchHeight: 40,
    searchWidth: 340,
    fromTop: 16,
    fromLeft: 20,
    onTapAutoComplete: (AutoCompleteModel model) async {
      // FeatureModel? feature =
      //     await galliMethods.search(model.name!, controller.map.center);
      // if (feature != null) {
      //   await galliMethods.getRoute(
      //       source: controller.map.center,
      //       destination: feature.geometry!.coordinates!.first);
      // destination: feature.geometry.coordinates.first
      // }
    },
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: GalliMap(
            onMapLoadComplete: (controller) async {
              // galliMethods.animateMapMove(LatLng(27.709857, 85.339195), 18,
              //     this, mounted, controller);
            },
            controller: controller,
            showCurrentLocation: true,
            onTap: (tap) {
              galliMethods.reverse(tap);
            },
            onMapUpdate: (event) {},
            circles: [
              GalliCircle(
                  center: LatLng(28.684222, 85.303778),
                  radius: 40,
                  color: Colors.white,
                  borderStroke: 3,
                  borderColor: Colors.black)
            ],
            search: search,
            viewer: viewer,
            three60marker: three60Marker,
            lines: [
              GalliLine(
                  line: [
                    LatLng(27.684222, 85.303778),
                    LatLng(27.684246, 85.303780),
                    LatLng(27.684222, 85.303790),
                    LatLng(27.684230, 85.303778),
                  ],
                  borderColor: Colors.blue,
                  borderStroke: 2,
                  lineColor: Colors.white,
                  lineStroke: 2)
            ],
            polygons: [
              GalliPolygon(
                polygon: [
                  LatLng(27.684222, 85.303778),
                  LatLng(27.684246, 85.303780),
                  LatLng(27.684222, 85.303790),
                  LatLng(27.684290, 85.303754),
                ],
                borderColor: Colors.red,
                borderStroke: 2,
                color: Colors.green,
              ),
            ],
            markerClusterWidget: (context, list) {
              return Container(
                width: 20,
                height: 20,
                color: Colors.red,
                child: Center(
                  child: Text(list.length.toString()),
                ),
              );
            },
            markers: [
              GalliMarker(
                  latlng: LatLng(27.686222, 85.30134),
                  anchor: Anchor.top,
                  markerWidget: const Icon(
                    Icons.location_history,
                    color: Colors.black,
                    size: 48,
                  )),
              GalliMarker(
                  latlng: LatLng(27.684222, 85.30144),
                  anchor: Anchor.top,
                  markerWidget: const Icon(
                    Icons.location_history,
                    color: Colors.black,
                    size: 48,
                  )),
              GalliMarker(
                  latlng: LatLng(27.684122, 85.30135),
                  anchor: Anchor.top,
                  markerWidget: const Icon(
                    Icons.location_history,
                    color: Colors.black,
                    size: 48,
                  )),
              GalliMarker(
                  latlng: LatLng(27.684212, 85.30194),
                  anchor: Anchor.top,
                  markerWidget: const Icon(
                    Icons.location_history,
                    color: Colors.black,
                    size: 48,
                  )),
              GalliMarker(
                  latlng: LatLng(27.684221, 85.30134),
                  anchor: Anchor.top,
                  markerWidget: const Icon(
                    Icons.location_history,
                    color: Colors.black,
                    size: 48,
                  )),
            ],
            children: [
              Positioned(
                  top: 64,
                  right: 64,
                  child: GestureDetector(
                    onTap: () {
                      galliMethods.animateMapMove(LatLng(28.684222, 85.303778),
                          16, this, mounted, controller.map);
                    },
                    child: Container(
                      width: 32,
                      height: 32,
                      color: Colors.yellow,
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
