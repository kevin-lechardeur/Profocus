import 'package:flutter/material.dart';
import '../controllers/appcontroller.dart';
import '../models/event.dart';

class CalendarEventTile extends StatelessWidget {

  final Event event;
  final VoidCallback onDelete;
  final VoidCallback onToggleCompletion;
  final AppController appController;
  CalendarEventTile({
    Key? key,
    required this.event,
    required this.onDelete,
    required this.onToggleCompletion,
    required this.appController,
  }): super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Text(
          appController.getTitle(event),
          style: TextStyle(
            decoration: appController.isEventFinished(event) ? TextDecoration.lineThrough : null,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                appController.isEventFinished(event) ?
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
