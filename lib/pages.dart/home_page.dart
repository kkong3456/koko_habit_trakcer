import 'package:flutter/material.dart';
import 'package:koko_habit_tracker/components/my_drawer.dart';
import 'package:koko_habit_tracker/components/my_habit_tile.dart';
import 'package:koko_habit_tracker/models/habit.dart';
import 'package:koko_habit_tracker/models/habit_database.dart';
import 'package:koko_habit_tracker/util/habit_util.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var textController = TextEditingController();

  void createNewHabit() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Create a new habit',
          ),
        ),
        actions: [
          //save button
          MaterialButton(
            onPressed: () {
              String newHabitName = textController.text;
              //save to db
              context.read<HabitDatabase>().addHabit(newHabitName);
              //pop box
              Navigator.pop(context);
              //clear controller
              textController.clear();
            },
            child: const Text('Save'),
          ),
          //cancel button
          MaterialButton(
            onPressed: () {
              //pop box
              Navigator.pop(context);
              //clear controller
              textController.clear();
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    context.read<HabitDatabase>().readHabits();
    super.initState();
  }

  void checkHabitOnOff(bool value, Habit habit) {
    //update habit completion status
    if (value != null) {
      context.read<HabitDatabase>().updateHabitCompletion(habit.id, value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(),
      drawer: const MyDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: createNewHabit,
        elevation: 0,
        backgroundColor: Theme.of(context).colorScheme.tertiary,
        child: const Icon(Icons.add),
      ),
      body: _buildHabitList(),
    );
  }

  //build habbit list
  Widget _buildHabitList() {
    final habitDatabase = context.watch<HabitDatabase>();
    //current habits
    List<Habit> currentHabits = habitDatabase.currentHabits;

    //return list of habits UI
    return ListView.builder(
      itemCount: currentHabits.length,
      itemBuilder: (context, index) {
        //get each individual habit
        final habit = currentHabits[index];
        //check if the habit is completed today
        bool isCompletedToday = isHabitCompletedToday(habit.completedDays);
        //return habit tile UI
        return MyHabitTile(
          id: habit.id,
          text: habit.name,
          isCompleted: isCompletedToday,
          onChanged: (value) => checkHabitOnOff(value!, habit),
        );
      },
    );
  }
}
