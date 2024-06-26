import 'package:flutter/material.dart';

ThemeData lightMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.light(
      brightness: Brightness.light,
      background: Color(0xffF7FAF7),
      primary: Color(0xff222831),
      secondary: Color(0xFF676767),
      tertiary: Color(0xff2A7351),
      surface: Color(0xff222831)),
);

ThemeData darkMode = ThemeData(
  useMaterial3: true,
  colorScheme: const ColorScheme.dark(
      brightness: Brightness.dark,
      background: Color(0xff222831),
      primary: Color.fromARGB(255, 228, 228, 228),
      secondary: Color(0xFF676767),
      tertiary: Colors.green,
      surface: Color(0xff222831)),
);
