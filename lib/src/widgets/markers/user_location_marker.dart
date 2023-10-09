import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'dart:math' as math;

Marker userLocation({required LatLng latLng, Widget? marker}) => Marker(
    point: latLng,
    height: 48,
    width: 48,
    builder: (_) => StreamBuilder<CompassEvent>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          double? direction =
              snapshot.data != null ? snapshot.data!.heading ?? 0 : 0;
          return Transform.rotate(
            angle: (direction * (math.pi / 180)),
            child: Stack(children: [
              const Positioned(
                  top: 0,
                  left: 12,
                  child: SizedBox(
                      width: 20,
                      height: 20,
                      child: Icon(
                        Icons.keyboard_arrow_up_outlined,
                        color: Colors.black,
                        // weight: 4,
                        // shadows: [
                        //   BoxShadow(
                        //       blurRadius: 4,
                        //       color: Colors.black38,
                        //       offset: Offset(
                        //         2,
                        //         2,
                        //       ),
                        //       spreadRadius: 2)
                        // ],
                      ))),
              Center(
                child: marker ??
                    Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 4,
                                  color: Colors.black38,
                                  offset: Offset(
                                    2,
                                    2,
                                  ),
                                  spreadRadius: 2)
                            ],
                            color: Colors.orange,
                            shape: BoxShape.circle,
                            border: Border.all(width: 2, color: Colors.black))),
              ),
            ]),
          );
        }));
