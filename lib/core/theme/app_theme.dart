import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: Colors.blue,
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: Colors.blue,
    );
  }

  static bool isDarkMode(String nim) {
    if (nim.isEmpty) return false;
    final lastChar = nim.characters.last;
    final lastDigit = int.tryParse(lastChar) ?? 0;
    return lastDigit % 2 != 0;
  }
}