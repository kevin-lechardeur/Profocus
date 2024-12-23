import 'dart:math';
import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/rendering.dart';
import 'package:intl/intl.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProFocus',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          title: const Text(
            'ProFocus',
            style: TextStyle(
              fontFamily: 'Montserrat',
              fontWeight: FontWeight.bold,
              fontSize: 26,
            ),
          ),
          centerTitle: true,
          toolbarHeight: 50,
        ),
        body: Column(
          children: [
            Container(
              height: 50,
              color: Colors.black,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  DailyBox('lun.'),
                  DailyBox('mar.'),
                  DailyBox('mer.'),
                  DailyBox('jeu.'),
                  DailyBox('ven.'),
                  DailyBox('sam.'),
                  DailyBox('dim.'),
                ],
              ),
            ),
            Column(
              children: [
                // Titre aligné à gauche avec Align
                Align(
                  alignment: Alignment(-0.8,0.0), // Alignement à gauche
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
                // Graphique
                Container(
                  height: 200,
                  child: LineChartWidget(),
                ),
              ],
            ),

            Column(
              children: [
                CubeGrid(),

                // Ajoute d'autres widgets si nécessaire
              ],
            ),
          ],
        ),
      ),
    );
  }
}

Widget DailyBox(String day) {
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

class LineChartWidget extends StatelessWidget {
  // Fonction pour générer les dates des 7 derniers jours, y compris aujourd'hui.
  List<String> _generateDateLabels() {
    List<String> dateLabels = [];
    DateTime today = DateTime.now();

    // Ajouter aujourd'hui
    dateLabels.add(DateFormat('MMM dd').format(today));

    // Ajouter les 6 jours précédents
    for (int i = 1; i <= 6; i++) {
      DateTime previousDay = today.subtract(Duration(days: i));
      dateLabels.add(DateFormat('MMM dd').format(previousDay));
    }

    // Inverser pour que la plus récente soit à droite
    return dateLabels.reversed.toList();
  }

  @override
  Widget build(BuildContext context) {

    // Récupérer les labels de date pour la semaine
    List<String> dateLabels = _generateDateLabels();
    developer.log("List,$dateLabels");
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false), // Pas de grille
          borderData: FlBorderData(
            show: true,
            border: Border(
              bottom: BorderSide(color: Colors.black, width: 2),
              left: BorderSide(color: Colors.black, width: 2),
            ),
          ),
          lineBarsData: [
            LineChartBarData(
              spots: [
                FlSpot(0, 1), // Point (x:0, y:1)
                FlSpot(1, 4),
                FlSpot(2, 6),
                FlSpot(3, 8),
                FlSpot(4, 4),
                FlSpot(5, 12),
                FlSpot(6, 16),
              ],
              isCurved: true,
              barWidth: 4,
              color: Colors.blue,
              dotData: FlDotData(show: true),
            ),
          ],

          titlesData: FlTitlesData(
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                reservedSize: 40, // Ajoute de l'espace sous les titres
                showTitles: true, // Afficher les titre
                getTitlesWidget: (double value, TitleMeta meta) {
                  int index = value.toInt(); // Récupère l'index sous forme d'entier

                  // Vérifier que l'index est dans les limites de la liste de dates
                  if (index >= 0 && index < dateLabels.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0), // Espacement avec le graphique
                      child: Text(
                        dateLabels[index], // Affiche la date correspondant à l'index
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // Ne rien afficher pour les indices hors limites
                },
              ),
            ),


            rightTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 40, // Ajoute plus d'espace pour les titres sur la droite

                interval: 1,

                getTitlesWidget: (double value, TitleMeta meta) {
                  double maxY = 16; // Point maximum
                  double middleY = maxY / 2;
                  // Afficher uniquement 0, middleY et maxY
                  if (value == 0 || value == middleY || value == maxY) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child : Text(
                        value.toInt().toString(),
                        style: const TextStyle(fontSize: 12, color: Colors.black),
                      ),
                    );
                  }
                  return const SizedBox.shrink(); // Ne rien afficher pour les autres valeurs
                },
              ),
            ),
          ),
        ),
      ),
    );

  }
}

class CubeGrid extends StatefulWidget {
@override
_CubeGridState createState() => _CubeGridState();
}
//Classe Cube construct + modification des cubes.
class _CubeGridState extends State<CubeGrid> {
  final double spacing = 4; // Espacement entre les cubes
  final int rows = 7; // Toujours 7 cubes en hauteur

  @override
  Widget build(BuildContext context) {
    // Obtenir les dimensions de l'écran
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridHeight = 120; // Hauteur ajustée de la grille pour 7 cubes

    // Calculer 10% de la largeur de l'écran pour avoir l'espace à gauche et à droite
    final double horizontalPadding = screenWidth * 0.1;

    // Recalculer la taille des cubes en tenant compte du padding de la grille
    final double availableWidth = screenWidth - 2 * horizontalPadding - 2 * 8; // 8 est le padding horizontal de la grille (2 * 8 pour gauche et droite)
    final double cubeSize = (gridHeight - spacing * (rows - 1)) / rows;
    developer.log('cubeSize: $cubeSize');

    // Calculer dynamiquement le nombre de colonnes pour remplir la largeur
    final int columns = (availableWidth / (cubeSize + spacing)).floor();

    // Total de cubes nécessaires
    int totalCubes = rows * columns;

    // Générer la liste des couleurs pour chaque cube
    List<Color> cubeColors = List.generate(totalCubes, (index) => Colors.grey);

    return Container(
      // Box englobant avec dégradé de fond
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding), // Ajouter un margin ici
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(12), // Ajouter un rayon de bordure pour un effet arrondi
      ),
      child: Container(
        // Box englobante des cubes sans padding ici
        child: Container(
          height: gridHeight, // Hauteur fixe de la grille
          padding: const EdgeInsets.all(8.0), // Padding autour de la grille de cubes
          child: GridView.builder(
            physics: NeverScrollableScrollPhysics(), // Pas de défilement
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns, // Colonnes dynamiques
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              mainAxisExtent: cubeSize, // Fixer la hauteur des cubes
            ),
            itemCount: totalCubes, // Nombre total de cubes
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    // Alterner la couleur du cube
                    cubeColors[index] =
                    cubeColors[index] == Colors.grey ? Colors.blue : Colors.grey;
                  });
                },
                child: Container(
                  width: cubeSize,
                  height: cubeSize,
                  decoration: BoxDecoration(
                    color: cubeColors[index],
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(color: Colors.black, width: 1),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
