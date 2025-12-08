import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF12D6A7); // mint
  static const Color primaryDark = Color(0xFF0DBC93);
  static const Color background = Color(0xFFEFFBF3);
  static const Color surface = Color(0xFFDFF5E8);
  static const Color textDark = Color(0xFF0E2C28);
}

ThemeData buildLightTheme() {
  final base = ThemeData.light(useMaterial3: true);
  return base.copyWith(
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      primary: AppColors.primary,
      background: AppColors.background,
      surface: AppColors.surface,
      onPrimary: Colors.white,
    ),
    scaffoldBackgroundColor: AppColors.background,
    textTheme: base.textTheme.copyWith(
      displayLarge: const TextStyle(fontSize: 44, fontWeight: FontWeight.w800, height: 1.2),
      displayMedium: const TextStyle(fontSize: 36, fontWeight: FontWeight.w800, height: 1.2),
      headlineMedium: const TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
      titleMedium: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      bodyLarge: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      bodyMedium: const TextStyle(fontSize: 14),
    ).apply(bodyColor: AppColors.textDark, displayColor: AppColors.textDark),
    appBarTheme: const AppBarTheme(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        shape: const StadiumBorder(),
        minimumSize: const Size.fromHeight(52),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.surface,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: AppColors.surface,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.black54,
      type: BottomNavigationBarType.fixed,
    ),
  );
}


