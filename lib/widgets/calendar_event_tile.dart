import 'package:flutter/material.dart';
import '../models/event.dart';

class CalendarEventTile extends StatelessWidget {
  final Event event;

  CalendarEventTile({required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Text(event.title),
      ),
    );
  }
}
