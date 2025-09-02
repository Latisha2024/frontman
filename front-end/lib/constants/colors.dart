import 'package:flutter/material.dart';

class AppColors {
  // Primary brand colors
  static const Color primary = Color(0xFF0161C1); // Bright Blue
  static const Color secondary = Color(0xFF0341A6); // Dark Blue
  static const Color accent =Color(0xFFF5E6C8); // Bright Yellow
  static const Color background = Color(0xFFF3EDE3); // Yellow background as in branding

  // Text colors
  static const Color textPrimary = Color(0xFF0341A6); // Dark Blue
  static const Color textSecondary = Color(0xFF0161C1); // Bright Blue
  static const Color textLight = Colors.white; // White text

  // Status colors (can remain standard UI palette)
  static const Color success = Color(0xFF10B981); // Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Info Blue

  // Surface colors
  static const Color surface = Colors.white;
  static const Color surfaceVariant = Color(0xFFFFE082); // Light Yellow tint for cards

  // Border colors
  static const Color border = Color(0xFF0341A6); // Dark Blue border
  static const Color borderLight = Color(0xFF0161C1); // Lighter Blue border

  // 🔄 Aliases for backward compatibility
  static const Color primaryBlue = primary;
  static const Color secondaryBlue = secondary;
  static const Color accentBlue = accent;
  static const Color backgroundBlue = background;

  // Auth specific
  static const Color backgroundGray = Color(0xFFFFF8E1); // Very light yellow
  static const Color buttonPrimary = primary;
  static const Color buttonSecondary = secondary;
  static const Color buttonText = Colors.white;
  static const Color inputBorder = border;
  static const Color inputFocus = primary;
  static const Color inputFill = Colors.white;

  // Theme color shortcuts
  static const Color primaryColor = primary;
  static const Color secondaryColor = secondary;
  static const Color backgroundColor = background;
  static const Color textColor = textPrimary;
}


