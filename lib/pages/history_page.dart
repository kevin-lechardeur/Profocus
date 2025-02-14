import 'package:flutter/material.dart';
import '../controllers/appcontroller.dart';
import '../models/transaction.dart';
import '../widgets/transaction_tile.dart';

class HistoryPage extends StatefulWidget {
  final AppController appController;
  final DateTime date;

  HistoryPage({required this.appController, required this.date});

  @override
  _HistoryStatePage createState() => _HistoryStatePage();
}

class _HistoryStatePage extends State<HistoryPage> {
  List<Transaction> transactions = [];

  @override
  void initState() {
    super.initState();
    loadTransactions();
  }

  void loadTransactions() {
    setState(() {
      transactions = widget.appController.getTransactionsByMonth(widget.date);
      transactions.sort((a, b) => a.date.compareTo(b.date));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Historique des transactions")),
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
                  return TransactionTile(
                    transaction: transactions[index],
                    appController: widget.appController,
                    onDelete: () {
                      widget.appController.deleteTransaction(transactions[index]);
                      loadTransactions();
                    },
                    onTap: () {
                      print("Transaction sélectionnée : ${transactions[index].name}");
                    },
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
