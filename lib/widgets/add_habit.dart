import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../models/habit.dart';

class AddHabitPage extends StatefulWidget {
  @override
  _AddHabitPageState createState() => _AddHabitPageState();
}

class _AddHabitPageState extends State<AddHabitPage> {
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay? _selectedTime;
  bool _isReminderActive = false;
  Map<int, String> _reminders = {}; // Clé = Jour de la semaine, valeur = Heure sous forme "HH:mm"

  @override
  void initState() {
    super.initState();
    _reminders = {};
  }

  // Méthode pour choisir l'heure avec un TimePicker
  void _pickTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });

      // Si le rappel est activé, on met à jour tous les jours sélectionnés avec l'heure choisie
      if (_isReminderActive) {
        String formattedTime = _selectedTime!.hour.toString().padLeft(2, '0') + ":" + _selectedTime!.minute.toString().padLeft(2, '0');
        _reminders.updateAll((key, value) => formattedTime);
      }
    }
  }

  // Méthode pour activer/désactiver les rappels
  void _toggleReminder(bool? value) {
    setState(() {
      _isReminderActive = value ?? false;

      if (_isReminderActive) {
        // Si les rappels sont activés et que l'heure n'a pas été définie, on la définit à 18h par défaut
        if (_selectedTime == null) {
          _selectedTime = TimeOfDay(hour: 18, minute: 0); // Heure par défaut à 18h
        }

        // Initialiser les rappels pour tous les jours avec l'heure définie
        String formattedTime = _selectedTime!.hour.toString().padLeft(2, '0') + ":" + _selectedTime!.minute.toString().padLeft(2, '0');
        _reminders = {
          0: formattedTime,  // Lundi
          1: formattedTime,  // Mardi
          2: formattedTime,  // Mercredi
          3: formattedTime,  // Jeudi
          4: formattedTime,  // Vendredi
          5: formattedTime,  // Samedi
          6: formattedTime,  // Dimanche
        };
      } else {
        // Si le rappel est désactivé, on vide la map des rappels
        _reminders.clear();
      }

      print("Etat des rappels après changement de switch: $_reminders");
    });
  }

  // Méthode pour sélectionner/désélectionner un jour spécifique
  void _toggleDaySelection(int dayIndex) {
    setState(() {
      if (_selectedTime == null) {
        print("Erreur : L'heure n'est pas définie. Veuillez d'abord sélectionner une heure.");
        return;
      }

      String formattedTime = _selectedTime!.hour.toString().padLeft(2, '0') + ":" + _selectedTime!.minute.toString().padLeft(2, '0');
      if (_reminders.containsKey(dayIndex)) {
        // Si le jour est déjà sélectionné, on le désélectionne
        _reminders.remove(dayIndex);
      } else {
        // Si le jour n'est pas sélectionné et qu'une heure a été définie, on l'ajoute
        _reminders[dayIndex] = formattedTime;
      }
      print("Etat des rappels après sélection/désélection du jour $dayIndex: $_reminders");
    });
  }

  // Méthode pour enregistrer l'habitude
  void _saveHabit() {
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Veuillez entrer un nom pour l'habitude")),
      );
      return;
    }

    // Crée une instance de Habit
    final newHabit = Habit(
      name: _nameController.text.trim(),
      history: {},
      reminders: _isReminderActive ? _reminders : {},
    );

    Navigator.pop(context, newHabit); // Retourne un Habit et non une Map
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Nouvelle habitude"),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Nom de l'habitude *", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(hintText: "Ex: Méditation"),
            ),

            SizedBox(height: 20),
            Text("Activer le rappel ?", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            Switch(
              value: _isReminderActive,
              onChanged: _toggleReminder,
            ),

            if (_isReminderActive) ...[
              SizedBox(height: 20),
              Text("Sélectionner les jours de la semaine", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ...['L', 'M', 'M', 'J', 'V', 'S', 'D'].asMap().entries.map((entry) {
                    int index = entry.key;
                    String day = entry.value;
                    bool isSelected = _reminders.containsKey(index);
                    return GestureDetector(
                      onTap: () {
                        _toggleDaySelection(index); // Gère la sélection/désélection du jour
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.purple : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.purple),
                        ),
                        child: Text(
                          day,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ),

              SizedBox(height: 20),
              Text("Heure de rappel", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ListTile(
                title: Text(_selectedTime != null ? _selectedTime!.format(context) : "Sélectionner une heure"),
                trailing: Icon(Icons.access_time),
                onTap: _pickTime,
              ),
            ],

            Spacer(),
            ElevatedButton(
              onPressed: _saveHabit,
              child: Center(child: Text("Ajouter l'habitude")),
              style: ElevatedButton.styleFrom(minimumSize: Size(double.infinity, 50)),
            ),
          ],
        ),
      ),
    );
  }
}
