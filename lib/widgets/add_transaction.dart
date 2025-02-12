import 'package:flutter/material.dart';
import '../models/transaction.dart';
import '../models/transaction_category.dart';
import 'package:intl/intl.dart';

class AddTransactionPage extends StatefulWidget {
  @override
  _AddTransactionPageState createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends State<AddTransactionPage> {
  final _formKey = GlobalKey<FormState>();
  double _montant = 0.0;
  TransactionCategory _selectedCategory = TransactionCategory.transport;
  bool _isExpense = true;
  bool _isRecurring = false;
  DateTime _selectedDate = DateTime.now();
  String nameTransaction = "";

  void _saveTransaction() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      Transaction newTransaction = Transaction(
        montant: _montant,
        categorie: _selectedCategory,
        typeTransaction: !_isExpense,
        recurrence: _isRecurring,
        date: _selectedDate,
        name: nameTransaction,
      );
      Navigator.pop(context, newTransaction);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Ajouter une transaction")),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(labelText: "Nom de la transaction"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Veuillez entrer un nom";
                  return null;
                },
                onSaved: (value) => nameTransaction = value!,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(labelText: "Montant (€)"),
                validator: (value) {
                  if (value == null || value.isEmpty) return "Veuillez entrer un montant";
                  if (double.tryParse(value) == null) return "Veuillez entrer un nombre valide";
                  return null;
                },
                onSaved: (value) => _montant = double.parse(value!),
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<TransactionCategory>(
                value: _selectedCategory,
                decoration: InputDecoration(labelText: "Catégorie"),
                items: TransactionCategory.values.map((category) {
                  return DropdownMenuItem(
                    value: category,
                    child: Text(category.name),
                  );
                }).toList(),
                onChanged: (value) => setState(() => _selectedCategory = value!),
              ),
              SizedBox(height: 16),
              SwitchListTile(
                title: Text("Type de transaction"),
                subtitle: Text(_isExpense ? "Dépense" : "Revenu"),
                value: _isExpense,
                onChanged: (value) => setState(() => _isExpense = value),
              ),
              SwitchListTile(
                title: Text("Récurrence"),
                value: _isRecurring,
                onChanged: (value) => setState(() => _isRecurring = value),
              ),
              ListTile(
                title: Text("Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}"),
                trailing: Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (pickedDate != null) {
                    setState(() => _selectedDate = pickedDate);
                  }
                },
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _saveTransaction,
                  child: Text("Ajouter"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}