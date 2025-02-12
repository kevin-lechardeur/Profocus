import 'package:hive/hive.dart';
import 'transaction_category.dart';
part 'budget.g.dart';

@HiveType(typeId: 4)
class Budget{
  @HiveField(0)
  TransactionCategory categorie;
  @HiveField(1)
  double montantalloue;

  Budget({
    required this.categorie,
    this.montantalloue = 0,
  });

  @override
  String toString() {
    return "Budget(categorie: $categorie, montant alloué: $montantalloue)";
  }
  void updateBudgetMontant(double montant) {
    this.montantalloue = montant;
  }
}