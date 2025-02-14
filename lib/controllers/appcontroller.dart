import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'user_controller.dart';
import 'calendar_controller.dart';
import 'habit_controller.dart';
import 'transaction_controller.dart';
import '../models/user.dart';
import '../models/event.dart';
import '../models/habit.dart';
import '../models/transaction.dart';
import '../models/transaction_category.dart';

class AppController extends ChangeNotifier {
  final UserController userController = UserController();
  final CalendarController calendarController = CalendarController();
  final HabitController habitController = HabitController();
  final TransactionController transactionController = TransactionController();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  // Box Hive pour enregistrer la préférence du thème
  Box? _preferencesBox; // Utilisation de Box? au lieu de late

  AppController() {
    init();
  }

  Future<void> init() async {
    await userController.openBox();
    await calendarController.openBox();
    await habitController.openBox();
    await transactionController.openBox();
    await _openPreferencesBox();  // Ouvre la box Hive pour les préférences
    await _loadTheme();
  }

  // Ouvrir la box Hive pour les préférences
  Future<void> _openPreferencesBox() async {
    _preferencesBox = await Hive.openBox('preferences');
  }

  // Charger la préférence du thème depuis Hive
  Future<void> _loadTheme() async {
    if (_preferencesBox != null) {
      _isDarkMode = _preferencesBox?.get('isDarkMode', defaultValue: false) ?? false;
      notifyListeners();
    }
  }

  // Enregistrer la préférence du thème dans Hive
  Future<void> _saveTheme() async {
    if (_preferencesBox != null) {
      await _preferencesBox?.put('isDarkMode', _isDarkMode);
    }
  }

  // Bascule le thème
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _saveTheme(); // Sauvegarde la préférence dans Hive
    notifyListeners();
  }
  
  
  //HABIT FONCTIONS
  Future<void> openBoxHabit() async {
    await habitController.openBox();
  }
  Future<List<Habit>> getHabit() async {
    return habitController.getAllHabits();
  }
  Future<void> addHabit(Habit habit) async {
    await habitController.addHabit(habit);
  }
  Future<void> deleteHabit(Habit habit) async {
    await habitController.deleteHabit(habit);
  }
  String getHabitName(Habit habit) {
    return habitController.getHabitName(habit);
  }
  Map<DateTime, bool> getHistory(Habit habit) {
    return habitController.getHistory(habit);
  }
  Future<void> markDay(Habit habit, DateTime date, bool isDone) async {
    await habitController.markDay(habit, date, isDone);
  }
  Habit? getHabitAvecLePlusDeJoursFaits() {
    return habitController.getHabitAvecLePlusDeJoursFaits();
  }
  int getNombreConsecutive(Habit habit) {
    return habitController.getNombreConsecutive(habit);
  }



  // CALENDAR FONCTIONS
  Future<void> openBoxCalendar() async {
    await calendarController.openBox();
  }
  List<Event> getEvents()  {
    return calendarController.getEvents();
  }
  Future<void>deleteEvent(Event event) async {
    await calendarController.deleteEvent(event);
  }
  Future<void> EventBool(Event event) async {
    await calendarController.EventBool(event);
  }
  String getTitle(Event event) {
    return calendarController.getTitle(event);
  }
  bool isEventFinished(Event event) {
    return calendarController.isEventFinished(event);
  }
  Future<void> addEvent(Event event) async {
    await calendarController.addEvent(event);
  }




  //TRANSACTION FONCTIONS
  Future<void> openBoxTransaction() async {
    await transactionController.openBox();
  }
  List<Transaction> getTransactions() {
    return transactionController.getTransactions();
  }
  Future<void> addTransaction(Transaction transaction) async {
    await transactionController.addTransaction(transaction);
  }
  List<Transaction> getTransactionsByMonth(DateTime date){
    return transactionController.getTransactionsByMonth(date);
  }
  String getNameTransaction(Transaction transaction) {
    return transactionController.getNameTransaction(transaction);
  }
  String getTransactionCategory(Transaction transaction) {
    return transactionController.getTransactionCategory(transaction);
  }
  String getDateTransaction(Transaction transaction) {
    return transactionController.getDateTransaction(transaction);
  }
  Future<void>  deleteTransaction(Transaction transaction) async {
    await transactionController.deleteTransaction(transaction);
  }



  // Retourner le thème actuel en fonction de _isDarkMode
  ThemeData get currentTheme {
    return _isDarkMode
        ? ThemeData.dark().copyWith(
      scaffoldBackgroundColor: Color(0xFF1D1D1D), // Gris très foncé
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF1D1D1D), // Gris foncé pour l'AppBar
        foregroundColor: Colors.white, // Texte blanc pour l'AppBar
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFFFF4081), // Rose vif pour les boutons
        textTheme: ButtonTextTheme.primary, // Texte en blanc sur les boutons
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Colors.white),
        bodyMedium: TextStyle(color: Colors.white70),
      ),
      iconTheme: IconThemeData(color: Colors.white),
      colorScheme: ColorScheme.dark(
        primary: Color(0xFFFF4081), // Rose vif pour les éléments interactifs
        secondary: Color(0xFF64FFDA), // Turquoise pour les éléments secondaires
      ),
    )
        : ThemeData.light().copyWith(
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFF2196F3),
        foregroundColor: Colors.white,
      ),
      buttonTheme: ButtonThemeData(
        buttonColor: Color(0xFF2196F3),
        textTheme: ButtonTextTheme.primary,
      ),
      textTheme: TextTheme(
        bodyLarge: TextStyle(color: Color(0xFF333333)),
        bodyMedium: TextStyle(color: Color(0xFF757575)),
      ),
      iconTheme: IconThemeData(color: Color(0xFF333333)),
      colorScheme: ColorScheme.light(
        primary: Color(0xFF2196F3),
        secondary: Color(0xFF64FFDA),
      ),
    );
  }
}
