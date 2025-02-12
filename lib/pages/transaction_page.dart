import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import '../models/transaction.dart';
import '../models/transaction_category.dart';
import '../controllers/transaction_controller.dart';
import '../widgets/add_transaction.dart';

class TransactionPage extends StatefulWidget {
  final TransactionController transactionController;
  TransactionPage({required this.transactionController});
  @override
  _TransactionPageState createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<Transaction> transactions = []; // Liste des transactions

  @override
  void initState() {
    super.initState();
    _reloadTransactions();
  }

  void _reloadTransactions() async {
    final updatedTransactions = await widget.transactionController.getTransactions();
    setState(() {
      transactions = updatedTransactions;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    List<Transaction> monthlyTransactions = transactions.where((t) {
      DateTime transactionDate = t.date;
      return transactionDate.year == now.year && transactionDate.month == now.month && !t.typeTransaction;
    }).toList();

    Map<TransactionCategory, double> categoryTotals = {};
    for (var t in monthlyTransactions) {
      categoryTotals[t.categorie] = (categoryTotals[t.categorie] ?? 0) + t.montant;
    }
    double totalExpenses = categoryTotals.values.fold(0, (sum, amount) => sum + amount);

    return Scaffold(
      appBar: AppBar(
        title: Text("Transactions"),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),

          if(totalExpenses > 0) ...[
            SizedBox(
              height: 250,
              child: SfCartesianChart(
                primaryXAxis: CategoryAxis(
                  majorGridLines: MajorGridLines(width: 0), // Masque les lignes de grille horizontales
                  axisLine: AxisLine(width: 0), // Masque la ligne de l'axe des X
                  majorTickLines: MajorTickLines(width: 0), // Masque les marques de l'axe des X
                  labelIntersectAction: AxisLabelIntersectAction.none, // Masque les labels sur l'axe des X
                ),
                primaryYAxis: NumericAxis(
                  minimum: 0,
                  maximum: 100,
                  interval: 20,
                  majorGridLines: MajorGridLines(width: 0), // Masque les lignes de grille verticales
                  axisLine: AxisLine(width: 0), // Masque la ligne de l'axe des Y
                  majorTickLines: MajorTickLines(width: 0), // Masque les marques de l'axe des Y
                  labelFormat: '', // Masque les labels (0%, 25%, 50%, etc.)
                ),
                series: <ChartSeries>[
                  StackedBar100Series<MapEntry<TransactionCategory, double>, String>(
                    dataSource: categoryTotals.entries.toList(),
                    xValueMapper: (MapEntry<TransactionCategory, double> data, _) => data.key.name, // Nom de la catégorie
                    yValueMapper: (MapEntry<TransactionCategory, double> data, _) {
                      double percentage = (data.value / totalExpenses) * 100;
                      double roundedPercentage = percentage.roundToDouble();
                      return roundedPercentage;
                    },
                    pointColorMapper: (MapEntry<TransactionCategory, double> data, _) => data.key.color, // Couleur de chaque barre
                    name: 'Dépenses par catégorie',
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                      labelAlignment: ChartDataLabelAlignment.top,
                      textStyle: TextStyle(color: Colors.white), // Définit la couleur des labels en blanc
                    ),
                  ),
                ],
                tooltipBehavior: TooltipBehavior(enable: true),
              ),
            ),
            SizedBox(height: 20),
          ],

          // Deuxième graphique: Pie Chart avec les montants des catégories
          Expanded(
            child: totalExpenses > 0
                ? SfCircularChart(
              series: <CircularSeries>[
                PieSeries<MapEntry<TransactionCategory, double>, String>(
                  dataSource: categoryTotals.entries.toList(),
                  xValueMapper: (MapEntry<TransactionCategory, double> data, _) => data.key.name,
                  yValueMapper: (MapEntry<TransactionCategory, double> data, _) => data.value,
                  pointColorMapper: (MapEntry<TransactionCategory, double> data, _) => data.key.color,
                  dataLabelSettings: DataLabelSettings(
                    isVisible: true,
                    labelPosition: ChartDataLabelPosition.outside,
                    textStyle: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
                : Center(child: Text("Aucune dépense ce mois-ci")),
          ),

          // Affichage du total des dépenses
          Text("Total: ${totalExpenses.toStringAsFixed(2)}€", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 20),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Transaction? newTransaction = await Navigator.push<Transaction>(
            context,
            MaterialPageRoute(builder: (context) => AddTransactionPage()),
          );

          if (newTransaction != null) {
            await widget.transactionController.addTransaction(newTransaction);
            _reloadTransactions();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}