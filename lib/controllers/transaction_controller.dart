import 'package:hive/hive.dart';
import '../models/transaction.dart';
import '../models/transaction_category.dart';

class TransactionController {
  Box<Transaction>? _transactionBox;

  TransactionController() {
    _initBox();
  }

  Future<void> _initBox() async {
    _transactionBox = await Hive.openBox<Transaction>('transaction');
  }

  Future<void> openBox() async {
    if (!Hive.isBoxOpen('transactions')) {
      _transactionBox = await Hive.openBox<Transaction>('transactions');
    }
  }

  // Ajouter une nouvelle transaction
  Future<void> addTransaction(Transaction transaction) async {
    await _transactionBox?.add(transaction);
    print('Transaction ajoutée: ${transaction.toString()}');
  }

  // Récupérer toutes les transactions
  List<Transaction> getTransactions() {
    return _transactionBox?.values.toList() ?? [];
  }

  // Récupérer les transactions par catégorie
  List<Transaction> getTransactionsByCategory(TransactionCategory category) {
    return _transactionBox?.values
        .where((transaction) => transaction.categorie == category)
        .toList() ?? [];
  }

  // Récupérer les transactions par date
  List<Transaction> getTransactionsByDate(DateTime date) {
    return _transactionBox?.values
        .where((transaction) =>
    transaction.date == "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}")
        .toList() ??
        [];
  }

  // Mettre à jour le montant d'une transaction
  Future<void> updateTransactionMontant(int index, double newMontant) async {
    var transaction = _transactionBox?.getAt(index);
    if (transaction != null) {
      transaction.updateTransactionMontant(newMontant);
      await _transactionBox?.putAt(index, transaction);
      print('Montant de la transaction mis à jour: ${transaction.toString()}');
    }
  }

  // Mettre à jour la récurrence d'une transaction
  Future<void> updateTransactionRecurrence(int index) async {
    var transaction = _transactionBox?.getAt(index);
    if (transaction != null) {
      transaction.updateTransactionRecurrence();
      await _transactionBox?.putAt(index, transaction);
      print('Récurrence de la transaction mise à jour: ${transaction.toString()}');
    }
  }

  // Mettre à jour le type de transaction (revenu ou dépense)
  Future<void> updateTransactionType(int index) async {
    var transaction = _transactionBox?.getAt(index);
    if (transaction != null) {
      transaction.updateTransactionType();
      await _transactionBox?.putAt(index, transaction);
      print('Type de la transaction mis à jour: ${transaction.toString()}');
    }
  }

  // Supprimer une transaction
  Future<void> deleteTransaction(Transaction transaction) async {
    final transactionIndex = _transactionBox?.values.toList().indexOf(transaction);
    if (transactionIndex != null && transactionIndex >= 0) {
      await _transactionBox?.deleteAt(transactionIndex);
      print('Transaction supprimée: ${transaction.toString()}');
    }
  }

  // Récupérer le montant d'une transaction
  double getTransactionMontant(Transaction transaction) {
    return transaction.montant;
  }

  bool getTransactionRecurrence(Transaction transaction) {
    return transaction.recurrence;
  }

  // Récupérer le type de la transaction (revenu ou dépense)
  bool getTransactionType(Transaction transaction) {
    return transaction.typeTransaction;
  }
  List<Transaction> getTransactionsByMonth(DateTime date) {
    return _transactionBox?.values
        .where((transaction) =>
    transaction.getMonth() == date.month.toString().padLeft(2, '0'))
        .toList() ?? [];
  }

}