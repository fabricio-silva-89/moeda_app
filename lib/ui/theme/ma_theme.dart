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
        onPrimary: Colors.white,
        primaryContainer: MaColors.primaryContainer,
        onPrimaryContainer: MaColors.onPrimaryContainer,
        secondary: MaColors.secondary,
        onSecondary: Colors.white,
        secondaryContainer: Color(0xFFDCFCE7),
        onSecondaryContainer: Color(0xFF166534),
        tertiary: MaColors.success,
        onTertiary: Colors.white,
        error: MaColors.error,
        onError: Colors.white,
        errorContainer: Color(0xFFFEE2E2),
        onErrorContainer: Color(0xFF991B1B),
        surface: Colors.white,
        onSurface: Color(0xFF0F172A),
        outline: Color(0xFFE5E7EB),
        shadow: Colors.black12,
        inverseSurface: Color(0xFF0F172A),
        onInverseSurface: Colors.white,
        inversePrimary: Color(0xFF93C5FD),
        surfaceTint: MaColors.primary,
      ),

      scaffoldBackgroundColor: MaColors.background,

      // AppBar
      appBarTheme: const AppBarTheme(
        elevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        foregroundColor: Color(0xFF0F172A),
      ),

      // Cards
      cardTheme: CardTheme(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: MaColors.primary,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),

      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: MaColors.primary,
          foregroundColor: Colors.white,
        ),
      ),

      // Inputs
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.all(14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: MaColors.primary),
        ),
      ),

      // Divider
      dividerColor: const Color(0xFFE5E7EB),

      // Text theme
      textTheme: const TextTheme(
        headlineLarge: TextStyle(fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontWeight: FontWeight.w600),
        bodyLarge: TextStyle(color: Color(0xFF0F172A)),
        bodyMedium: TextStyle(color: Color(0xFF475569)),
      ),
    );
  }

  // =====================
  // 🌙 DARK THEME
  // =====================
  static ThemeData dark() {
    const primary = Color(0xFF3B82F6);
    const secondary = Color(0xFF22C55E);
    const success = Color(0xFF4ADE80);
    const error = Color(0xFFF87171);

    const background = Color(0xFF020617);
    const surface = Color(0xFF0F172A);

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: const ColorScheme(
        brightness: Brightness.dark,
        primary: primary,
        onPrimary: Colors.white,
        primaryContainer: Color(0xFF1E3A8A),
        onPrimaryContainer: MaColors.primaryContainer,
        secondary: secondary,
        onSecondary: Colors.black,
        secondaryContainer: Color(0xFF14532D),
        onSecondaryContainer: Color(0xFFDCFCE7),
        tertiary: success,
        onTertiary: Colors.black,
        error: error,
        onError: Colors.black,
        errorContainer: Color(0xFF7F1D1D),
        onErrorContainer: Color(0xFFFEE2E2),
        surface: surface,
        onSurface: Color(0xFFF8FAFC),
        outline: Color(0xFF1F2937),
        shadow: Colors.black,
        inverseSurface: Colors.white,
        onInverseSurface: Color(0xFF020617),
        inversePrimary: Color(0xFF2563EB),
        surfaceTint: primary,
      ),
      scaffoldBackgroundColor: background,
      appBarTheme: const AppBarTheme(
        elevation: 0,
        backgroundColor: surface,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardTheme(
        color: surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1F2937)),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF111827),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      dividerColor: const Color(0xFF1F2937),
    );
  }
}
