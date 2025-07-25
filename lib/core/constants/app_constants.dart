import 'package:flutter/material.dart';

class AppConstants {
  // App Colors
  static const Color primaryColor = Color(0xFF800000); // Maroon
  static const Color secondaryColor = Color(0xFFFFC300); // Gold
  static const Color tertiaryColor = Color(0xFFF5F5F5); // Soft Gray
  static const Color backgroundColor = Color(0xFFF8F8F8); // App background
  static const Color cardColor = Colors.white;
  static const Color textColor = Color(0xFF222222);
  static const Color textOnPrimary = Colors.white;
  static const Color textOnSecondary = Color(0xFF800000); // Maroon on gold
  static const Color errorColor = Color(0xFFD32F2F);
  static const Color successColor = Color(0xFF388E3C);
  static const Color warningColor = Color(0xFFFFA000);

  // Text Styles
  static const TextStyle headingStyle = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.bold,
    color: textColor,
  );

  static const TextStyle subheadingStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: textColor,
  );

  static const TextStyle bodyStyle = TextStyle(
    fontSize: 16,
    color: textColor,
  );

  static const TextStyle captionStyle = TextStyle(
    fontSize: 14,
    color: Colors.grey,
  );

  static const TextStyle buttonTextPrimary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textOnPrimary,
  );

  static const TextStyle buttonTextSecondary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: textOnSecondary,
  );

  // Button Styles
  static final ButtonStyle primaryButton = ElevatedButton.styleFrom(
    backgroundColor: primaryColor,
    foregroundColor: textOnPrimary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
    textStyle: buttonTextPrimary,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    elevation: 2,
  );

  static final ButtonStyle secondaryButton = ElevatedButton.styleFrom(
    backgroundColor: secondaryColor,
    foregroundColor: textOnSecondary,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(borderRadiusMedium),
    ),
    textStyle: buttonTextSecondary,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
    elevation: 2,
  );

  // Spacing
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Border Radius
  static const double borderRadiusSmall = 8.0;
  static const double borderRadiusMedium = 12.0;
  static const double borderRadiusLarge = 16.0;

  // Animation Duration
  static const Duration animationDuration = Duration(milliseconds: 300);
} 