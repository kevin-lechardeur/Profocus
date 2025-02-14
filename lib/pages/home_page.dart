import 'package:flutter/material.dart';
import 'package:project/controllers/appcontroller.dart';
import '../models/habit.dart';
import '../widgets/habit_box.dart';
import '../controllers/habit_controller.dart';
import '../widgets/add_habit.dart';

class HomePage extends StatefulWidget {
  final AppController appController ;
  HomePage({required this.appController,});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Habit>> habits = Future.value([]); // Initialisation avec une liste vide
  bool _isDeleteMode = false; // Ajouter un booléen pour activer/désactiver le mode suppression

  @override
  void initState() {
    super.initState();
    widget.appController.openBoxHabit().then((_) {
      _loadHabits();
    });
  }

  void _loadHabits() {
    setState(() {
      habits = widget.appController.getHabit();
    });
  }

  void _toggleDeleteMode() {
    setState(() {
      _isDeleteMode = !_isDeleteMode; // Inverser le mode suppression
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Habits"),
        actions: [
          IconButton(
            icon: Icon(_isDeleteMode ? Icons.close : Icons.delete),
            onPressed: _toggleDeleteMode,
          ),
        ],
      ),

      body: FutureBuilder<List<Habit>>(
        future: habits,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No habits found'));
          } else {
            return ListView.builder(
              physics: BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()), // Toujours scrollable + effet de rebond
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final habit = snapshot.data![index];
                return ListTile(
                  title: HabitBox(
                    habit: habit,
                    appController: widget.appController,
                  ),
                  trailing: _isDeleteMode
                      ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await widget.appController.deleteHabit(habit);
                      _loadHabits();
                    },
                  )
                      : null,
                );
              },
            );

          }
        },
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Habit? newHabit = await Navigator.push<Habit>(
            context,
            MaterialPageRoute(builder: (context) => AddHabitPage()),
          );

          if (newHabit != null) {
            await widget.appController.addHabit(newHabit);
            _loadHabits();
          }
        },
        child: Icon(Icons.add),

      ),
    );
  }
}
