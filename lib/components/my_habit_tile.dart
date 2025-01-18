import 'package:flutter/material.dart';
import 'package:koko_habit_tracker/models/habit_database.dart';
import 'package:provider/provider.dart';

class MyHabitTile extends StatelessWidget {
  final int id;
  final String text;
  final bool isCompleted;
  Function(bool?)? onChanged;

  MyHabitTile({
    super.key,
    required this.id,
    required this.text,
    required this.isCompleted,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: isCompleted
            ? Colors.green
            : Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      child: ListTile(
        title: Text(text),
        leading: Checkbox(
          activeColor: Colors.green,
          value: isCompleted,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
