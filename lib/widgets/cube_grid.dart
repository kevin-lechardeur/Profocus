import 'package:flutter/material.dart';
import 'dart:developer' as developer;

class CubeGrid extends StatefulWidget {
  @override
  _CubeGridState createState() => _CubeGridState();
}

class _CubeGridState extends State<CubeGrid> {
  final double spacing = 4;
  final int rows = 7;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double gridHeight = 120;

    final double horizontalPadding = screenWidth * 0.1;
    final double availableWidth = screenWidth - 2 * horizontalPadding - 2 * 8;
    final double cubeSize = (gridHeight - spacing * (rows - 1)) / rows;
    final int columns = (availableWidth / (cubeSize + spacing)).floor();

    int totalCubes = rows * columns;
    List<Color> cubeColors = List.generate(totalCubes, (index) => Colors.grey);

    return Container(
      margin: EdgeInsets.symmetric(horizontal: horizontalPadding),
      decoration: BoxDecoration(color: Colors.black),
      child: Container(
        height: gridHeight,
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: spacing,
            mainAxisSpacing: spacing,
          ),
          itemCount: totalCubes,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                setState(() {
                  cubeColors[index] =
                  cubeColors[index] == Colors.grey ? Colors.blue : Colors.grey;
                });
              },
              child: Container(
                color: cubeColors[index],
              ),
            );
          },
        ),
      ),
    );
  }
}
