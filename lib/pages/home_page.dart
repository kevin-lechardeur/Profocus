import 'package:flutter/material.dart';
import '../models/habit.dart';
import '../widgets/habit_box.dart';
import '../controllers/habit_controller.dart';
import '../widgets/add_habit.dart';

class HomePage extends StatefulWidget {
  final HabitController habitController;
  HomePage({required this.habitController});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List<Habit>> habits = Future.value([]); // Initialisation avec une liste vide
  bool _isDeleteMode = false; // Ajouter un booléen pour activer/désactiver le mode suppression

  @override
  void initState() {
    super.initState();
    widget.habitController.openBox().then((_) {
      _loadHabits();
    });
  }

  void _loadHabits() {
    setState(() {
      habits = widget.habitController.getHabit();
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
                    habitController: widget.habitController,
                  ),
                  trailing: _isDeleteMode
                      ? IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      await widget.habitController.deleteHabit(habit);
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
            await widget.habitController.addHabit(newHabit);
            _loadHabits();
          }
        },
        child: Icon(Icons.add),

      ),
    );
  }
}
