import 'package:flutter/material.dart';


class DailyBox extends StatelessWidget {
  final String day;
  final bool isToday; // Indique si c'est le jour actuel
  DailyBox(this.day, {this.isToday = false});

  @override
  Widget build(BuildContext context) {
    return Container(
  alignment: Alignment.center,
      width: 40,
      height: 40,
      child: Text(
        day,
        style: TextStyle(
          color: isToday ? Colors.deepOrangeAccent : Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}