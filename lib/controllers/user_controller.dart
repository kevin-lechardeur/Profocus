import 'package:hive/hive.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class UserController {
  Box<User>? _userBox;

  Future<void> openBox() async {
    if (_userBox == null) {
      _userBox = await Hive.openBox<User>('user');
    }
  }

  // Vérifie si un utilisateur existe déjà
  bool isUserAlreadyExists() {
    if (_userBox == null) return false;
    return _userBox!.isNotEmpty;
  }

  // Crée un utilisateur et l'ajoute dans la boîte
  Future<void> createUser(String name) async {
    final user = User(name: name);
    await _userBox?.add(user);
  }
  // Récupérer les actions par date
  int getActionsByDate(DateTime date) {
    if (_userBox == null || _userBox!.isEmpty) {
      return 0;
    }
    return _userBox!.getAt(0)?.getActionsForDate(date) ?? 0;
  }

  // Récupérer le nom de l'utilisateur
  String getUserName() {
    if (_userBox == null || _userBox!.isEmpty) {
      return '';
    }
    return _userBox!.getAt(0)?.name ?? '';
  }

  // Ajouter une Point/action à l'utilisateur par date
  Future<void> addActionToUser(DateTime date) async {
    if (_userBox == null || _userBox!.isEmpty) {
      throw Exception("Aucun utilisateur n'est créé.");
    }
    String userName = getUserName();
    if (userName.isEmpty) {
      throw Exception("L'utilisateur n'a pas de nom.");
    }
    /*User? user;
    for (int i = 0; i < _userBox!.length; i++) {
      final u = _userBox!.getAt(i);
      if (u != null && u.name == userName) {
        user = u;
        break;
      }
    }
    if (user == null) {
      throw Exception("Utilisateur non trouvé.");
    }*/
    final user = _userBox!.getAt(0);
    if (user == null) {
      throw Exception("Utilisateur non trouvé.");
    }
    user.addAction(date);
    await _userBox!.putAt(0, user);
    print("Action ajoutée pour $userName le $date");
    print(getActionsByDate(date));
  }
  Future<void> deleteActionToUser(DateTime date) async{
    if (_userBox == null || _userBox!.isEmpty) {
      throw Exception("Aucun utilisateur n'est créé.");
    }
    String userName = getUserName();
    if (userName.isEmpty) {
      throw Exception("L'utilisateur n'a pas de nom.");
    }
   /* for (int i = 0; i < _userBox!.length; i++) {
      final u = _userBox!.getAt(i);
      if (u != null && u.name == userName) {
        user = u;
        break;
      }
    }
    if (user == null) {
      throw Exception("Utilisateur non trouvé.");
    }*/
    final user = _userBox!.getAt(0);
    if (user == null) {
      throw Exception("Utilisateur non trouvé.");
    }
    user.removeAction(date);
    await _userBox!.putAt(0, user);
    print("Action supprimée pour $userName le $date");
    print(getActionsByDate(date)); // Affiche le nombre d'actions pour la date donnée mais je sais pas si ca fonctionne si la date n'a pas d'action
  }
}
