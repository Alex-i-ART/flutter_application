import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/weather_data.dart';
import '../models/day_data.dart';
import '../services/hive_service.dart';

part 'history_state.dart';

class HistoryCubit extends Cubit<HistoryState> {
  HistoryCubit() : super(HistoryInitial()) {
    loadHistory();
  }

  Future<void> loadHistory() async {
    emit(HistoryLoading());
    
    try {
      final weatherHistory = await HiveService.getWeatherHistory();
      final dayHistory = await HiveService.getDayHistory();
      final calculationsHistory = await HiveService.getCalculationsHistory();
      
      emit(HistoryLoaded(
        weatherHistory: weatherHistory,
        dayHistory: dayHistory,
        calculationsHistory: calculationsHistory,
      ));
    } catch (e) {
      emit(HistoryError(e.toString()));
    }
  }

  Future<void> addWeatherToHistory(WeatherData weather) async {
    await HiveService.saveWeather(weather);
    loadHistory();
  }

  Future<void> addDayToHistory(DayData dayData) async {
    await HiveService.saveDayData(dayData);
    loadHistory();
  }

  Future<void> addCalculationToHistory(String calculation) async {
    await HiveService.saveCalculation(calculation);
    loadHistory();
  }

  Future<void> clearHistory() async {
    await HiveService.clearAllHistory();
    loadHistory();
  }
}