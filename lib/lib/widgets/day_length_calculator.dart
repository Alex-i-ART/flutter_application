import 'package:flutter/material.dart';

class DayLengthCalculator extends StatefulWidget {
  final Function(String) onCalculate;

  const DayLengthCalculator({Key? key, required this.onCalculate}) : super(key: key);

  @override
  _DayLengthCalculatorState createState() => _DayLengthCalculatorState();
}

class _DayLengthCalculatorState extends State<DayLengthCalculator> {
  TimeOfDay _sunriseTime = TimeOfDay(hour: 6, minute: 0);
  TimeOfDay _sunsetTime = TimeOfDay(hour: 18, minute: 0);
  String _result = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Калькулятор продолжительности дня:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: ListTile(
                    title: const Text('Время восхода'),
                    subtitle: Text(_formatTime(_sunriseTime)),
                    onTap: () => _selectTime(context, true),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: const Text('Время заката'),
                    subtitle: Text(_formatTime(_sunsetTime)),
                    onTap: () => _selectTime(context, false),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _calculateDayLength,
              child: const Text('Рассчитать длительность дня'),
            ),
            if (_result.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectTime(BuildContext context, bool isSunrise) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isSunrise ? _sunriseTime : _sunsetTime,
    );
    
    if (picked != null) {
      setState(() {
        if (isSunrise) {
          _sunriseTime = picked;
        } else {
          _sunsetTime = picked;
        }
      });
    }
  }

  void _calculateDayLength() {
    final now = DateTime.now();
    final sunriseDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _sunriseTime.hour,
      _sunriseTime.minute,
    );
    final sunsetDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _sunsetTime.hour,
      _sunsetTime.minute,
    );
    
    if (sunsetDateTime.isBefore(sunriseDateTime)) {
      widget.onCalculate('Ошибка: Закат не может быть раньше восхода');
      return;
    }
    
    final dayLength = sunsetDateTime.difference(sunriseDateTime);
    final hours = dayLength.inHours;
    final minutes = dayLength.inMinutes.remainder(60);
    
    final result = 'Длительность дня: ${hours}ч ${minutes}м';
    setState(() {
      _result = result;
    });
    
    widget.onCalculate(result);
  }

  String _formatTime(TimeOfDay time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}