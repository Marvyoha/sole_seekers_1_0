import 'package:flutter/material.dart';

import '../../constant/color_palette.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _themeMode = lightMode;

  ThemeData get themeMode => _themeMode;

  set themeMode(ThemeData themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  void toggleTheme() {
    if (_themeMode == lightMode) {
      themeMode = darkMode;
    } else {
      themeMode = lightMode;
    }
  }
}

// FOR CHANGING THEME

//  ElevatedButton(
//                 onPressed: () {
//                   Provider.of<ThemeProvider>(context, listen: false)
//                       .toggleTheme();
//                 },
//                 child: Text('Change Theme')),

