import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../controllers/calendar_controller.dart';
import '../controllers/appcontroller.dart';
import '../models/event.dart';
import '../widgets/calendar_event_tile.dart';

class CalendarPage extends StatefulWidget {
  final CalendarController calendarController;
  final AppController appController;
  CalendarPage({required this.calendarController, required this.appController});


  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    widget.calendarController.openBox().then((_) {
      _loadEvents();
    });
  }

  void _loadEvents() {
    setState(() {
      DateTime today = DateTime.now();
      _events = widget.calendarController
          .getEvents()
          .where((event) => event.startTime.isAfter(today) || _isSameDay(event.startTime, today))
          .toList();
      _events.sort((a, b) => a.startTime.compareTo(b.startTime));
    });
  }

  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calendrier des Événements"),
        centerTitle: true,
      ),
      body: ListView(
        physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        children: _buildEventList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  List<Widget> _buildEventList() {
    Map<String, List<Event>> groupedEvents = {};
    for (var event in _events) {
      String dateKey = "${event.startTime.year}-${event.startTime.month.toString().padLeft(2, '0')}-${event.startTime.day.toString().padLeft(2, '0')}";
      if (!groupedEvents.containsKey(dateKey)) {
        groupedEvents[dateKey] = [];
      }
      groupedEvents[dateKey]!.add(event);
    }

    return groupedEvents.entries.map((entry) {
      DateTime date = DateTime.parse(entry.key);
      String formattedDate = DateFormat('EEEE d').format(date);

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              formattedDate,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          ...entry.value.map((event) {
            return CalendarEventTile(
              key: ValueKey(event.startTime.millisecondsSinceEpoch.toString() + event.title),
              calendarController: widget.calendarController,
              event: event,
              onDelete: () async {
                await widget.calendarController.deleteEvent(event);
                _loadEvents();
              },
              onToggleCompletion: () async {
                await widget.calendarController.EventBool(event);
                _loadEvents();
              },
            );
          }).toList(),
        ],
      );
    }).toList();
  }

  void _showAddEventDialog() {
    String title = '';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un événement'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                onChanged: (value) {
                  title = value;
                },
                decoration: InputDecoration(hintText: 'Titre de l\'événement'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(DateTime.now().year + 5),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      selectedDate = pickedDate;
                    });
                  }
                },
                child: Text("Choisir une date"),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  final newEvent = Event(
                    title: title,
                    startTime: DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 0, 0),
                    endTime: DateTime(selectedDate.year, selectedDate.month, selectedDate.day, 23, 59),
                  );
                  widget.calendarController.addEvent(newEvent).then((_) {
                    _loadEvents();
                    Navigator.pop(context);
                  });
                }
              },
              child: Text('Ajouter'),
            ),
          ],
        );
      },
    );
  }
}
