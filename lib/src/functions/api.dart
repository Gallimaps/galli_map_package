import 'dart:developer';

import 'package:galli_map/src/static/url.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';

class GalliApi {
  final String baseUrl;

  GalliApi({required this.baseUrl});

  Future get(String url, String accessToken) async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    var packageName = packageInfo.packageName;
    var response = await http.get(
      Uri.parse("$baseUrl$url"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'User-agent': packageName,
      },
    ).timeout(
      const Duration(seconds: 8),
      onTimeout: () {
        return http.Response(
            'Error', 408); // Request Timeout response status code
      },
    );
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }
}

final GalliApi imageApi = GalliApi(baseUrl: galliUrl.imageUrl);

final GalliApi geoApi = GalliApi(baseUrl: galliUrl.geoUrl);
