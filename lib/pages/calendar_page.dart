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
  DateTime _selectedDate = DateTime.now();
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    _controller.openBox().then((_) {
      _loadEvents(); // Charger les événements dès que la boîte est ouverte
    });
  }

  // Charger les événements pour la date sélectionnée
  void _loadEvents() {
    setState(() {
      _events = _controller.getEventsForDate(_selectedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        title: DailyCalendar(date: _selectedDate),
        centerTitle: true,
      ),
      body: GestureDetector(
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity! < 0) {
            // Swipe vers la gauche (jour suivant)
            setState(() {
              _selectedDate = _selectedDate.add(Duration(days: 1));
              _loadEvents(); // Recharger les événements pour le nouveau jour
            });
          } else if (details.primaryVelocity! > 0) {
            // Swipe vers la droite (jour précédent)
            setState(() {
              _selectedDate = _selectedDate.subtract(Duration(days: 1));
              _loadEvents(); // Recharger les événements pour le nouveau jour
            });
          }
        },
        child: ListView.builder(
          itemCount: 18,
          itemBuilder: (context, index) {
            final hour = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, index + 6);
            final eventsForThisHour = _events.where((event) {
              return event.startTime.hour == hour.hour;
            }).toList();

            // Si aucun événement pour cette heure, on retourne un SizedBox vide
            if (eventsForThisHour.isEmpty) {
              return SizedBox.shrink();
            }

            // Afficher un événement unique pour cette heure
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '${hour.hour} h - ${eventsForThisHour.first.endTime.hour} h',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...eventsForThisHour.map((event) => CalendarEventTile(
                  event: event,
                  onDelete: () async {
                    await _controller.deleteEvent(event); // Supprimer l'événement du contrôleur
                    _loadEvents(); // Recharger les événements après suppression
                  },
                  onToggleCompletion: () async {
                    await _controller.toogleEventFinished(event); // Basculer l'état terminé
                    _loadEvents(); // Recharger les événements après modification
                  },
                )),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddEventDialog(),
        child: Icon(Icons.add),
      ),
    );
  }

  void _showAddEventDialog() {
    String title = '';
    int selectedHour = 0;
    int selectedHourFinal = 0;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder( // Utilisation de StatefulBuilder pour gérer l'état local
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Ajouter un événement'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Champ de texte pour le titre de l'événement
                  TextField(
                    onChanged: (value) {
                      title = value; // Mettre à jour le titre
                    },
                    decoration: InputDecoration(hintText: 'Titre de l\'événement'),
                  ),
                  SizedBox(height: 20),
                  // Dropdown pour l'heure de début
                  Row(
                    children: [
                      Text('Heure :'),
                      DropdownButton<int>(
                        value: selectedHour, // Valeur actuelle du Dropdown
                        items: List.generate(18, (index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text('${index + 6} h'),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            selectedHour = value!; // Mettre à jour l'heure de début
                          });
                        },
                      ),
                    ],
                  ),
                  // Dropdown pour l'heure de fin
                  Row(
                    children: [
                      Text('Heure de fin :'),
                      DropdownButton<int>(
                        value: selectedHourFinal, // Valeur actuelle du Dropdown
                        items: List.generate(18, (index) {
                          return DropdownMenuItem(
                            value: index,
                            child: Text('${index + 6} h'),
                          );
                        }),
                        onChanged: (value) {
                          setState(() {
                            selectedHourFinal = value!; // Mettre à jour l'heure de fin
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
                      final newEvent = Event(
                        title: title,
                        startTime: DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          selectedHour + 6, // Convertir l'heure en heure réelle
                        ),
                        endTime: DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          selectedHourFinal + 6, // Convertir l'heure en heure réelle
                        ),
                      );
                      _controller.addEvent(newEvent); // Ajouter l'événement dans le contrôleur
                      _loadEvents(); // Recharger les événements après l'ajout
                      Navigator.pop(context); // Fermer la boîte de dialogue
                    }
                  },
                  child: Text('Ajouter'),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
