import 'package:flutter/material.dart';

class DailyBox extends StatelessWidget {
  final String day;

  DailyBox(this.day);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 40,
      height: 40,
      child: Text(
        day,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
