import 'dart:developer';
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
  LatLng mylocation = LatLng(27.6617019, 85.3256189);
  final GalliMethods galliMethods = GalliMethods(KeyConstant.key);

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
                var message = await galliMethods.reverse(mylocation);
                // log("Message ${message!.toJson()}");
                Get.showSnackbar(GetSnackBar(
                  duration: Duration(seconds: 10),
                  title: "Reverse",
                  message: "${message!.toJson()}",
                ));
              },
              child: const Text("Reverse"),
            ),
            ElevatedButton(
              onPressed: () async {
                var message = await galliMethods.search("well", mylocation);
                log("Message ${message!.toJson()}");
                Get.showSnackbar(GetSnackBar(
                  duration: Duration(seconds: 4),
                  title: "Search \"well\"",
                  message: "${message!.toJson()}",
                ));
              },
              child: const Text("Search"),
            ),
            ElevatedButton(
              onPressed: () {},
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
