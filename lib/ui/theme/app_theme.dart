import 'package:flutter/material.dart';

class AppTheme {
  // Light scheme colors
  static const Color plumPrimary = Color(0xFF17408A);
  static const Color plumOnPrimary = Color(0xFFFFFFFF);
  static const Color plumContainer = Color(0xFFDDE8FF);
  static const Color plumOnContainer = Color(0xFF0C2A63);

  static const Color amberSecondary = Color(0xFF2C72D6);
  static const Color amberContainer = Color(0xFFD6E6FF);
  static const Color amberOnContainer = Color(0xFF0A2654);

  static const Color warmBackground = Color(0xFFFFFFFF);
  static const Color warmSurface = Color(0xFFFFFFFF);
  static const Color warmSurfaceVariant = Color(0xFFF2F5FA);
  static const Color warmOnSurface = Color(0xFF1C1917);
  static const Color warmOnSurfaceVar = Color(0xFF6B6560);

  // Dark scheme colors
  static const Color plumPrimaryDark = Color(0xFFB9D2FF);
  static const Color plumContainerDark = Color(0xFF13346F);
  static const Color amberSecondaryDark = Color(0xFF86B4FF);
  static const Color amberContainerDark = Color(0xFF1B3D78);
  static const Color darkBackground = Color(0xFF0C1220);
  static const Color darkSurface = Color(0xFF131C2E);
  static const Color darkSurfaceVariant = Color(0xFF1D2942);
  static const Color darkOnSurface = Color(0xFFE2E8F7);
  static const Color darkOnSurfaceVar = Color(0xFFB9C5DC);

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: const ColorScheme.light(
        primary: plumPrimary,
        onPrimary: plumOnPrimary,
        primaryContainer: plumContainer,
        onPrimaryContainer: plumOnContainer,
        secondary: amberSecondary,
        secondaryContainer: amberContainer,
        onSecondaryContainer: amberOnContainer,
        tertiary: Color(0xFF65558F),
        tertiaryContainer: Color(0xFFEADDFF),
        background: warmBackground,
        surface: warmSurface,
        surfaceVariant: warmSurfaceVariant,
        onSurface: warmOnSurface,
        onSurfaceVariant: warmOnSurfaceVar,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 30,
          letterSpacing: -0.2,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 0,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          letterSpacing: 0.2,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.2,
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.2,
        ),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme.dark(
        primary: plumPrimaryDark,
        onPrimary: plumOnContainer, // dark primary is light text/icon, so onPrimary is dark text
        primaryContainer: plumContainerDark,
        secondary: amberSecondaryDark,
        secondaryContainer: amberContainerDark,
        tertiary: Color(0xFFD0BCFF),
        tertiaryContainer: Color(0xFF4F378B),
        background: darkBackground,
        surface: darkSurface,
        surfaceVariant: darkSurfaceVariant,
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnSurfaceVar,
      ),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(
          fontWeight: FontWeight.w800,
          fontSize: 30,
          letterSpacing: -0.2,
        ),
        titleLarge: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 22,
          letterSpacing: 0,
        ),
        titleMedium: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          letterSpacing: 0,
        ),
        titleSmall: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 15,
          letterSpacing: 0,
        ),
        bodyLarge: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 16,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontWeight: FontWeight.normal,
          fontSize: 14,
          letterSpacing: 0.2,
        ),
        labelLarge: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          letterSpacing: 0.2,
        ),
        labelMedium: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 12,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
