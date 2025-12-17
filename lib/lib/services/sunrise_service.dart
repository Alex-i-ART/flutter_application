import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/day_data.dart';

class SunriseService {
  static const String _baseUrl = 'https://api.sunrise-sunset.org/json';

  Future<DayData> getSunriseSunset(double lat, double lon, String city) async {
    final response = await http.get(
      Uri.parse('$_baseUrl?lat=$lat&lng=$lon&formatted=0'),
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return DayData.fromJson(jsonData, city);
    } else {
      throw Exception('Не удалось получить данные о восходе/закате');
    }
  }
}