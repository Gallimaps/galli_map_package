import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:galli_map/galli_map.dart';
import 'package:galli_map/src/functions/cache.dart';
import 'package:galli_map/src/functions/encrption.dart';
import 'package:galli_map/src/utils/latlng.dart';
import 'package:galli_map/src/utils/location.dart';
import 'package:galli_map/src/widgets/markers/user_location_marker.dart';

class GalliMap extends StatefulWidget {
  final double? height;
  final double? width;
  final bool show360Button;
  final bool showCurrentLocation;
  final bool showSearch;
  final bool showLocationButton;
  final Widget? currentLocationMarker;
  final List<GalliMarker> markers;
  final List<GalliLine> lines;
  final List<GalliCircle> circles;
  final List<GalliPolygon> polygons;
  final Widget? currentLocationWidget;
  final GalliController controller;
  final SearchClass? search;
  final ViewerClass? viewer;
  final Three60Marker three60marker;
  final List<Widget> children;
  final Function(MapController controller)? onMapLoadComplete;
  final Function(MapEvent mapEvent)? onMapUpdate;
  final Widget Function(BuildContext, List<Marker>)? markerClusterWidget;

  final Function(
    LatLng latLng,
  )? onTap;
  const GalliMap(
      {this.show360Button = true,
      Key? key,
      required this.controller,
      this.height,
      this.width,
      this.showCurrentLocation = true,
      this.currentLocationMarker,
      this.markers = const <GalliMarker>[],
      this.onTap,
      this.showSearch = true,
      this.showLocationButton = true,
      this.currentLocationWidget,
      this.lines = const <GalliLine>[],
      this.circles = const <GalliCircle>[],
      this.polygons = const <GalliPolygon>[],
      this.onMapLoadComplete,
      this.children = const <Widget>[],
      this.onMapUpdate,
      this.markerClusterWidget,
      this.search,
      this.viewer,
      this.three60marker = const Three60Marker(
        three60MarkerSize: 40,
        show360ImageOnMarkerClick: true,
        three60Widget: Three60Icon(),
        // on360MarkerTap: ,
      )})
      : super(key: key);

  @override
  State<GalliMap> createState() => _GalliMapState();
}

class Three60Icon extends StatelessWidget {
  const Three60Icon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            spreadRadius: 1,
            blurRadius: 1,
          )
        ],
        borderRadius: BorderRadius.circular(30),
        color: Colors.white,
      ),
      child: Icon(
        Icons.circle,
        color: Colors.amber,
      ),
    );
  }
}

class _GalliMapState extends State<GalliMap> with TickerProviderStateMixin {
  Position? currentLocation;
  bool showSearch = false;
  List<AutoCompleteModel> autocompleteResults = [];
  List<ImageModel> images = [];
  Timer? typingWaiter;
  bool loading = false;
  LatLng center = LatLng(27.697297, 85.329238);
  bool three60Loading = false;
  bool locationEnabled = false;
  LocationPermission? currentPermission;

  typingWait() async {
    if (search.search.text.length > 2) {
      typingWaiter =
          Timer.periodic(const Duration(milliseconds: 100), (timer) async {
        if (timer.tick == 5) {
          if (!mounted) {
            typingWaiter!.cancel();
            return;
          }
          setState(() {
            loading = true;
          });
          typingWaiter!.cancel();
          List<AutoCompleteModel> tempData = await galliMethods!.autoComplete(
              search.search.text,
              location: LatLng(
                  currentLocation!.latitude, currentLocation!.longitude));
          List<AutoCompleteModel> data = tempData.toSet().toList();
          if (data.isNotEmpty) {
            autocompleteResults = data;
          }
          if (!mounted) {
            typingWaiter!.cancel();
            return;
          }
          setState(() {
            loading = false;
          });
        }
      });
    }
  }

  locationaServicesInitiate() async {
    currentPermission = await Geolocator.checkPermission();
    locationEnabled = await Geolocator.isLocationServiceEnabled();
    if (currentPermission == LocationPermission.denied ||
        currentPermission == LocationPermission.deniedForever) {
      currentPermission = await Geolocator.requestPermission();
    }
    if ((currentPermission == LocationPermission.always ||
            currentPermission == LocationPermission.whileInUse) &&
        locationEnabled) {
      currentLocation = await galliMethods!.getCurrentLocation();
      center = currentLocation!.toLatLng();
      if (!mounted) {
        return;
      }
      setState(() {});
      galliMethods!.streamCurrentLocation().listen((event) {
        if (isFromNepal(event.toLatLng())) {
          currentLocation = event;
          if (!mounted) {
            return;
          }
          setState(() {});
        }
      });
    }
  }

