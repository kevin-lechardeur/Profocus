import 'package:hive/hive.dart';
import '../models/habit.dart';

class HabitController {
  Box<Habit>? _habitBox;

  // Ouvrir la boîte Hive pour les habitudes.
  Future<void> openBox() async {
    _habitBox = await Hive.openBox<Habit>('habit');
  }

  // Ajouter une nouvelle habitude.
  Future<void> addHabit(Habit habit) async {
    if (await checkHabitExist(habit)) {
      return;
    }
    await _habitBox?.add(habit);
  }

  // Obtenir le nombre d'habitudes.
  Future<int> numberHabits() async {
    final nbHabits = _habitBox?.length ?? 0;
    return nbHabits;
  }

  // Vérifier si une habitude existe déjà.
  Future<bool> checkHabitExist(Habit habit) async {
    final habitList = _habitBox?.values.toList() ?? [];
    return habitList.any((h) => h.name == habit.name);
  }

  // Récupérer toutes les habitudes.
  Future<List<Habit>> getHabit() async {
    return _habitBox?.values.toList() ?? [];
  }

  // Retourner toutes les habitudes sous forme de liste.
  List<Habit> getAllHabits() {
    return _habitBox?.values.toList() ?? [];
  }

  // Supprimer une habitude.
  Future<void> deleteHabit(Habit habit) async {
    final habitIndex = await getHabitIndex(habit);
    if (habitIndex != null && habitIndex >= 0) {
      await _habitBox?.deleteAt(habitIndex);
      print("Habitude supprimée : ${habit.name}");
    }
  }

  // Obtenir l'index d'une habitude.
  Future<int?> getHabitIndex(Habit habit) async {
    return _habitBox?.values.toList().indexOf(habit);
  }

  // Récupérer une habitude par son nom.
  Habit getHabitByName(String habitName) {
    List<Habit> habits = getAllHabits();
    for (var habit in habits) {
      if (habit.name == habitName) {
        return habit;
      }
    }
    return habits[0]; // Retourne la première habitude si non trouvée.
  }

  // Obtenir le nom d'une habitude.
  String getHabitName(Habit habit)  {
    return habit.name;
  }

  // Récupérer l'historique d'une habitude à une date donnée.
  bool getHistoryByDate(Habit habit, DateTime date) {
    return habit.isDoneForDate(date);
  }

  // Récupérer l'historique complet d'une habitude.
  Map<DateTime, bool> getHistory(Habit habit) {
    return habit.history;
  }

  // Marquer un jour comme fait ou non.
  Future<void> markDay(Habit habit, DateTime date, bool isDone) async {
    final normalizedDate = DateTime(date.year, date.month, date.day);
    if (!habit.isInBox) {
      var box = Hive.box<Habit>('habit');
      int key = await box.add(habit);
      habit = box.get(key)!;
    }
    habit.markDay(normalizedDate, isDone);
    await habit.save();
  }

  // Obtenir l'habitude avec le plus de jours consécutifs marqués comme fait.
  Habit? getHabitAvecLePlusDeJoursFaits() {
    List<Habit> habits = getAllHabits();

    // Vérifie si la liste est vide avant d'accéder aux éléments
    if (habits.isEmpty) return null;

    Habit habitFaits = habits[0];  // Si la liste n'est pas vide, on peut accéder à habits[0]

    for (var habit in habits) {
      if (habit.countConsecutiveTrueDays() > habitFaits.countConsecutiveTrueDays()) {
        habitFaits = habit;
      }
    }

    return habitFaits; // Retourner l'objet Habit complet
  }

  // Récupérer le nombre de jours consécutifs d'une habitude.
  int getNombreConsecutive(Habit habit) {
    return habit.countConsecutiveTrueDays();
  }
}
