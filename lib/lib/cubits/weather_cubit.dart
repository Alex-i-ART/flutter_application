import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../models/weather_data.dart';
import '../services/weather_service.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherService _weatherService = WeatherService();

  WeatherCubit() : super(WeatherInitial());

  Future<void> fetchWeatherByCity(String city) async {
    emit(WeatherLoading());
    
    try {
      final weather = await _weatherService.getWeatherByCity(city);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }

  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    emit(WeatherLoading());
    
    try {
      final weather = await _weatherService.getWeatherByLocation(lat, lon);
      emit(WeatherLoaded(weather));
    } catch (e) {
      emit(WeatherError(e.toString()));
    }
  }
}