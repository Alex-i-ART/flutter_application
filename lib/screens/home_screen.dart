import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:camera/camera.dart';

import '../cubits/weather_cubit.dart';
import '../cubits/history_cubit.dart';
import '../services/sunrise_service.dart';
import '../widgets/weather_card.dart';
import '../widgets/history_item.dart';

class HomeScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const HomeScreen({Key? key, required this.cameras}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _cityController = TextEditingController();
  final SunriseService _sunriseService = SunriseService();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
  try {
      _currentPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
          distanceFilter: 100,
        ),
      );
    } catch (e) {
    print("Ошибка получения местоположения: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Погода и Длительность дня'),
        actions: [
          IconButton(
            icon: const Icon(Icons.camera_alt),
            onPressed: () {
              Navigator.pushNamed(context, '/camera');
            },
          ),
          IconButton(
            icon: const Icon(Icons.calculate),
            onPressed: () {
              Navigator.pushNamed(context, '/calculator');
            },
          ),
          IconButton(
            icon: const Icon(Icons.info),
            onPressed: () {
              Navigator.pushNamed(context, '/developer');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Поиск по городу
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _cityController,
                    decoration: const InputDecoration(
                      labelText: 'Введите город',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      context.read<WeatherCubit>().fetchWeatherByCity(_cityController.text);
                    }
                  },
                  child: const Text('Поиск'),
                ),
              ],
            ),
            
            const SizedBox(height: 20),
            
            // Кнопка для погоды по местоположению
            if (_currentPosition != null)
              ElevatedButton(
                onPressed: () {
                  context.read<WeatherCubit>().fetchWeatherByLocation(
                    _currentPosition!.latitude,
                    _currentPosition!.longitude,
                  );
                },
                child: const Text('Погода по моему местоположению'),
              ),
            
            const SizedBox(height: 20),
            
            // Отображение текущей погоды с использованием BlocListener
            BlocConsumer<WeatherCubit, WeatherState>(
              listener: (context, state) {
                if (state is WeatherLoaded) {
                  // Сохраняем в историю только когда данные загружены
                  context.read<HistoryCubit>().addWeatherToHistory(state.weather);
                  
                  // Получаем данные о восходе/закате
                  if (_currentPosition != null) {
                    _getSunriseSunsetData(state.weather.city);
                  }
                }
              },
              builder: (context, state) {
                if (state is WeatherLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is WeatherLoaded) {
                  return WeatherCard(weather: state.weather);
                } else if (state is WeatherError) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Ошибка: ${state.message}',
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                  );
                }
                return Container();
              },
            ),
            
            const SizedBox(height: 30),
            
            // История запросов
            BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, historyState) {
                if (historyState is HistoryLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'История запросов:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      
                      if (historyState.weatherHistory.isNotEmpty)
                        ...historyState.weatherHistory.map((weather) => 
                          HistoryItem(
                            title: weather.city,
                            subtitle: '${weather.temperature.toStringAsFixed(1)}°C - ${weather.description}',
                            date: weather.timestamp,
                          ),
                        ).toList(),
                      
                      if (historyState.dayHistory.isNotEmpty)
                        ...historyState.dayHistory.map((day) => 
                          HistoryItem(
                            title: '${day.city} - Длительность дня',
                            subtitle: '${day.getDayLengthFormatted()} (${day.sunrise.hour}:${day.sunrise.minute} - ${day.sunset.hour}:${day.sunset.minute})',
                            date: day.date,
                          ),
                        ).toList(),
                      
                      if (historyState.weatherHistory.isEmpty && historyState.dayHistory.isEmpty)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: Text('История пуста'),
                        ),
                      
                      const SizedBox(height: 10),
                      if (historyState.weatherHistory.isNotEmpty || historyState.dayHistory.isNotEmpty)
                        ElevatedButton(
                          onPressed: () {
                            context.read<HistoryCubit>().clearHistory();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: const Text('Очистить историю'),
                        ),
                    ],
                  );
                } else if (historyState is HistoryError) {
                  return Text('Ошибка загрузки истории: ${historyState.message}');
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _getSunriseSunsetData(String city) async {
    if (_currentPosition != null) {
      try {
        final dayData = await _sunriseService.getSunriseSunset(
          _currentPosition!.latitude,
          _currentPosition!.longitude,
          city,
        );
        context.read<HistoryCubit>().addDayToHistory(dayData);
      } catch (e) {
        print("Ошибка получения данных о восходе/закате: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ошибка получения данных о восходе/закате: $e'),
            duration: const Duration(seconds: 3),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }
}