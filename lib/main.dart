import 'package:flutter/material.dart';
import 'package:koko_habit_tracker/models/habit_database.dart';
import 'package:koko_habit_tracker/pages.dart/home_page.dart';
import 'package:koko_habit_tracker/themes/theme_provider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //initialize database
  await HabitDatabase.initialize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp(
    MultiProvider(
      providers: [
        //habit provider
        ChangeNotifierProvider(create: (_) => HabitDatabase()),
        //theme provider
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
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
      // theme: context.read<ThemeProvider>().themeData,
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
