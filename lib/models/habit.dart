import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';

part 'habit.g.dart';

@HiveType(typeId: 2)
class Habit extends HiveObject {
  @HiveField(0)
  String name; // Nom de l'habitude.

  @HiveField(1)
  Map<DateTime, bool> history; // Historique des jours marqués.

  @HiveField(2)
  Map<int, String>? reminders; // Rappels avec clé de jour et heure au format "HH:mm".

  Habit({
    required this.name,
    required this.history,
    required this.reminders,
  });

  // Méthode pour marquer un jour comme fait ou non.
  void markDay(DateTime date, bool isDone) {
    print(date);
    history[date] = isDone;
  }

  // Vérifier si un jour est fait.
  bool isDoneForDate(DateTime date) {
    return history[date] ?? false;
  }

  // Récupérer la performance d'une semaine donnée.
  Map<int, bool> getPerformanceForWeek(DateTime weekStart) {
    Map<int, bool> weekPerformance = {};
    for (int i = 0; i < 7; i++) {
      final date = weekStart.add(Duration(days: i));
      weekPerformance[i + 1] = isDoneForDate(date);
    }
    return weekPerformance;
  }

  // Obtenir un résumé pour une période donnée.
  Map<DateTime, bool> getSummaryForPeriod(DateTime startDate, DateTime endDate) {
    Map<DateTime, bool> summary = {};
    for (var date = startDate;
    date.isBefore(endDate) || date.isAtSameMomentAs(endDate);
    date = date.add(Duration(days: 1))) {
      summary[date] = isDoneForDate(date);
    }
    return summary;
  }

  // Mettre à jour la progression pour une date donnée.
  void updateDate(DateTime date, bool isDone) {
    history[date] = isDone;
    saveToHive();
    print("update: $history");
  }

  // Définir un rappel pour un jour spécifique avec l'heure au format "HH:mm".
  void setReminder(int day, String time) {
    reminders ??= {};
    reminders![day] = time;
  }

  // Obtenir l'heure du rappel pour un jour spécifique.
  String? getReminder(int day) {
    return reminders?[day];
  }

  // Supprimer un rappel pour un jour spécifique.
  void removeReminder(int day) {
    reminders?.remove(day);
  }

  // Sauvegarde dans Hive.
  Future<void> saveToHive() async {
    await save();
  }

  // Compter le nombre de jours marqués comme true dans l'historique.
  int countConsecutiveTrueDays() {
    List<DateTime> sortedKeys = history.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    int consecutiveCount = 0;
    int totalConsecutiveDays = 0;
    DateTime? previousDate;

    for (DateTime date in sortedKeys) {
      DateTime currentDateWithoutTime = DateTime(date.year, date.month, date.day);
      if (history[date] == true) {
        if (previousDate == null) {

          consecutiveCount++; // Si c'est le premier jour
        } else if (currentDateWithoutTime.difference(previousDate).inDays == 1) {
          // Si la différence est d'un jour

          consecutiveCount++; // On incrémente le compteur de jours consécutifs
        } else {
          if (consecutiveCount > 0) {
            totalConsecutiveDays++; // On compte la séquence consécutive
          }
          consecutiveCount = 1; // Réinitialisation du compteur avec le premier jour de la nouvelle séquence
        }
        previousDate = currentDateWithoutTime; // Mise à jour de la date précédente
      } else {

      }
    }
    if (consecutiveCount > 0) {
      totalConsecutiveDays += consecutiveCount; // Ajouter la dernière séquence
    }
    return totalConsecutiveDays; // Retourner le total calculé
  }

}
