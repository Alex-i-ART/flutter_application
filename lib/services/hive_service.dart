import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import '../models/weather_data.dart';
import '../models/day_data.dart';

class HiveService {
  static const String weatherBoxName = 'weather_history';
  static const String dayBoxName = 'day_history';
  static const String calculationsBoxName = 'calculations_history';

  static Future<void> init() async {
    final appDocumentDirectory = await path_provider.getApplicationDocumentsDirectory();
    
    // Используем initFlutter вместо init для Flutter-приложений
    await Hive.initFlutter(appDocumentDirectory.path);
    
    // Открываем боксы
    await Hive.openBox<WeatherData>(weatherBoxName);
    await Hive.openBox<DayData>(dayBoxName);
    await Hive.openBox<String>(calculationsBoxName);
  }

  static Future<void> saveWeather(WeatherData weather) async {
    final box = Hive.box<WeatherData>(weatherBoxName);
    final key = '${weather.city}_${weather.timestamp.millisecondsSinceEpoch}';
    await box.put(key, weather);
  }

  static Future<List<WeatherData>> getWeatherHistory() async {
    final box = Hive.box<WeatherData>(weatherBoxName);
    return box.values.toList().reversed.toList();
  }

  static Future<void> saveDayData(DayData dayData) async {
    final box = Hive.box<DayData>(dayBoxName);
    final key = '${dayData.city}_${dayData.date.millisecondsSinceEpoch}';
    await box.put(key, dayData);
  }

  static Future<List<DayData>> getDayHistory() async {
    final box = Hive.box<DayData>(dayBoxName);
    return box.values.toList().reversed.toList();
  }

  static Future<void> saveCalculation(String calculation) async {
    final box = Hive.box<String>(calculationsBoxName);
    final key = DateTime.now().millisecondsSinceEpoch.toString();
    await box.put(key, calculation);
  }

  static Future<List<String>> getCalculationsHistory() async {
    final box = Hive.box<String>(calculationsBoxName);
    return box.values.toList().reversed.toList();
  }

  static Future<void> clearAllHistory() async {
    await Hive.box<WeatherData>(weatherBoxName).clear();
    await Hive.box<DayData>(dayBoxName).clear();
    await Hive.box<String>(calculationsBoxName).clear();
  }
}