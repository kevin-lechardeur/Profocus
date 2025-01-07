import 'package:flutter/material.dart';
import '../controllers/calendar_controller.dart';
import '../controllers/appcontroller.dart';
import '../models/event.dart';
import '../widgets/calendar_event_tile.dart';
import '../widgets/daily_calendar.dart';



class CalendarPage extends StatefulWidget {
  final CalendarController calendarController;
  final AppController appController;
  CalendarPage ({required this.calendarController, required this.appController});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDate = DateTime.now();
  List<Event> _events = [];

  @override
  void initState() {
    super.initState();
    if (widget.calendarController == null) {
      throw Exception('CalendarController is not initialized');
    }
    widget.calendarController.openBox().then((_) {
      _loadEvents(); // Charger les événements dès que la boîte est ouverte
    });
  }

  // Charger les événements pour la date sélectionnée
  void _loadEvents() {
    setState(() {
      _events = widget.calendarController.getEventsForDate(_selectedDate);
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
            final hour = DateTime(
                _selectedDate.year, _selectedDate.month, _selectedDate.day,
                index + 6);
            final eventsForThisHour = _events.where((event) {
              return event.startTime.hour == hour.hour;
            }).toList();

            // Trier les événements par heure de fin
            eventsForThisHour.sort((a, b) => a.endTime.compareTo(b.endTime));

            // Si aucun événement pour cette heure, on retourne un SizedBox vide
            if (eventsForThisHour.isEmpty) {
              return SizedBox.shrink();
            }
            final finalEvent = eventsForThisHour[0];

            // Afficher un événement unique pour cette heure
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child:
                  Text(
                    '${hour.hour}:${hour.minute.toString().padLeft(
                        2, '0')} h - ${eventsForThisHour.first.endTime
                        .hour}:${eventsForThisHour.first.endTime.minute
                        .toString().padLeft(2, '0')}h',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ...eventsForThisHour.map((event) =>
                    CalendarEventTile(
                      calendarController: widget.calendarController,
                      event: event,
                      onDelete: () async {
                        await widget.calendarController.deleteEvent(
                            event); // Supprimer l'événement du contrôleur
                        _loadEvents(); // Recharger les événements après suppression
                      },
                      onToggleCompletion: () async {
                        //await _controller.getEventIndex(event);
                        await widget.appController.toogleEventFinished(
                            event); // Basculer l'état terminé
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
    String selectedStartHour = "06"; // Par défaut, 6h pour l'heure de début
    String selectedStartMinute = "00"; // Par défaut, 00 minute pour l'heure de début
    String selectedEndHour = "06"; // Par défaut, 6h pour l'heure de fin
    String selectedEndMinute = "15"; // Par défaut, 15 minutes pour l'heure de fin

    // Liste des heures possibles de 6h00 à 23h45
    List<String> hours = [];
    for (int hour = 6; hour < 24; hour++) {
      hours.add(hour.toString().padLeft(2, '0'));
    }

    List<String> minutes = ["00", "15", "30", "45"]; // Créneaux de minutes

    // Fonction pour générer les heures de fin à partir de l'heure de début
    List<String> generateEndHours(String startHour) {
      int startHourInt = int.parse(startHour);
      List<String> availableEndHours = [];

      for (int hour = startHourInt; hour < 24; hour++) {
        availableEndHours.add(hour.toString().padLeft(2, '0'));
      }

      return availableEndHours;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            // Générer les heures de fin basées sur l'heure de début sélectionnée
            List<String> availableEndHours = generateEndHours(
                selectedStartHour);

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
                    decoration: InputDecoration(
                        hintText: 'Titre de l\'événement'),
                  ),
                  SizedBox(height: 20),
                  // Row pour afficher l'heure de début et l'heure de fin côte à côte
                  Row(
                    children: [
                      Text('Début :'),
                      // Dropdown pour l'heure de début
                      DropdownButton<String>(
                        value: selectedStartHour,
                        items: hours.map((hour) {
                          return DropdownMenuItem<String>(
                            value: hour,
                            child: Text(hour),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStartHour = value!;
                            selectedEndHour =
                                value; // Synchroniser l'heure de fin
                          });
                        },
                      ),
                      Text(':'),
                      // Dropdown pour les minutes de début
                      DropdownButton<String>(
                        value: selectedStartMinute,
                        items: minutes.map((minute) {
                          return DropdownMenuItem<String>(
                            value: minute,
                            child: Text(minute),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedStartMinute = value!;
                          });
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Row pour afficher l'heure de fin
                  Row(
                    children: [
                      Text('Fin :'),
                      // Dropdown pour l'heure de fin
                      DropdownButton<String>(
                        value: selectedEndHour,
                        items: availableEndHours.map((hour) {
                          return DropdownMenuItem<String>(
                            value: hour,
                            child: Text(hour),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedEndHour = value!;
                          });
                        },
                      ),
                      Text(':'),
                      // Dropdown pour les minutes de fin
                      DropdownButton<String>(
                        value: selectedEndMinute,
                        items: minutes.map((minute) {
                          return DropdownMenuItem<String>(
                            value: minute,
                            child: Text(minute),
                          );
                        }).toList(),
                        onChanged: (value) {
                          setState(() {
                            selectedEndMinute = value!;
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
                      // Extraire l'heure et les minutes de début et de fin
                      int selectedStartHourInt = int.parse(selectedStartHour);
                      int selectedStartMinuteInt = int.parse(
                          selectedStartMinute);
                      int selectedEndHourInt = int.parse(selectedEndHour);
                      int selectedEndMinuteInt = int.parse(selectedEndMinute);

                      // Créer un nouvel événement avec l'heure de début et de fin
                      final newEvent = Event(
                        title: title,
                        startTime: DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          selectedStartHourInt,
                          selectedStartMinuteInt,
                        ),
                        endTime: DateTime(
                          _selectedDate.year,
                          _selectedDate.month,
                          _selectedDate.day,
                          selectedEndHourInt,
                          selectedEndMinuteInt,
                        ),
                      );
                      widget.calendarController.addEvent(newEvent).then((_) {
                        _loadEvents(); // Recharger les événements après l'ajout
                        Navigator.pop(context); // Fermer la boîte de dialogue
                      });
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