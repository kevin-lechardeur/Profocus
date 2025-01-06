import 'package:flutter/material.dart';
import 'pages/home_page.dart';
import 'pages/performance_page.dart';
import 'pages/settings_page.dart';
import 'pages/calendar_page.dart';
import 'widgets/daily_box.dart';
import 'package:intl/intl.dart';
import 'models/event.dart';
import 'package:hive_flutter/hive_flutter.dart';


void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  runApp(MyApp());
}

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
    CalendarPage(),
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
    final String today = DateFormat('EEEE').format(DateTime.now());
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
                DailyBox('lun.', isToday: today == 'Monday'),
                DailyBox('mar.', isToday: today == 'Tuesday'),
                DailyBox('mer.', isToday: today == 'Wednesday'),
                DailyBox('jeu.', isToday: today == 'Thursday'),
                DailyBox('ven.', isToday: today == 'Friday'),
                DailyBox('sam.',  isToday: today == 'Saturday'),
                DailyBox('dim.', isToday: today == 'Sunday'),
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
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        backgroundColor: Colors.black,
        selectedItemColor: Colors.deepOrangeAccent,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calender',
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
