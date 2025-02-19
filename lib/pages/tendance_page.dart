import 'package:flutter/material.dart';
import '../widgets/line_chart_widget.dart';
import '../widgets/cube_grid.dart';

class TendancePage extends StatefulWidget {

  @override
  _TendancePageState createState() => _TendancePageState();
}

class _TendancePageState extends State<TendancePage> {
  bool userExists = false;
  String userName = '';
  bool isLoading = false; // Pour afficher un indicateur de chargement lors de la création d'un utilisateur

  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                Container(child: CubeGrid()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
