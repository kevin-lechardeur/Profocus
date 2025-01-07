import 'package:flutter/material.dart';
import '../widgets/explore_rectangle.dart';

class ExplorePage extends StatefulWidget {
  @override
  _ExplorePageState createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black54,
        centerTitle: true,
        title: Text(
          'Explore',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Colors.black54,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 0),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.circular(15),
              ),
              padding: EdgeInsets.only(left : 2, right: 2,top: 2,bottom: 2),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionButton('Section 1', 0),
                  SizedBox(width: 5,),
                  _buildSectionButton('Section 2', 1),
                ],
              ),
            ),
            SizedBox(height: 20), // Espace entre le container et le contenu
            Expanded(
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    RectangleSection(), // Section 1
                    RectangleSection(), // Section 2
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionButton(String title, int index) {
    bool isSelected = _tabController.index == index;

    return GestureDetector(
      onTap: () {
        setState(() {
          _tabController.animateTo(index);
        });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3, horizontal: 35),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.grey, // Couleur de fond
          borderRadius: BorderRadius.circular(25), // Arrondi des coins
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: isSelected ? Colors.white :Colors.white, // Couleur du texte
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
