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

  //edit habit box
  void editHabitBox(Habit habit) {
    //set the controller's  text to the habit's current name
    textController.text = habit.name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
          content: TextField(
            controller: textController,
          ),
          actions: [
            //save button
            MaterialButton(
              onPressed: () {
                String newHabitName = textController.text;
                //save to db
                context
                    .read<HabitDatabase>()
                    .updateHabitName(habit.id, newHabitName);
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
            ),
          ]),
    );
  }

  //delete habit box
  void deleteHabitBox(Habit habit) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Are you sure you want to delete'),
        actions: [
          //delete button
          MaterialButton(
            onPressed: () {
              //delete from db
              context.read<HabitDatabase>().deleteHabit(habit.id);
              //pop box
              Navigator.pop(context);
              //clear controller
              textController.clear();
            },
            child: const Text('Delete'),
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
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
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
          editHabit: (context) => editHabitBox(habit),
          deleteHabit: (context) => deleteHabitBox(habit),
        );
      },
    );
  }
}
