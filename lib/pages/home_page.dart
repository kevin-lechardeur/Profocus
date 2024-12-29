import 'package:flutter/material.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/cube_grid.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Align(
            alignment: Alignment(-0.8, 0.0),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Performance-Day',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Container(height: 200, child: LineChartWidget()),
          CubeGrid(),
        ],
      ),
    );
  }
}
