import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/performance_page.dart';
import 'pages/settings_page.dart';
import 'widgets/daily_box.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProFocus',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  // Liste des pages
  final List<Widget> _pages = [
    HomePage(),
    PerformancePage(),
    SettingsPage(),
  ];

  // Changement de page
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProFocus'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Barre des jours toujours visible
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
          Expanded(
            // Contenu dynamique selon l'index sélectionné
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Performance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}
