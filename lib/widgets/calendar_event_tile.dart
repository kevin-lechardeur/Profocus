import 'package:flutter/material.dart';
import '../models/event.dart';

class CalendarEventTile extends StatelessWidget {
  final Event event;
  final VoidCallback onDelete; // Fonction de suppression passée par le parent

  CalendarEventTile({
    required this.event,
    required this.onDelete, // Recevoir la fonction pour gérer la suppression
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      child: ListTile(
        title: Text(event.title),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red), // Icône de la croix pour la suppression
          onPressed: onDelete, // Appeler la fonction de suppression lorsque le bouton est pressé
        ),
      ),
    );
  }
}
