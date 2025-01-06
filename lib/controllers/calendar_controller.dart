import 'package:hive/hive.dart';
import '../models/event.dart';

class CalendarController {
  Box<Event>? _eventBox;

  // Ouvrir la boîte Hive pour les événements
  Future<void> openBox() async {
    _eventBox = await Hive.openBox<Event>('events'); // Nom de la boîte
  }

  // Ajouter un événement
  Future<void> addEvent(Event event) async {
    await _eventBox?.add(event); // Ajoute l'événement dans la boîte
  }

  // Récupérer tous les événements
  List<Event> getEvents() {
    return _eventBox?.values.toList() ?? []; // Récupère tous les événements
  }

  // Récupérer les événements pour une date donnée
  List<Event> getEventsForDate(DateTime date) {
    return _eventBox?.values.where((event) {
      return event.startTime.year == date.year &&
          event.startTime.month == date.month &&
          event.startTime.day == date.day;
    }).toList() ?? [];
  }
}
