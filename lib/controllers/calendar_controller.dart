import '../models/event.dart';

class CalendarController {
  final List<Event> _events = []; // Liste interne des événements

  List<Event> get events => _events;

  // Ajouter un événement
  void addEvent(Event event) {
    _events.add(event);
  }

  // Supprimer un événement
  void removeEvent(Event event) {
    _events.remove(event);
  }

  // Obtenir les événements pour une date spécifique
  List<Event> getEventsForHour(DateTime hour) {
    return events.where((event) =>
    event.startTime.isBefore(hour.add(Duration(hours: 1))) &&
        event.endTime.isAfter(hour)).toList();
  }

  List<Event> getEventsForDate(DateTime date) {
    return events.where((event) =>
    event.startTime.year == date.year &&
        event.startTime.month == date.month &&
        event.startTime.day == date.day &&
        event.startTime.hour == date.hour).toList();
  }
}
