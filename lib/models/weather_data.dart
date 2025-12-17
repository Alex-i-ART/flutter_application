import 'package:hive/hive.dart';

part 'weather_data.g.dart';

@HiveType(typeId: 0)
class WeatherData {
  @HiveField(0)
  final String city;
  
  @HiveField(1)
  final double temperature;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final double humidity;
  
  @HiveField(4)
  final double windSpeed;
  
  @HiveField(5)
  final DateTime timestamp;

  WeatherData({
    required this.city,
    required this.temperature,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final main = json['main'] as Map<String, dynamic>?;
    final weatherList = json['weather'] as List<dynamic>?;
    final wind = json['wind'] as Map<String, dynamic>?;
    
    if (main == null) {
      throw Exception('Отсутствуют основные данные о погоде');
    }
    
    if (weatherList == null || weatherList.isEmpty) {
      throw Exception('Отсутствуют данные о состоянии погоды');
    }
    
    final weather = weatherList[0] as Map<String, dynamic>?;
    
    return WeatherData(
      city: json['name'] as String? ?? 'Неизвестный город',
      temperature: ((main['temp'] as num? ?? 0) - 273.15).toDouble(),
      description: weather?['description'] as String? ?? 'Нет данных',
      humidity: (main['humidity'] as num? ?? 0).toDouble(),
      windSpeed: (wind?['speed'] as num? ?? 0).toDouble(),
    );
  }
}