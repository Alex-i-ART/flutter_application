import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits/history_cubit.dart';
import '../widgets/day_length_calculator.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController _celsiusController = TextEditingController();
  final TextEditingController _fahrenheitController = TextEditingController();
  final TextEditingController _kmhController = TextEditingController();
  final TextEditingController _msController = TextEditingController();
  final TextEditingController _hPaController = TextEditingController();
  final TextEditingController _mmhgController = TextEditingController();

  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Калькулятор'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Конвертер температур
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Конвертер температуры:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _celsiusController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '°C',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final celsius = double.tryParse(value);
                                if (celsius != null) {
                                  final fahrenheit = (celsius * 9/5) + 32;
                                  _fahrenheitController.text = fahrenheit.toStringAsFixed(2);
                                  _saveCalculation('$celsius°C = ${fahrenheit.toStringAsFixed(2)}°F');
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('='),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _fahrenheitController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: '°F',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final fahrenheit = double.tryParse(value);
                                if (fahrenheit != null) {
                                  final celsius = (fahrenheit - 32) * 5/9;
                                  _celsiusController.text = celsius.toStringAsFixed(2);
                                  _saveCalculation('$fahrenheit°F = ${celsius.toStringAsFixed(2)}°C');
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Конвертер скорости ветра
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Конвертер скорости ветра:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _kmhController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'км/ч',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final kmh = double.tryParse(value);
                                if (kmh != null) {
                                  final ms = kmh / 3.6;
                                  _msController.text = ms.toStringAsFixed(2);
                                  _saveCalculation('$kmh км/ч = ${ms.toStringAsFixed(2)} м/с');
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('='),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _msController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'м/с',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final ms = double.tryParse(value);
                                if (ms != null) {
                                  final kmh = ms * 3.6;
                                  _kmhController.text = kmh.toStringAsFixed(2);
                                  _saveCalculation('$ms м/с = ${kmh.toStringAsFixed(2)} км/ч');
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Конвертер давления
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Конвертер давления:',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _hPaController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'гПа',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final hPa = double.tryParse(value);
                                if (hPa != null) {
                                  final mmhg = hPa * 0.75006;
                                  _mmhgController.text = mmhg.toStringAsFixed(2);
                                  _saveCalculation('$hPa гПа = ${mmhg.toStringAsFixed(2)} мм рт.ст.');
                                }
                              }
                            },
                          ),
                        ),
                        const SizedBox(width: 10),
                        const Text('='),
                        const SizedBox(width: 10),
                        Expanded(
                          child: TextField(
                            controller: _mmhgController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'мм рт.ст.',
                              border: OutlineInputBorder(),
                            ),
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                final mmhg = double.tryParse(value);
                                if (mmhg != null) {
                                  final hPa = mmhg / 0.75006;
                                  _hPaController.text = hPa.toStringAsFixed(2);
                                  _saveCalculation('$mmhg мм рт.ст. = ${hPa.toStringAsFixed(2)} гПа');
                                }
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Калькулятор продолжительности дня
            DayLengthCalculator(
              onCalculate: (result) {
                setState(() {
                  _result = result;
                  _saveCalculation(result);
                });
              },
            ),

            const SizedBox(height: 20),

            if (_result.isNotEmpty)
              Card(
                color: Colors.blue[50],
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    'Результат: $_result',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),

            const SizedBox(height: 20),

            // История расчетов
            BlocBuilder<HistoryCubit, HistoryState>(
              builder: (context, historyState) {
                if (historyState is HistoryLoaded) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'История расчетов:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      
                      if (historyState.calculationsHistory.isNotEmpty)
                        ...historyState.calculationsHistory.map((calculation) => 
                          ListTile(
                            leading: const Icon(Icons.calculate),
                            title: Text(calculation),
                            dense: true,
                          ),
                        ).toList(),
                      
                      if (historyState.calculationsHistory.isEmpty)
                        const Text('История расчетов пуста'),
                    ],
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ],
        ),
      ),
    );
  }

  void _saveCalculation(String calculation) {
    context.read<HistoryCubit>().addCalculationToHistory(calculation);
  }

  @override
  void dispose() {
    _celsiusController.dispose();
    _fahrenheitController.dispose();
    _kmhController.dispose();
    _msController.dispose();
    _hPaController.dispose();
    _mmhgController.dispose();
    super.dispose();
  }
}