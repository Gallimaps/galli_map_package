import 'dart:developer';
import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:galli_map/galli_map.dart';

import '../key_constant.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  // var message = "";
  // LatLng mylocation = LatLng(27.677121, 85.322321);
  LatLng mylocation = LatLng(27.671712, 85.312208);
  final GalliMethods galliMethods = GalliMethods(KeyConstant.key);
  LatLng minLatlng = LatLng(27.610126, 85.253078);
  LatLng maxLatlng = LatLng(27.784424, 85.399647);
  int testRunCount = 100;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                var message = await galliMethods.getCurrentLocation();
                Get.showSnackbar(
                  GetSnackBar(
                    duration: Duration(seconds: 2),
                    title: "Location",
                    message: "${message}",
                  ),
                );
              },
              child: const Text("Current Location"),
            ),
            ElevatedButton(
              onPressed: () async {
                for (int i = 0; i < testRunCount; i++) {
                  double lat =
                      (Random().nextInt(27784424 - 27610126) + 27610126) /
                          1000000;
                  double lng =
                      (Random().nextInt(85399647 - 85253078) + 85253078) /
                          1000000;
                  LatLng testLocation = LatLng(lat, lng);
                  print("Testing with location data $testLocation");
                  await galliMethods.reverse(testLocation);
                }
                // await galliMethods.reverse(mylocation);
                // log("Message ${message!.toJson()}");
                // Get.showSnackbar(GetSnackBar(
                //   duration: Duration(seconds: 10),
                //   title: "Reverse",
                //   message: "${message!.toJson()}",
                // ));
              },
              child: const Text("Reverse"),
            ),
            ElevatedButton(
              onPressed: () async {
                var message = await galliMethods.search("well", mylocation);
                // log("Message ${message!.toJson()}");
                Get.showSnackbar(GetSnackBar(
                  duration: Duration(seconds: 4),
                  title: "Search \"well\"",
                  message: "${message!.toJson()}",
                ));
              },
              child: const Text("Search"),
            ),
            ElevatedButton(
              onPressed: () async {
                var xyz = galliMethods.reverse(mylocation);

                print(" abc ${xyz}");
              },
              child: const Text("Route"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("Auto Complete"),
            ),
            ElevatedButton(
              onPressed: () {},
              child: const Text("360 points"),
            ),
          ],
        ),
      )),
    );
  }
}
