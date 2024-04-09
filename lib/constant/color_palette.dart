import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      background: Color(0xffF7FAF7),
      primary: Color(0xff222831),
      secondary: Color(0xFF676767)),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      background: Color(0xff2C2C2C),
      primary: Color(0xffF7FAF7),
      secondary: Color(0xFF676767)),
);
