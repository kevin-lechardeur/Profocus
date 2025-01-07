import 'package:hive/hive.dart';

part 'user.g.dart';  // Cela inclut le fichier généré.

@HiveType(typeId: 1)  // Assure-toi que chaque typeId est unique.
class User {
  @HiveField(0)
  String name;

  @HiveField(1)
  Map<String, int> actionsByDate; // La clé est une date sous forme de chaîne, et la valeur est le nombre d'actions.

  User({
    required this.name,
    Map<String, int>? actionsByDate,
  }) : actionsByDate = actionsByDate ?? {};

  // Les méthodes pour manipuler les actions
  void addAction(DateTime date) {
    final key = _formatDateKey(date);
    actionsByDate[key] = (actionsByDate[key] ?? 0) + 1;
  }

  void removeAction(DateTime date) {
    final key = _formatDateKey(date);
    if (actionsByDate.containsKey(key) && actionsByDate[key]! > 0) {
      actionsByDate[key] = actionsByDate[key]! - 1;

      if (actionsByDate[key] == 0) {
        actionsByDate.remove(key);
      }
    }
  }

  int getActionsForDate(DateTime date) {
    final key = _formatDateKey(date);
    return actionsByDate[key] ?? 0;
  }

  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }
}
