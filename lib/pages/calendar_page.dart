import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../controllers/calendar_controller.dart';
import '../models/event.dart';
import '../widgets/calendar_event_tile.dart';
import '../widgets/daily_calendar.dart';

class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  final CalendarController _controller = CalendarController();

  @override
  void initState() {
    super.initState();
    _controller.openBox(); // Ouvrir la boîte Hive lors de l'initialisation
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: Daily_Calendar(),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: _controller.openBox(), // Assurez-vous que la boîte est ouverte
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: 18, // Une ligne par heure
              itemBuilder: (context, index) {
                final hour = DateTime(today.year, today.month, today.day, index + 6); // Heure de début de la journée (par exemple 6h)
                final eventsForThisHour = _controller.getEventsForDate(hour); // Récupérer les événements pour cette heure
                if (eventsForThisHour.isEmpty || !eventsForThisHour.any((event) => event.startTime.isAtSameMomentAs(hour))) {
                  return SizedBox.shrink(); // Si aucun événement, ne rien afficher
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${hour.hour} h - ${eventsForThisHour.first.endTime.hour} h',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Afficher les événements pour cette heure
                    ...eventsForThisHour.map((event) => CalendarEventTile(event: event)),
                  ],
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator()); // Chargement en attendant l'ouverture de la boîte Hive
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(), // Ajouter un événement
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog() {
    String title = '';
    DateTime today = DateTime.now();
    int selectedHour = 0;
    int selectedHourFinal = 0;

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
              Row(
                children: [
                  Text('Heure :'),
                  DropdownButton<int>(
                    value: selectedHour,
                    items: List.generate(18, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text('${index + 6} h'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedHour = value!;
                      });
                    },
                  ),
                ],
              ),
              Row(
                children: [
                  Text('Heure de fin :'),
                  DropdownButton<int>(
                    value: selectedHourFinal,
                    items: List.generate(18, (index) {
                      return DropdownMenuItem(
                        value: index,
                        child: Text('${index + 6} h'),
                      );
                    }),
                    onChanged: (value) {
                      setState(() {
                        selectedHourFinal = value!;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (title.isNotEmpty) {
                  setState(() {
                    _controller.addEvent(Event(
                      title: title,
                      startTime: DateTime(today.year, today.month, today.day, selectedHour + 6),
                      endTime: DateTime(today.year, today.month, today.day, selectedHourFinal + 6),
                    ));
                  });
                  Navigator.pop(context);
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
