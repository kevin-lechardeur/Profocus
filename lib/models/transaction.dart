import 'package:hive/hive.dart';
import 'transaction_category.dart';
import 'package:intl/intl.dart';
part 'transaction.g.dart';



@HiveType(typeId: 3)
class Transaction {
  @HiveField(0)
  double montant; // Montant de la transaction

  @HiveField(1)
  TransactionCategory categorie; // Utilisation de l'Enum

  @HiveField(2)
  bool typeTransaction; // true pour revenu, false pour dépense

  @HiveField(3)
  bool recurrence; // false par défaut, true pour récurrence

  @HiveField(4)
  DateTime date; // Date au format yyyy-MM-dd

  @HiveField(5)
  String name;
  // Constructeur de la classe
  Transaction({
    required this.montant,
    required this.categorie,
    required this.typeTransaction,
    required this.recurrence,
    required this.date,
    required this.name,
  }) ;

  // Méthode pour afficher la transaction sous forme de chaîne
  @override
  String toString() {
    return "Transaction(Nom: $name, montant: $montant, catégorie: ${categorie.name}, type: ${typeTransaction ? 'Revenu' : 'Dépense'}, récurrente: $recurrence, date: $date)";  }
  void updateTransactionRecurrence() {
    this.recurrence = !this.recurrence;
  }
  void updateTransactionType() {
    this.typeTransaction = !this.typeTransaction;
  }
  void updateTransactionMontant(double montant) {
    this.montant = montant;
  }
  void updateTransactionDate(DateTime date) {
    this.date = date;
  }
  void updateTransactionCategorie(TransactionCategory categorie) {
    this.categorie = categorie;
  }

  String getDateTransaction() {
    return DateFormat('yyyy/MM/dd').format(date);
  }
  String getMonth(){
    return date.month.toString().padLeft(2, '0');
  }
}