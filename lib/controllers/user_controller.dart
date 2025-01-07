import 'package:hive/hive.dart';
import '../models/user.dart';

class UserController {
  late Box<User> _userBox;

  // Ouvrir la boîte Hive pour l'utilisateur
  Future<void> openBox() async {
    _userBox = await Hive.openBox<User>('userBox');
  }

  // Récupérer un utilisateur
  Future<User?> getUser() async {
    return _userBox.get('user'); // Récupérer l'utilisateur unique
  }

  // Créer un nouvel utilisateur
  Future<void> createUser(String name) async {
    final user = User(name: name);
    await _userBox.put('user', user);
  }

  // Mettre à jour le nombre d'actions pour une date
  Future<void> updateActions(DateTime date, bool isAdding) async {
    final user = await getUser();
    if (user != null) {
      if (isAdding) {
        user.addAction(date);
      } else {
        user.removeAction(date);
      }
      await _userBox.put('user', user); // Sauvegarder les changements
    }
  }

  // Obtenir le nombre d'actions pour une date donnée
  Future<int> getActionsForDate(DateTime date) async {
    final user = await getUser();
    return user?.getActionsForDate(date) ?? 0;
  }
}
