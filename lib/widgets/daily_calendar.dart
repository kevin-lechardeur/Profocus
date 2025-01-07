import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DailyCalendar extends StatelessWidget {
  final DateTime date; // Ajout d'une propriété pour la date

  DailyCalendar({required this.date}); // Constructeur pour passer la date

  String getDayName(DateTime date) {
    return DateFormat('Md').format(date); // Obtenir le nom du jour
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 140,
      height: 40,
      child: Text(
        getDayName(date), // Utiliser la date passée en paramètre
        style: TextStyle(
          color: Colors.black,
          fontFamily: 'Roboto',
          fontSize: 25,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
