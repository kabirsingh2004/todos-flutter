import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.light(
    background: Colors.white,
    primary: Colors.black,
    secondary: Colors.grey.shade900,
  ),
  scaffoldBackgroundColor: Colors.white,
);

ThemeData darkMode = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.dark(
    background: Colors.black12,
    primary: Colors.deepPurple,
    secondary: Colors.grey.shade400,
  ),
  scaffoldBackgroundColor: Colors.black,
);
