import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:koko_habit_tracker/models/app_settings.dart';
import 'package:koko_habit_tracker/models/habit.dart';
import 'package:path_provider/path_provider.dart';

class HabitDatabase extends ChangeNotifier {
  static late Isar isar;

  /*
    SETUP

  */

  //INITIALIZE - DATABASE
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [HabitSchema, AppSettingsSchema],
      directory: dir.path,
    );
  }

  //Save first date of app startup(for heatmap)
  Future<void> saveFirstLaunchDate() async {
    final existingSettings = await isar.appSettings.where().findFirst();
    if (existingSettings == null) {
      final settings = AppSettings()..firstLaunchDate = DateTime.now();
      await isar.writeTxn(() => isar.appSettings.put(settings));
    }
  }

  //Get first date of app startup(for heatmap)
  Future<DateTime?> getFirstLaunchDate() async {
    final settings = await isar.appSettings.where().findFirst();
    return settings?.firstLaunchDate;
  }

  /*
  CRUDXOPERATIONS

  */

  //List of habits
  final List<Habit> currentHabits = [];

  //CREATE-add a new habit
  Future<void> addHabit(String habitName) async {
    //create a new habit
    final newHabit = Habit()..name = habitName;

    //savie to db
    await isar.writeTxn(() => isar.habits.put(newHabit));

    //re-read from db
    readHabits();
  }

  //READ - read saved habits from db
  Future<void> readHabits() async {
    //fetch all habits from db
    List<Habit> fetchedHabits = await isar.habits.where().findAll();

    //give to current habits
    currentHabits.clear();
    currentHabits.addAll(fetchedHabits);

    //update UI
    notifyListeners();
  }

  //UPDATE - check habit on an off
  Future<void> updateHabitCompletion(int id, bool isCompleted) async {
    //find the specific habit
    final habit = await isar.habits.get(id);

    //update completion status
    if (habit != null) {
      await isar.writeTxn(
        () async {
          if (isCompleted && !habit.completedDays.contains(DateTime.now())) {
            //today
            final today = DateTime.now();

            //add the current date if it's not already in the list
            habit.completedDays.add(
              DateTime(today.year, today.month, today.day),
            );
          } else {
            //remove the current date if the habit is marked as not completed
            habit.completedDays.removeWhere((date) =>
                date.year == DateTime.now().year &&
                date.month == DateTime.now().month &&
                date.day == DateTime.now().day);
          }
          //save the updated habits back to the db
          await isar.habits.put(habit);
        },
      );
    }
    readHabits();
  }

  //UPDATE - edit habit name
  Future<void> updateHabitName(int id, String newName) async {
    final habit = await isar.habits.get(id);
    //update habit name
    if (habit != null) {
      await isar.writeTxn(() async {
        habit.name = newName;
        //save the updated habits back to the db
        await isar.habits.put(habit);
      });
    }
    readHabits();
  }

  //DELETE - delete habit
  Future<void> deleteHabit(int id) async {
    //perform the delete
    await isar.writeTxn(() async {
      await isar.habits.delete(id);
    });
    readHabits();
  }
}
