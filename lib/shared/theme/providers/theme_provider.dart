import 'package:flutter/material.dart';

class ThemeProvider with ChangeNotifier {
  // Default to system theme preference
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  // Toggle function
  void toggleTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }

  // You can add a setSystemTheme to follow device settings if preferred
  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}
