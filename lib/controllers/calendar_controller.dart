import 'dart:io';

import 'package:hive/hive.dart';
import '../models/event.dart';

class CalendarController {
  Box<Event>? _eventBox;

  Future<void> openBox() async {
    _eventBox = await Hive.openBox<Event>('events');
  }

  Future<void> addEvent(Event event) async {
      await _eventBox?.add(event);
      //print('Event added  ${event.title}');
      //print('Event added  ${event.startTime}');
  }

  List<Event> getEvents() {
    return _eventBox?.values.toList() ?? [];
  }
  String getTitle(Event event) {
    return event.title;
  }
  Future<void> clearEvents() async {
    await _eventBox?.clear();
  }
  Future<void> updateEventOrder(List<Event> updatedEvents) async {
    if (updatedEvents.isEmpty) return;
    try {
      for (var event in updatedEvents) {
        await deleteEvent(event);
      }
      for (var event in updatedEvents) {
        await addEvent(event);
      }
    } catch (e) {
      print("Erreur lors de la mise à jour de l'ordre des événements: $e");
    }
  }
  // Récupérer l'index d'un événement
  int? getEventIndex(Event event) {
    final index = _eventBox?.values.toList().indexOf(event);
    return (index != null && index >= 0) ? index : null;
  }

  // Récupérer les événements pour une date donnée
  List<Event> getEventsForDate(DateTime date) {
    return _eventBox?.values.where((event) {
      return event.startTime.year == date.year &&
          event.startTime.month == date.month &&
          event.startTime.day == date.day;
    }).toList() ?? [];
  }
  // Récupérer la date d'un évenements
  DateTime getEventDate(Event event) {
    return event.startTime;
  }

  // Supprimer un événement
  Future<void> deleteEvent(Event event) async {
    final eventIndex = _eventBox?.values.toList().indexOf(event);
    if (eventIndex != null && eventIndex >= 0) {
      await _eventBox?.deleteAt(eventIndex);
    }
  }
  // Mettre à jour un événement
  bool isEventFinished(Event event) {
    return event.isFinished;
  }
  Future<void> EventBool(Event event) async {
    if (!event.isInBox) {
      print("⚠️ L'événement '${event.title}' n'est pas encore enregistré dans Hive, ajout en cours...");
      var box = Hive.box<Event>('events');
      int key = await box.add(event); // Ajoute l'événement dans Hive
      event = box.get(key)!; // Récupère l'objet depuis Hive
    } else {
      print("✅ L'événement '${event.title}' est bien enregistré dans Hive.");
    }

    event.updateEventIsFinished(); // Mise à jour de l'état
    await event.save(); // Sauvegarde dans Hive
  }
}
