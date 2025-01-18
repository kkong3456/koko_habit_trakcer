import 'package:flutter/material.dart';
import 'package:koko_habit_tracker/themes/dart_mode.dart';
import 'package:koko_habit_tracker/themes/light_mode.dart';

class ThemeProvider extends ChangeNotifier {
  //initially,light mode
  ThemeData _themeData = lightMode;
  //get current theme
  ThemeData get themeData => _themeData;
  //is current theme dark mode
  bool get isDarkMode => _themeData == darkMode;

  //set theme
  set themeData(ThemeData themeData) {
    _themeData = themeData;
    notifyListeners();
  }

  //toggle theme
  void toggleTheme() {
    if (_themeData == lightMode) {
      _themeData = darkMode;
    } else {
      _themeData = lightMode;
    }
    notifyListeners();
  }
}
