import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constant/color_palette.dart';

final Box locale = Hive.box('localStorage');

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    loadTheme();
  }

  ThemeData _themeMode = lightMode;

  ThemeData get themeMode => _themeMode;

  set themeMode(ThemeData themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void toggleTheme(BuildContext context) {
    _themeMode = _themeMode == lightMode ? darkMode : lightMode;
    saveTheme();
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(context, 'mainApp', (route) => false);
  }

  loadTheme() async {
    final savedTheme = locale.get('theme');
    _themeMode = savedTheme ?? lightMode;
  }

  saveTheme() {
    locale.put('theme', themeMode);
  }
}

// FOR CHANGING THEME

//  ElevatedButton(
//                 onPressed: () {
//                   Provider.of<ThemeProvider>(context, listen: false)
//                       .toggleTheme();
//                 },
//                 child: Text('Change Theme')),

