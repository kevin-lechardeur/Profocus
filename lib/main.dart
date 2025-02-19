import 'package:flutter/material.dart';
import 'package:project/pages/get_started_page.dart';
import 'package:provider/provider.dart'; // Ajout de l'import Provider
import 'package:project/models/habit.dart';
import 'package:project/pages/history_page.dart';
import 'package:project/pages/profile_page.dart';
import 'package:project/pages/tendance_page.dart';
import 'widgets/custom_bottom_navigation.dart';
import 'widgets/daily_box.dart';
import 'package:intl/intl.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'controllers/calendar_controller.dart';
import 'controllers/appcontroller.dart';
import 'controllers/habit_controller.dart';
import 'controllers/transaction_controller.dart';
import 'models/event.dart';
import 'models/habit.dart';
import 'models/transaction.dart';
import 'models/transaction_category.dart';
import 'models/transaction_category_adapter.dart';
import 'pages/transaction_page.dart';
import 'pages/home_page.dart';
import 'pages/settings_page.dart';
import 'pages/calendar_page.dart';
import 'pages/get_started_page.dart';
import 'pages/history_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    print("✅ Firebase est bien initialisé !");
  } catch (e) {
    print("🚨 Firebase n'est PAS bien connecté : $e");
  }
  await Hive.initFlutter();
  Hive.registerAdapter(TransactionCategoryAdapter());
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(HabitAdapter());
  Hive.registerAdapter(TransactionAdapter());
  await Hive.openBox<Event>('event');
  await Hive.openBox<Habit>('habit');
  await Hive.openBox<Transaction>('transaction');
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppController()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppController>(
      builder: (context, appController, _) {
        return MaterialApp(
          title: 'ProFocus',
          debugShowCheckedModeBanner: false,
          theme: appController.currentTheme,
          initialRoute: '/',
          routes: {
            '/': (context) => StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Scaffold(body: Center(child: CircularProgressIndicator()));
                }
                if (snapshot.hasData) {
                  return MainScreen();
                }
                return GetStartedPage();
              },
            ),
            '/home': (context) => MainScreen(),
          },
        );
      },
    );
  }
}

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      HomePage(appController: AppController()),
      TendancePage(),
      CalendarPage(appController: AppController()),
      TransactionPage(appController: AppController(),),
      ProfilePage(appController: AppController()),
    ];
  }

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

        actions: [
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsPage()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 50,

            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DailyBox('lun.', isToday: today == 'Monday'),
                DailyBox('mar.', isToday: today == 'Tuesday'),
                DailyBox('mer.', isToday: today == 'Wednesday'),
                DailyBox('jeu.', isToday: today == 'Thursday'),
                DailyBox('ven.', isToday: today == 'Friday'),
                DailyBox('sam.', isToday: today == 'Saturday'),
                DailyBox('dim.', isToday: today == 'Sunday'),
              ],
            ),
          ),
          Expanded(
            child: _pages[_selectedIndex],
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNavigation(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}