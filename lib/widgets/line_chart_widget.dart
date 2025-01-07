import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';

class LineChartWidget extends StatelessWidget {
  final UserController userController;

  LineChartWidget({required this.userController});

  List<String> _generateDateLabels() {
    List<String> dateLabels = [];
    DateTime today = DateTime.now();
    dateLabels.add(DateFormat('MMM dd').format(today));

    for (int i = 1; i <= 6; i++) {
      DateTime previousDay = today.subtract(Duration(days: i));
      dateLabels.add(DateFormat('MMM dd').format(previousDay));
    }

    return dateLabels.toList();
  }

  List<FlSpot> _generateSpots() {
    List<FlSpot> spots = [];
    DateTime today = DateTime.now();
    for (int i = 0; i <= 6; i++) {
      DateTime targetDate = today.subtract(Duration(days: 6 - i)); // Inversé l'ordre des jours
      int actions = userController.getActionsByDate(targetDate);
      spots.add(FlSpot(i.toDouble(), actions.toDouble()));
    }

    return spots; // Plus besoin de reverse()
  }

  @override
  Widget build(BuildContext context) {
    List<String> dateLabels = _generateDateLabels();
    List<FlSpot> spots = _generateSpots();
    print(spots);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.grey, width: 3),
              left: BorderSide(color: Colors.grey, width: 3),
            ),
          ),
         /* extraLinesData: ExtraLinesData(
            horizontalLines: [
              HorizontalLine(
                y: 2,
                color: Colors.grey.withOpacity(0.5),
                label: HorizontalLineLabel(show: false),
              ),
              HorizontalLine(
                y: 12,
                color: Colors.grey.withOpacity(0.75),
                label: HorizontalLineLabel(show: false),
              ),
              HorizontalLine(
                y: 16,
                color: Colors.grey.withOpacity(1),
                label: HorizontalLineLabel(show: false),
              ),
            ],
          ),*/
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              barWidth: 4,
              color: Colors.blue,
              dotData: FlDotData(show: true),
            ),
          ],
          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(sideTitles: _bottomTitles(dateLabels)),
            /*rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40,
                interval: 1,
                getTitlesWidget: (double value, TitleMeta meta) {
                  double maxY = 16;
                  double middleY = maxY / 2;
                  double middleYx = (maxY + middleY) / 2;
                  if (value == 0 || value == middleY || value == maxY || value == middleYx) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),*/
          ),
        ),
      ),
    );
  }
}

SideTitles _bottomTitles(List<String> labels) => SideTitles(
  showTitles: true,
  reservedSize: 22,
  interval: 1,
  getTitlesWidget: (value, meta) {
    int index = value.toInt();
    if (index >= 0 && index < labels.length) {
      switch (index) {
        case 0:
          return Padding(
            padding: const EdgeInsets.only(left: 16.0),
            child: Text(labels[0]),
          );
        case 3:
          return Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(labels[3]),
          );
        case 6:
          return Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Text(labels[6]),
          );
      }
    }
    return const SizedBox.shrink();
  },
);

