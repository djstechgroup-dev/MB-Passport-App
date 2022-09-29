import 'dart:convert';
import 'package:passportapp/model/weather.dart';
import 'package:http/http.dart' as http;

class WeatherService{
  Future<Weather> getData(String q) async {
    try {
      final queryParameters = {
        'key': 'f9941bbce7d24410af993022222707',
        'q': q,
      };
      final uri = Uri.http('api.weatherapi.com', '/v1/current.json', queryParameters);
      final response = await http.get(uri);
      if(response.statusCode == 200) {
        return Weather.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed with code: ${response.statusCode}');
      }
    } catch(e) {
      rethrow;
    }
  }
}