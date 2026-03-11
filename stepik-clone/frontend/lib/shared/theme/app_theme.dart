import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    // Material Design 3
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorSchemeSeed: const Color(0xFF2D6CDF),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }

  static ThemeData dark() {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: const Color(0xFF2D6CDF),
    );

    return base.copyWith(
      appBarTheme: const AppBarTheme(centerTitle: false),
    );
  }
}

