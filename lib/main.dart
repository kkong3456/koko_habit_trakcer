import 'package:flutter/material.dart';
import 'package:koko_habit_tracker/pages.dart/home_page.dart';
import 'package:koko_habit_tracker/themes/dart_mode.dart';
import 'package:koko_habit_tracker/themes/light_mode.dart';
import 'package:koko_habit_tracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: lightMode,
    );
  }
}
