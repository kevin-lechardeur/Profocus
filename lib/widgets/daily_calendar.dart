import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class Daily_Calendar extends StatelessWidget {
  String getTodayDay() {
    DateTime now = DateTime.now();
    return DateFormat('Md').format(now);
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,

      width: 140,
      height: 40,
      child: Text(
        '${getTodayDay()}',
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