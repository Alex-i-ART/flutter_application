import 'package:hive/hive.dart';

part 'day_data.g.dart';

@HiveType(typeId: 1)
class DayData {
  @HiveField(0)
  final DateTime date;
  
  @HiveField(1)
  final String city;
  
  @HiveField(2)
  final DateTime sunrise;
  
  @HiveField(3)
  final DateTime sunset;
  
  @HiveField(4)
  final Duration dayLength;

  DayData({
    required this.date,
    required this.city,
    required this.sunrise,
    required this.sunset,
  }) : dayLength = sunset.difference(sunrise);

  factory DayData.fromJson(Map<String, dynamic> json, String city) {
    final results = json['results'] as Map<String, dynamic>?;
    
    if (results == null) {
      throw Exception('Отсутствуют данные о восходе/закате');
    }
    
    final sunriseStr = results['sunrise'] as String?;
    final sunsetStr = results['sunset'] as String?;
    
    if (sunriseStr == null || sunsetStr == null) {
      throw Exception('Неполные данные о времени восхода/заката');
    }
    
    try {
      return DayData(
        date: DateTime.now(),
        city: city,
        sunrise: DateTime.parse(sunriseStr).toLocal(),
        sunset: DateTime.parse(sunsetStr).toLocal(),
      );
    } catch (e) {
      throw Exception('Ошибка парсинга времени: $e');
    }
  }
  
  String getDayLengthFormatted() {
    final hours = dayLength.inHours;
    final minutes = dayLength.inMinutes.remainder(60);
    return '${hours}ч ${minutes}м';
  }
}