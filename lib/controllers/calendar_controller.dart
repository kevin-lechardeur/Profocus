import 'package:hive/hive.dart';
import '../models/event.dart';

class CalendarController {
  Box<Event>? _eventBox;


  // Ouvrir la boîte Hive pour les événements
  Future<void> openBox() async {
    _eventBox = await Hive.openBox<Event>('events'); // Nom de la boîte
  }

  Future<void> addEvent(Event event) async {
    if (getEventsForDate(getEventDate(event)).length == 0) {
      await _eventBox?.add(event);
    }else{
      checkEventOverlap(event);
      await _eventBox?.add(event);
    }
  }

  // Récupérer tous les événements
  List<Event> getEvents() {
    return _eventBox?.values.toList() ?? []; // Récupère tous les événements
  }
  String getTitle(Event event) {
    return event.title;
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
      mergeEventsIfNeeded(event);
    }
  }

  // Fusionner les événements s'ils ont le même titre
  void mergeEventsIfNeeded(Event deletedEvent) {
    final events = getEventsForDate(deletedEvent.startTime);
    events.sort((a, b) => a.startTime.compareTo(b.startTime));
    for (int i = 0; i < events.length - 1; i++) {
      final currentEvent = events[i];
      final nextEvent = events[i + 1];
      if (currentEvent.title == nextEvent.title) {
        Event mergedEvent = Event(
          title: currentEvent.title,
          startTime: currentEvent.startTime,
          endTime: nextEvent.endTime,
        );
        deleteEvent(currentEvent);
        deleteEvent(nextEvent);
        addEvent(mergedEvent);
        break;
      }
    }
  }

  void splitEventIfOverlap(Event firstEvent, Event secondEvent) {
    if (firstEvent.startTime.isBefore(secondEvent.endTime) && firstEvent.endTime.isAfter(secondEvent.startTime)) {
      if (firstEvent.startTime.isBefore(secondEvent.startTime)) {
        Event firstPart = Event(
          title: firstEvent.title,
          startTime: firstEvent.startTime,
          endTime: secondEvent.startTime,
        );
        Event secondPart = Event(
          title: firstEvent.title,
          startTime: secondEvent.endTime,
          endTime: firstEvent.endTime,
        );
        deleteEvent(firstEvent);
        addEvent(firstPart);
        addEvent(secondPart);
      }
    }
  }

  void checkEventOverlap(Event event) {
    List<Event> events = getEventsForDate(event.startTime);
    for (Event e in events) {
      if (e != event) {
        if (e.startTime.isBefore(event.endTime) && e.endTime.isAfter(event.startTime)) {
          splitEventIfOverlap(e, event); // Découper l'événement e
        }
        if (event.startTime.isBefore(e.endTime) && event.endTime.isAfter(e.startTime)) {
          splitEventIfOverlap(event, e); // Découper l'événement event
        }
      }
    }
  }
  Future<void> toogleEventFinished(Event event) async {
    final eventIndex = getEventIndex(event);
    if (eventIndex == null) {
      return ;
    } else {
      Event updatedEvent = Event(
        title: event.title,
        startTime: event.startTime,
        endTime: event.endTime,
        isFinished: !event.isFinished,
      );
      await _eventBox?.putAt(eventIndex, updatedEvent);
    }
  }
  bool isEventFinished(Event event) {
    return event.isFinished;
  }
}
