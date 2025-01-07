import 'package:hive/hive.dart';

part 'user.g.dart';

@HiveType(typeId: 1) // Assure-toi d'utiliser un typeId unique
class User {
  @HiveField(0)
  String name;

  @HiveField(1)
  Map<String, int> actionsByDate; // La clé est une date sous forme de chaîne, et la valeur est le nombre d'actions.

  User({
    required this.name,
    Map<String, int>? actionsByDate,
  }) : actionsByDate = actionsByDate ?? {};

  // Ajouter une action pour une date donnée
  void addAction(DateTime date) {
    final key = _formatDateKey(date);
    actionsByDate[key] = (actionsByDate[key] ?? 0) + 1;
  }

  // Supprimer une action pour une date donnée
  void removeAction(DateTime date) {
    final key = _formatDateKey(date);
    if (actionsByDate.containsKey(key) && actionsByDate[key]! > 0) {
      actionsByDate[key] = actionsByDate[key]! - 1;

      // Supprimer la clé si aucune action restante pour cette date
      if (actionsByDate[key] == 0) {
        actionsByDate.remove(key);
      }
    }
  }

  // Obtenir le nombre d'actions pour une date donnée
  int getActionsForDate(DateTime date) {
    final key = _formatDateKey(date);
    return actionsByDate[key] ?? 0;
  }

  // Formatter une date en clé unique (format "yyyy-MM-dd")
  String _formatDateKey(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! User) return false;
    return name == other.name && actionsByDate == other.actionsByDate;
  }

  @override
  int get hashCode => name.hashCode ^ actionsByDate.hashCode;
}
