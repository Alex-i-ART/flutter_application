import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather_data.dart';

class WeatherService {
  static const String _apiKey = '1da0ba5be8023d7ed75d6dc77276b42d';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<WeatherData> getWeatherByCity(String city) async {
    // Проверка API ключа
    if (_apiKey == 'YOUR_OPENWEATHER_API_KEY_HERE') {
      throw Exception('Необходимо указать реальный API ключ OpenWeatherMap');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/weather?q=$city&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else if (response.statusCode == 404) {
      throw Exception('Город не найден');
    } else if (response.statusCode == 401) {
      throw Exception('Неверный API ключ');
    } else {
      throw Exception('Не удалось получить данные о погоде. Код ошибки: ${response.statusCode}');
    }
  }

  Future<WeatherData> getWeatherByLocation(double lat, double lon) async {
    // Проверка API ключа
    if (_apiKey == 'YOUR_OPENWEATHER_API_KEY_HERE') {
      throw Exception('Необходимо указать реальный API ключ OpenWeatherMap');
    }

    final response = await http.get(
      Uri.parse('$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey'),
    );

    if (response.statusCode == 200) {
      return WeatherData.fromJson(json.decode(response.body));
    } else if (response.statusCode == 401) {
      throw Exception('Неверный API ключ');
    } else {
      throw Exception('Не удалось получить данные о погоде. Код ошибки: ${response.statusCode}');
    }
  }
}