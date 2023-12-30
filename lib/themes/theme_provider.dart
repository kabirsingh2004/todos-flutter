import 'package:flutter/material.dart';
import 'package:todos_list/themes/themes.dart';

class ThemeProvider with ChangeNotifier {
  final ThemeData _lightTheme = lightMode;
  final ThemeData _darkTheme = darkMode;
  ThemeMode _currentThemeMode = ThemeMode.dark;

  ThemeData get themeData =>
      _currentThemeMode == ThemeMode.light ? _lightTheme : _darkTheme;
      
  ThemeMode get currentThemeMode => _currentThemeMode;

  set currentThemeMode(ThemeMode themeMode) {
    if (_currentThemeMode != themeMode) {
      _currentThemeMode = themeMode;
      notifyListeners();
    }
  }

  void toggleTheme() {
    currentThemeMode =
        _currentThemeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}
