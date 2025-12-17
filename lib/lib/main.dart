import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:camera/camera.dart';

import 'models/weather_data.dart';
import 'models/day_data.dart';
import 'cubits/weather_cubit.dart';
import 'cubits/history_cubit.dart';
import 'screens/home_screen.dart';
import 'screens/developer_screen.dart';
import 'screens/calculator_screen.dart';
import 'screens/camera_screen.dart';
import 'services/hive_service.dart';

List<CameraDescription> cameras = [];

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. СНАЧАЛА регистрируем адаптеры
  Hive.registerAdapter(WeatherDataAdapter());
  Hive.registerAdapter(DayDataAdapter());
  
  // 2. ПОТОМ инициализируем Hive
  await HiveService.init();
  
  // 3. Получение доступных камер
  try {
    cameras = await availableCameras();
  } catch (e) {
    print("Ошибка при получении камер: $e");
  }
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WeatherCubit(),
        ),
        BlocProvider(
          create: (context) => HistoryCubit(),
        ),
      ],
      child: MaterialApp(
        title: 'Weather & Day Calculator',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => HomeScreen(cameras: cameras),
          '/developer': (context) => DeveloperScreen(),
          '/calculator': (context) => CalculatorScreen(),
          '/camera': (context) => CameraScreen(cameras: cameras),
        },
      ),
    );
  }
}