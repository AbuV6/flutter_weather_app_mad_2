import 'dart:convert';
import 'package:http/http.dart' as http;

class WeatherService {
  static Future<Map<String, dynamic>?> fetchWeather(String cityName) async {
    final url = Uri.parse('https://wttr.in/${Uri.encodeComponent(cityName)}?format=j1');
    try {
      final response = await http.get(
        url,
        headers: {
          'User-Agent': 'Mozilla/5.0 (compatible; FlutterApp/1.0; +https://example.com)'
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['current_condition'] != null && data['current_condition'].isNotEmpty) {
          return data;
        }
      }
    } catch (_) {}
    return null;
  }
}
