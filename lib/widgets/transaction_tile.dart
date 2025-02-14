import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../controllers/appcontroller.dart';

class TransactionTile extends StatelessWidget {
  final AppController appController;
  final Transaction transaction;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const TransactionTile({
    Key? key,
    required this.transaction,
    required this.onTap,
    required this.appController,
    required this.onDelete,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(appController.getNameTransaction(transaction)),
        subtitle: Text("date: ${appController.getDateTransaction(transaction)}"),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("${transaction.montant}€"),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
