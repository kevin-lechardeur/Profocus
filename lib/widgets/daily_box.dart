import 'package:flutter/material.dart';


class DailyBox extends StatelessWidget {
  final String day;
  final bool isToday; // Indique si c'est le jour actuel
  DailyBox(this.day, {this.isToday = false});

  @override
  Widget build(BuildContext context) {
    // Récupérer la couleur du texte par défaut et la couleur d'accent du thème
    final textColor = isToday
        ? Theme.of(context).colorScheme.secondary // Couleur d'accent du thème (par exemple : bleu, orange, etc.)
        : Theme.of(context).textTheme.bodyLarge?.color ?? Colors.orangeAccent; // Couleur par défaut du texte, sinon noir

    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      child: Text(
        day,
        style: TextStyle(
          color: textColor, // Appliquer la couleur dynamique
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}