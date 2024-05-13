import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../constant/color_palette.dart';

final Box themePref = Hive.box('themePreferences');

class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    loadTheme();
  }
  bool _isLight = true;
  ThemeData _themeMode = lightMode;

  ThemeData get themeMode => _themeMode;
  bool get isLight => _isLight;

  set themeMode(ThemeData themeMode) {
    _themeMode = themeMode;
    notifyListeners();
  }

  set isLight(bool issLight) {
    _isLight = issLight;
    notifyListeners();
  }

  void toggleTheme(BuildContext context) {
    _themeMode = _themeMode == lightMode ? darkMode : lightMode;
    _isLight = _themeMode == lightMode ? true : false;
    saveTheme();
    notifyListeners();
    Navigator.pushNamedAndRemoveUntil(context, 'mainApp', (route) => false);
  }

  loadTheme() async {
    final savedTheme = themePref.get('theme');
    _themeMode = savedTheme ? lightMode : darkMode;
  }

  saveTheme() {
    themePref.put('theme', isLight);
  }
}

// FOR CHANGING THEME

//  ElevatedButton(
//                 onPressed: () {
//                   Provider.of<ThemeProvider>(context, listen: false)
//                       .toggleTheme();
//                 },
//                 child: Text('Change Theme')),

