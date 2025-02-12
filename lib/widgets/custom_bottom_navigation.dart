import 'package:flutter/material.dart';

class CustomBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigation({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2a2925),
      child: ClipPath(
        clipper: TopRoundedCornerClipper(),
        child: Container(
          height: 70,
          color: Color(0xFF3d3d3d),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(Icons.home, "Home", 0),
              _buildNavItem(Icons.bar_chart, "Tendance", 1),
              _buildNavItem(Icons.calendar_month, "Calendrier", 2),
              _buildNavItem(Icons.explore, "Explorer", 3),
              _buildNavItem(Icons.settings, "Paramètre", 4),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: index == currentIndex ? Color(0xFFf79534) : Colors.white,
          ),
          Text(
            label,
            style: TextStyle(
              color: index == currentIndex ? Color(0xFFf79534) : Colors.white,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class TopRoundedCornerClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20.0;

    Path path = Path();
    path.moveTo(0, size.height);
    path.lineTo(0, radius);
    path.quadraticBezierTo(0, 0, radius, 0);
    path.lineTo(size.width - radius, 0);
    path.quadraticBezierTo(size.width, 0, size.width, radius);
    path.lineTo(size.width, size.height);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
