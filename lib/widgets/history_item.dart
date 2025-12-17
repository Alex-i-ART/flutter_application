import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime date;

  const HistoryItem({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.date,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.history),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          DateFormat('HH:mm').format(date),
          style: const TextStyle(fontSize: 12),
        ),
        dense: true,
      ),
    );
  }
}