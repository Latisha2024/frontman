import 'package:flutter/material.dart';
//Color(0xFFA5C8D0);

class AppTheme {
  // Primary color palette - ONLY these 4 colors should be used
  static const Color primaryColor = Color(0xFF354447); // #a5c8d0
  static const Color secondaryColor = Color(0xFFC3DCE1); // #c3dce1
  static const Color accentColor =
      Color(0xFF354447); // #354447 (dark blue-gray)
  static const Color backgroundColor = Color(0xFFEFF6F8); // #eff6f8
  static const Color textColor = Color(0xFF354447);

  // Variations for different states using opacity
  static Color get primaryLight => primaryColor.withOpacity(0.3);
  static Color get primaryDark => const Color(0xFF8BB5C0);
  static Color get accentLight => accentColor.withOpacity(0.1);
  static Color get successColor =>
      accentColor; // Use accent color instead of green
  static Color get warningColor =>
      primaryColor; // Use primary color instead of orange
  static Color get errorColor =>
      accentColor.withOpacity(0.8); // Use accent color instead of red

  static ThemeData get themeData {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor, // Darker blue-gray for buttons
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: secondaryColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        labelStyle: const TextStyle(color: textColor),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: textColor),
        bodyMedium: TextStyle(color: textColor),
        titleLarge: TextStyle(color: textColor),
        titleMedium: TextStyle(color: textColor),
        titleSmall: TextStyle(color: textColor),
      ),
    );
  }
}
