import 'package:flutter/material.dart';

class RectangleSection extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double screenHeight = MediaQuery.of(context).size.height;
        double screenWidth = MediaQuery.of(context).size.width;
        print(screenHeight);
        return Column(
          children: List.generate(
              3,
                (index) => Container(
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  height: screenHeight/6,
                  width: screenWidth/1.1,

                  margin: const EdgeInsets.symmetric(vertical: 5.0),
                  child: Center(

                    child: Text(
                      'Rectangle ${index + 1}',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                  ),
               ),
             ),
            ),
        );
        },
      );
   }
}
