import 'package:flutter/material.dart';
import '../config/theme_config.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.light;

  ThemeMode get themeMode => _themeMode;
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  ThemeData get themeData {
    return isDarkMode ? ThemeConfig.darkTheme() : ThemeConfig.lightTheme();
  }

  void toggleTheme() {
    _themeMode = isDarkMode ? ThemeMode.light : ThemeMode.dark;
    notifyListeners();
  }

  void setTheme(bool isDark) {
    _themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
    notifyListeners();
  }
}
