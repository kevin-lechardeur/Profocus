import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../controllers/appcontroller.dart';

class HabitBox extends StatefulWidget {
  final Habit habit;
  final AppController appController;

  HabitBox({required this.habit, required this.appController});

  @override
  _HabitBoxState createState() => _HabitBoxState();
}

class _HabitBoxState extends State<HabitBox> {
  bool _showActionBar = false;
  DateTime? _selectedDate;
  DateTime currentWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)); // Lundi actuel
  DateTime maxWeekStart = DateTime.now().subtract(Duration(days: DateTime.now().weekday - 1)); // Lundi de cette semaine

  // Calculer la série de jours consécutifs
  int _calculateStreak(Map<DateTime, bool> history) {
    if (history.isEmpty) return 0;

    List<DateTime> sortedDates = history.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    DateTime? lastDate;
    int streak = 0;

    for (var currentDate in sortedDates) {
      if (history[currentDate] == false) {
        break;
      }

      if (lastDate == null || lastDate.difference(currentDate).inDays == 1) {
        streak++;
        lastDate = currentDate;
      } else {
        break;
      }
    }

    return streak;
  }

  // Changer de semaine
  void _changeWeek(int days) {
    DateTime newWeekStart = currentWeekStart.add(Duration(days: days));

    // Vérifie que la nouvelle semaine ne dépasse pas la semaine actuelle
    if (newWeekStart.isAfter(maxWeekStart)) {
      return;
    }

    setState(() {
      currentWeekStart = newWeekStart;
    });
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.appController.getHabitName(widget.habit);
    final history = widget.appController.getHistory(widget.habit);
    final streak = _calculateStreak(history);
    final today = DateTime.now();
    final weekDays = List.generate(7, (index) => currentWeekStart.add(Duration(days: index)));

    return GestureDetector(
      onHorizontalDragEnd: (details) {
        if (details.primaryVelocity! < 0) {
          _changeWeek(7);
        } else if (details.primaryVelocity! > 0) {
          _changeWeek(-7);
        }
      },
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.green,
              margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ListTile(
                title: Row(
                  children: [
                    Text(
                      'Streak: $streak',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    SizedBox(width: 10),
                    Text(name),
                  ],
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: List.generate(7, (index) {
                    final currentDate = weekDays[index];
                    final formattedDate = DateTime(currentDate.year, currentDate.month, currentDate.day); // Ignore l'heure
                    final isCompleted = history[formattedDate] ?? false;
                    final isFuture = currentDate.isAfter(today);

                    return Expanded(
                      child: GestureDetector(
                        onTap: isFuture
                            ? null
                            : () {
                          setState(() {
                            _selectedDate = currentDate;
                            _showActionBar = true;
                          });
                        },
                        child: Container(
                          height: 30,
                          margin: const EdgeInsets.symmetric(horizontal: 2.0),
                          decoration: BoxDecoration(
                            color: isFuture
                                ? Colors.grey.shade300
                                : currentDate == _selectedDate
                                ? Colors.orange
                                : isCompleted
                                ? Colors.blue  // Si l'historique indique true, afficher en bleu
                                : Colors.transparent,
                            border: Border.all(color: Colors.grey, width: 1),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: Center(
                            child: Text(
                              currentDate.day.toString(),
                              style: TextStyle(
                                color: isFuture ? Colors.grey : Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            if (_showActionBar)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedDate != null) {
                          widget.appController.markDay(widget.habit, _selectedDate!, false);
                          setState(() {
                            _showActionBar = false;
                          });
                        }
                        _selectedDate = null;
                      },
                      child: Text('Action 1'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (_selectedDate != null) {
                          widget.appController.markDay(widget.habit, _selectedDate!, true);
                          setState(() {
                            _showActionBar = false;
                          });
                        }
                        _selectedDate = null;
                      },
                      child: Text('Action 2'),
                    ),
                    IconButton(
                      onPressed: () {
                        setState(() {
                          _showActionBar = false;
                          _selectedDate = null;
                        });
                      },
                      icon: Icon(Icons.close, color: Colors.white),
                    ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
