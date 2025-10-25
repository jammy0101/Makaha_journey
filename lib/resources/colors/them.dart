import 'package:flutter/material.dart';

class AppTheme {
  /// 🌞 LIGHT THEME
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: const Color(0xFFFAF9F6), // Soft off-white
    primaryColor: const Color(0xFFD4AF37), // Gold
    colorScheme: const ColorScheme.light(
      primary: Color(0xFFD4AF37),
      secondary: Color(0xFF1E7D5C), // Emerald green
      surface: Color(0xFFF5EFE6), // Soft beige
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Color(0xFF2F2F2F), // Text color
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFFD4AF37),
      foregroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Color(0xFF2F2F2F),
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: Color(0xFF2F2F2F)),
      bodySmall: TextStyle(color: Color(0xFF7C7C7C)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFFF5EFE6),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD4AF37), width: 2),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );

  /// 🌚 DARK THEME
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: const Color(0xFF121212), // Deep dark
    primaryColor: const Color(0xFFD4AF37), // Gold stays primary
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFFD4AF37),
      secondary: Color(0xFF1E7D5C),
      surface: Color(0xFF1E1E1E),
      onPrimary: Colors.black,
      onSecondary: Colors.white,
      onSurface: Color(0xFFF5EFE6),
    ),
    appBarTheme: const AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Color(0xFFD4AF37),
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFFD4AF37),
        fontWeight: FontWeight.bold,
        fontSize: 20,
      ),
    ),
    textTheme: const TextTheme(
      headlineMedium: TextStyle(
        color: Color(0xFFF5EFE6),
        fontWeight: FontWeight.bold,
      ),
      bodyMedium: TextStyle(color: Color(0xFFE0E0E0)),
      bodySmall: TextStyle(color: Color(0xFF9E9E9E)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: const Color(0xFF1E1E1E),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4AF37)),
      ),
      focusedBorder: const OutlineInputBorder(
        borderSide: BorderSide(color: Color(0xFFD4AF37), width: 2),
      ),
      labelStyle: const TextStyle(color: Color(0xFFF5EFE6)),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFD4AF37),
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontWeight: FontWeight.bold),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
  );
}
