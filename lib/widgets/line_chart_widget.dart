import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as developer;

class LineChartWidget extends StatelessWidget {
  List<String> _generateDateLabels() {
    List<String> dateLabels = [];
    DateTime today = DateTime.now();

    dateLabels.add(DateFormat('MMM dd').format(today));

    for (int i = 1; i <= 6; i++) {
      DateTime previousDay = today.subtract(Duration(days: i));
      dateLabels.add(DateFormat('MMM dd').format(previousDay));
    }

    return dateLabels.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {
    List<String> dateLabels = _generateDateLabels();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border.all(color: Colors.black, width: 2),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1),
                FlSpot(1, 4),
                FlSpot(2, 6),
                FlSpot(3, 8),
                FlSpot(4, 4),
                FlSpot(5, 12),
                FlSpot(6, 16),
              ],
              isCurved: true,
              color: Colors.blue,
            ),
          ],
        ),
      ),
    );
  }
}
