import 'package:flutter/material.dart';

import 'ma_colors.dart';

abstract class MaTheme {
  MaTheme._();

  // =====================
  // 🎨 LIGHT THEME
  // =====================
  static ThemeData light() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,

      // Color scheme (Material 3)
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: MaColors.primary,
        onPrimary: MaColors.white,
        primaryContainer: MaColors.primaryContainer,
        onPrimaryContainer: MaColors.onPrimaryContainer,
        secondary: MaColors.secondary,
        onSecondary: MaColors.white,
        secondaryContainer: MaColors.secondaryLight,
        onSecondaryContainer: MaColors.secondaryDarkStrong,
        tertiary: MaColors.success,
        onTertiary: MaColors.white,
        error: MaColors.error,
        onError: MaColors.white,
        errorContainer: MaColors.errorLight,
        onErrorContainer: MaColors.errorDark,
        surface: MaColors.surface,
        onSurface: MaColors.textPrimary,
        outline: MaColors.border,
        shadow: MaColors.black12,
        inverseSurface: MaColors.darkSurface,
        onInverseSurface: MaColors.white,
        inversePrimary: MaColors.inversePrimary,
        surfaceTint: MaColors.primary,
      ),

      scaffoldBackgroundColor: MaColors.background,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: MaColors.white,
        foregroundColor: MaColors.textPrimary,
      ),

      // Cards
      cardTheme: CardTheme(
        color: MaColors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: MaColors.border),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MaColors.primary,
          foregroundColor: MaColors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: MaColors.primary,
          foregroundColor: MaColors.white,
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MaColors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MaColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MaColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MaColors.primary),
        ),
      ),

      // Divider
      dividerColor: MaColors.border,

      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: MaColors.textPrimary),
        bodyMedium: TextStyle(color: MaColors.textSecondary),
      ),
    );
  }

  // =====================
  // 🌙 DARK THEME
  // =====================
  static ThemeData dark() {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: MaColors.darkPrimary,
        onPrimary: MaColors.white,
        primaryContainer: MaColors.primaryContainerDark,
        onPrimaryContainer: MaColors.primaryContainer,
        secondary: MaColors.darkSecondary,
        onSecondary: MaColors.black,
        secondaryContainer: MaColors.secondaryDark,
        onSecondaryContainer: MaColors.secondaryLight,
        tertiary: MaColors.darkSuccess,
        onTertiary: MaColors.black,
        error: MaColors.darkError,
        onError: MaColors.black,
        errorContainer: MaColors.errorContainerDark,
        onErrorContainer: MaColors.errorLight,
        surface: MaColors.darkSurface,
        onSurface: MaColors.darkTextPrimary,
        outline: MaColors.darkBorder,
        shadow: MaColors.black,
        inverseSurface: MaColors.white,
        onInverseSurface: MaColors.darkBackground,
        inversePrimary: MaColors.darkInversePrimary,
        surfaceTint: MaColors.darkPrimary,
      ),
      scaffoldBackgroundColor: MaColors.darkBackground,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: MaColors.darkSurface,
        foregroundColor: MaColors.white,
      ),
      cardTheme: CardTheme(
        color: MaColors.darkSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: MaColors.darkBorder),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MaColors.darkCard,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerColor: MaColors.darkBorder,
    );
  }
}
