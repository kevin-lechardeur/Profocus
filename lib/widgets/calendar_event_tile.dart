import 'package:flutter/material.dart';
import '../controllers/calendar_controller.dart';
import '../models/event.dart';

class CalendarEventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete;
  final VoidCallback onToggleCompletion;
  final CalendarController calendarController;
  CalendarEventTile({
    required this.event,
    required this.onDelete,
    required this.onToggleCompletion,
    required this.calendarController,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Text(
          calendarController.getTitle(event),
          style: TextStyle(
            decoration: calendarController.isEventFinished(event) ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                calendarController.isEventFinished(event) ?
                Icons.check_circle :
                Icons.check_circle_outline, color: Colors.green,
              ),
              onPressed: onToggleCompletion,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
