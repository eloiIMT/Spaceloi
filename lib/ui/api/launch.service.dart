import 'dart:convert';

import 'package:spaceloi/data/models/launch.model.dart';
import 'package:http/http.dart' as http;
import 'package:spaceloi/data/models/rocket.model.dart';

class LaunchService {

  static const String baseUrl = 'https://api.spacexdata.com/v4';

  static Future<List<Launch>> getLaunches() async {
    final response = await http.get(Uri.parse('$baseUrl/launches'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load launches');
    }
    final List<dynamic> launchesJson = json.decode(response.body);
    return launchesJson.map((json) => Launch.fromJson(json)).toList();
  }

  static Future<Rocket> getRocketById(String id) async {
    final response = await http.get(Uri.parse('$baseUrl/rockets/$id'));
    print("$baseUrl/rockets/$id");
    if (response.statusCode != 200) {
      throw Exception('Failed to load rocket');
    }
    final Map<String, dynamic> rocketJson = json.decode(response.body);
    return Rocket.fromJson(rocketJson);
  }
}