  GalliMethods? galliMethods;
  late SearchClass search;

  @override
  void initState() {
    if (widget.search != null) {
      search = widget.search!;
    } else {
      search = SearchClass(
        searchWidth: 340,
        searchHeight: 40,
        onTapAutoComplete: (AutoCompleteModel model) async {
          // String location = model.name.toString();
          // var current = await galliMethods!.getCurrentLocation();
          // LatLng mylocation = LatLng(current.latitude, current.longitude);

          // // log("name $location, value  ${mylocation.toJson()}");
          // Future<FeatureModel?> result =
          //     galliMethods!.search(location, mylocation);
          //     await galliMethods.animateMapMove(, 18, this, mounted, map)
        },
      );
    }
    galliMethods = GalliMethods(widget.controller.authKey);
    locationaServicesInitiate();

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width ?? MediaQuery.of(context).size.width,
      height: widget.height ?? MediaQuery.of(context).size.height,
      child: currentLocation == null &&
              widget.controller.initialPosition == null
          ? const Center(
              child: CircularProgressIndicator(
                color: Color(0xff454545),
              ),
            )
          : FlutterMap(
              mapController: widget.controller.map,
              options: MapOptions(

                  // plugins: [
                  //   MarkerClusterPlugin(),
                  // ],

                  onMapReady: () async {
                    await Future.delayed(const Duration(milliseconds: 500));
                    if (widget.onMapLoadComplete != null) {
                      widget.onMapLoadComplete!(widget.controller.map);
                    }
                    widget.controller.map.mapEventStream.listen((event) async {
                      if (widget.onMapUpdate != null)
                        widget.onMapUpdate!(event);

                      if (!three60Loading &&
                          images.isNotEmpty &&
                          (event is MapEventMoveEnd ||
                              event is MapEventRotateEnd ||
                              event is MapEventFlingAnimationEnd)) {
                        if (!mounted) return;
                        setState(() {
                          three60Loading = true;
                        });
                        print("Getting images");
                        images = await galliMethods!
                            .get360ImagePoints(widget.controller.map);

                        if (!mounted) return;
                        setState(() {
                          three60Loading = false;
                        });
                      }
                    });
                  },
                  onPositionChanged: (pos, __) {
                    center = pos.center!;
                  },
                  onTap: (__, ___) {
                    if (widget.onTap != null) {
                      widget.onTap!(___);
                    }
                  },
                  interactiveFlags: InteractiveFlag.all,
                  center: widget.controller.initialPosition ?? center,
                  maxZoom: (widget.controller.maxZoom < 22)
                      ? widget.controller.maxZoom
                      : 22,
                  minZoom: widget.controller.minZoom,
                  zoom: widget.controller.zoom),
              children: [
                TileLayer(
                  tms: true,
                  tileProvider: CachedTileProvider(),
                  urlTemplate:
                      "https://map-init.gallimap.com/geoserver/gwc/service/tms/1.0.0/GalliMaps%3AClean@EPSG%3A3857@png/{z}/{x}/{y}.png?accessToken=${widget.controller.authKey}",
                  // "http://maps.gallimap.com/styles/light/{z}/{x}/{y}.png?accessToken=${widget.controller.authKey}",
                ),
                PolylineLayer(polylines: [
                  for (GalliLine line in widget.lines) line.toPolyline(),
                ]),
                PolygonLayer(polygons: [
                  for (GalliPolygon polygon in widget.polygons)
                    polygon.toPolygon(),
                ]),
                CircleLayer(
                  circles: [
                    for (GalliCircle circle in widget.circles)
                      circle.toCircleMarker(),
                  ],
                ),
                MarkerLayer(
                  markers: [
                    for (ImageModel image in images)
                      Marker(
                          height: widget.three60marker.three60MarkerSize,
                          point: LatLng(image.lat!, image.lng!),
                          builder: (_) => GestureDetector(
                                onTap: () {
                                  String data =
                                      encrypt("${image.folder}/${image.image}");
                                  if (widget.three60marker.on360MarkerTap !=
                                      null) {
                                    widget.three60marker.on360MarkerTap!();
                                  }
                                  if (widget.three60marker
                                      .show360ImageOnMarkerClick) {
                                    showDialog(
                                        context: context,
                                        builder: (context) {
                                          return SizedBox(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            height: MediaQuery.of(context)
                                                .size
                                                .height,
                                            child: Stack(children: [
                                              widget.viewer?.viewer == null
                                                  ? Viewer(
                                                      image: data,
                                                      accessToken: widget
                                                          .controller.authKey,
                                                    )
                                                  : widget.viewer!
                                                              .viewerPosition ==
                                                          null
                                                      ? Viewer.fromViewer(
                                                          oldViewer: widget
                                                              .viewer!.viewer!,
                                                          newIimage: data)
                                                      : Positioned(
                                                          top: widget
                                                              .viewer!
                                                              .viewerPosition!
                                                              .dx,
                                                          left: widget
                                                              .viewer!
                                                              .viewerPosition!
                                                              .dy,
                                                          child: Viewer.fromViewer(
                                                              oldViewer: widget
                                                                  .viewer!
                                                                  .viewer!,
                                                              newIimage: data),
                                                        )
                                            ]),
                                          );
                                        });
                                  }
                                },
                                child: Container(
                                  width: widget.three60marker.three60MarkerSize,
                                  height:
                                      widget.three60marker.three60MarkerSize,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                          width: 2, color: Colors.orange)),
                                ),
                              )),
                  ],
                ),
                MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                        builder: widget.markerClusterWidget ??
                            (context, marker) {
                              return Container(
                                width: 24,
                                height: 24,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        width: 2, color: Colors.blue)),
                                child: Center(
                                  child: Text(marker.length.toString()),
                                ),
                              );
                            },
                        markers: [
                      for (GalliMarker marker in widget.markers)
                        marker.toMarker(),
                    ])),
                MarkerLayer(markers: [
                  if (widget.showCurrentLocation && currentLocation != null)
                    userLocation(
                        latLng: currentLocation!.toLatLng(),
                        marker: widget.currentLocationMarker),
                ]),
              ],
              nonRotatedChildren: [
                if (widget.children.isNotEmpty)
                  for (Widget child in widget.children) child,
                if (showSearch)
                  Container(
                    width: widget.width ?? MediaQuery.of(context).size.width,
                    height: widget.height ?? MediaQuery.of(context).size.height,
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 64,
                            ),
                            for (AutoCompleteModel autoCompleteData
                                in autocompleteResults)
                              GestureDetector(
                                onTap: () async {
                                  if (search.onTapAutoComplete != null) {
                                    await search
                                        .onTapAutoComplete!(autoCompleteData);
                                  }
                                  showSearch = false;
                                  autocompleteResults = [];
                                  search.search.text = autoCompleteData.name!;
                                  if (!mounted) {
                                    return;
                                  }
                                  setState(() {});
                                  FocusManager.instance.primaryFocus?.unfocus();
                                },
                                child: Container(
                                  margin:
                                      const EdgeInsets.fromLTRB(16, 8, 16, 0),
                                  decoration: BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                              color: search.iconColor ??
                                                  Colors.orange))),
                                  child: ListTile(
                                      horizontalTitleGap: 0,
                                      minLeadingWidth: 48,
                                      leading: Icon(
                                        Icons.location_on,
                                        color:
                                            search.iconColor ?? Colors.orange,
                                      ),
                                      title: Text(
                                        autoCompleteData.name ?? "null",
                                        style: const TextStyle(
                                            fontSize: 14,
                                            color: Color(0xff454545)),
                                      ),
                                      trailing: Text(
                                        "  ${(autoCompleteData.distance ?? 0.0).toStringAsFixed(2)} KM",
                                        style: TextStyle(
                                            color: Color(0xff454545),
                                            fontWeight: FontWeight.w500),
                                      )),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                if (widget.showSearch)
                  Positioned(
                    top: 16,
                    left: MediaQuery.of(context).size.width * 0.05,
                    child: Material(
                      clipBehavior: Clip.hardEdge,
                      borderRadius: BorderRadius.circular(20),
                      elevation: 4,
                      child: SizedBox(
                        height: search.searchHeight ?? 40,
                        width: search.searchWidth ??
                            MediaQuery.of(context).size.width * 0.9,
                        child: TextFormField(
                          controller: search.search,
                          onTap: () {
                            if (!mounted) {
                              return;
                            }
                            setState(() {
                              showSearch = true;
                            });
                          },
                          onChanged: (val) async {
                            if (val != "") {
                              if (typingWaiter != null) {
                                typingWaiter!.cancel();
                              }
                              typingWait();
                            } else {
                              if (!mounted) {
                                return;
                              }
                              setState(() {
                                autocompleteResults = [];
                              });
                            }
                          },
                          decoration: InputDecoration(
                              hintText: search.searchHint,
                              prefixIcon: Padding(
                                padding: EdgeInsets.all(10.0),
                                child: search.suffixWidget ??
                                    Icon(
                                      Icons.search,
                                      color: search.iconColor ?? Colors.orange,
                                    ),
                              ),
                              suffixIcon: search.search.text == ""
                                  ? !showSearch
                                      ? const SizedBox()
                                      : InkWell(
                                          onTap: () {
                                            showSearch = false;
                                            autocompleteResults = [];
                                            if (!mounted) {
                                              return;
                                            }
                                            setState(() {});
                                            FocusManager.instance.primaryFocus
                                                ?.unfocus();
                                          },
                                          child: Card(
                                            elevation: 4,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(16)),
                                            child: SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: search.closeWidget ??
                                                  Icon(
                                                    Icons.close,
                                                    color: search.iconColor ??
                                                        Colors.orange,
                                                    size: 18,
                                                  ),
                                            ),
                                          ),
                                        )
                                  : InkWell(
                                      onTap: () {
                                        search.search.text = "";
                                        if (!mounted) {
                                          return;
                                        }
                                        setState(() {});
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.all(10.0),
                                        child: search.backWidget ??
                                            Icon(
                                              Icons.arrow_back,
                                              color: search.iconColor ??
                                                  Colors.orange,
                                            ),
                                      ),
                                    ),
                              filled: true,
                              fillColor: Colors.white,
                              focusedBorder: InputBorder.none,
                              enabledBorder: InputBorder.none,
                              contentPadding: const EdgeInsets.only(top: 8)),
                          cursorColor:
                              search.cursorColor ?? const Color(0xff454545),
                          cursorHeight: search.cursorHeight ?? 12,
                          style: search.textStyle ??
                              const TextStyle(
                                fontSize: 14,
                                color: Color(0xff454545),
                                decoration: TextDecoration.none,
                              ),
                        ),
                      ),
                    ),
                  ),
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Column(
                    children: [
                      if (widget.show360Button)
                        GestureDetector(
                          onTap: () async {
                            if (!three60Loading) {
                              if (images.isEmpty) {
                                if (!mounted) {
                                  return;
                                }
                                setState(() {
                                  three60Loading = true;
                                });
                                images = await galliMethods!
                                    .get360ImagePoints(widget.controller.map);
                                if (!mounted) {
                                  return;
                                }
                                setState(() {
                                  three60Loading = false;
                                });
                              } else {
                                images = [];
                              }
                              if (!mounted) {
                                return;
                              }
                              setState(() {});
                            }
                          },
                          child: widget.three60marker.three60Widget ??
                              Card(
                                  elevation: 4,
                                  color: images.isEmpty
                                      ? Colors.white
                                      : Colors.orange,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  child: SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: three60Loading
                                        ? CircularProgressIndicator()
                                        : Stack(children: [
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10),
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Icon(
                                                      Icons.threesixty,
                                                      size: 25,
                                                      color: images.isEmpty
                                                          ? Colors.orange
                                                          : Colors.white,
                                                    ))),
                                            Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 12),
                                                child: Align(
                                                    alignment: Alignment.center,
                                                    child: Text(
                                                      "360",
                                                      style: TextStyle(
                                                          color: images.isEmpty
                                                              ? Colors.orange
                                                              : Colors.white,
                                                          fontSize: 8,
                                                          fontWeight:
                                                              FontWeight.w800),
                                                    ))),
                                          ]),
                                  )),
                        ),
                      if (widget.showLocationButton && locationEnabled)
                        GestureDetector(
                          onTap: () {
                            if (widget.controller.map.rotation != 0.0) {
                              galliMethods!.rotateMap(
                                  this, mounted, widget.controller.map);
                            } else if (widget.controller.map.center !=
                                currentLocation!.toLatLng()) {
                              galliMethods!.animateMapMove(
                                  currentLocation!.toLatLng(),
                                  widget.controller.map.zoom,
                                  this,
                                  mounted,
                                  widget.controller.map);
                            } else if (widget.controller.map.zoom != 16) {
                              galliMethods!.animateMapMove(
                                  currentLocation!.toLatLng(),
                                  16,
                                  this,
                                  mounted,
                                  widget.controller.map);
                            }
                          },
                          child: widget.currentLocationWidget ??
                              Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(24)),
                                  child: SizedBox(
                                    width: 48,
                                    height: 48,
                                    child: Center(
                                      child: Icon(
                                        Icons.location_searching_outlined,
                                        color:
                                            search.iconColor ?? Colors.orange,
                                      ),
                                    ),
                                  )),
                        ),
                    ],
                  ),
                )
              ],
            ),
    );
  }
}
