import 'package:galli_map/src/static/url.dart';
import 'package:http/http.dart' as http;

class GalliApi {
  final String baseUrl;
  GalliApi({required this.baseUrl});

  Future get(String url, String accessToken) async {
    var response = await http.get(
      Uri.parse("$baseUrl$url"),
      headers: <String, String>{
        'Accept': 'application/json',
        'Content-Type': 'application/json; charset=UTF-8',
        'Referer': "gallimaps.com",
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
