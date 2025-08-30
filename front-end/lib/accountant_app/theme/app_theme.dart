import 'package:flutter/material.dart';
import '../../constants/colors.dart';

class AppTheme {
  // Primary color palette (declared explicitly, but sourced from AppColors)
  static const Color primaryColor = AppColors.primary;
  static const Color secondaryColor = AppColors.secondary;
  static const Color accentColor = AppColors.accent;
  static const Color backgroundColor = AppColors.background;
  static const Color textColor = AppColors.textPrimary;

  // Variations for different states
  static Color get primaryLight => AppColors.primary.withOpacity(0.3);
  static Color get primaryDark => AppColors.primary.withOpacity(0.8);
  static Color get accentLight => AppColors.accent.withOpacity(0.1);

  // Status colors
  static Color get successColor => AppColors.success;
  static Color get warningColor => AppColors.warning;
  static Color get errorColor => AppColors.error;

  // Extra aliases for clarity (matching colors.dart naming)
  static const Color surfaceColor = AppColors.surface;
  static const Color surfaceVariantColor = AppColors.surfaceVariant;
  static const Color borderColor = AppColors.border;
  static const Color borderLightColor = AppColors.borderLight;
  static const Color textSecondaryColor = AppColors.textSecondary;
  static const Color textLightColor = AppColors.textLight;

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: primaryColor,
      scaffoldBackgroundColor: backgroundColor,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: accentColor,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        color: surfaceColor,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        fillColor: AppColors.inputFill,
        filled: true,
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
        bodyMedium: TextStyle(color: textSecondaryColor),
        titleLarge: TextStyle(color: textColor, fontWeight: FontWeight.bold),
        titleMedium: TextStyle(color: textColor),
        titleSmall: TextStyle(color: textSecondaryColor),
      ),
    );
  }
}

