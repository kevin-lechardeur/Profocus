import 'package:flutter/material.dart';
import '../controllers/transaction_controller.dart';
import '../models/transaction.dart';

class HistoryPage extends StatefulWidget {
  final TransactionController transactionController;
  final DateTime date;

  HistoryPage({required this.transactionController, required this.date});

  @override
  _HistoryStatePage createState() => _HistoryStatePage();
}

class _HistoryStatePage extends State<HistoryPage> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    transactions = widget.transactionController.getTransactionsByMonth(widget.date);
    transactions.sort((a, b) => a.date.compareTo(b.date));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Historique des transactions"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Transactions pour le mois de ${widget.date.month} ${widget.date.year}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            transactions.isEmpty
                ? Center(child: Text("Aucune transaction pour ce mois."))
                : Expanded(
              child: ListView.builder(
                itemCount: transactions.length,
                itemBuilder: (context, index) {
                  Transaction transaction = transactions[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 5),
                    child: ListTile(
                      title: Text(transaction.name),
                      subtitle: Text("Catégorie: ${transaction.categorie}"),
                      trailing: Text("\$${transaction.montant}"),
                      onTap: () {
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
