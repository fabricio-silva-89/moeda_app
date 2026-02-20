import 'package:flutter/material.dart';

abstract class MaColors {
  // =====================
  // ⚫ BASE
  // =====================
  static const white = Colors.white;
  static const black = Colors.black;
  static const black12 = Colors.black12;

  // =====================
  // 🔵 PRIMARY (Brand)
  // =====================
  static const primary = Color(0xFF2563EB);
  static const primaryDark = Color(0xFF1E40AF);
  static const primaryLight = Color(0xFF93C5FD);
  static const primaryContainer = Color(0xFFDBEAFE);
  static const onPrimaryContainer = Color(0xFF0B1F5E);
  static const primaryContainerDark = Color(0xFF1E3A8A);

  // =====================
  // 🟢 SECONDARY (Patrimônio)
  // =====================
  static const secondary = Color(0xFF16A34A);
  static const secondaryLight = Color(0xFFDCFCE7);
  static const secondaryDark = Color(0xFF14532D);
  static const secondaryDarkStrong = Color(0xFF166534);
  static const darkSecondary = Color(0xFF22C55E);

  // =====================
  // ✅ SUCCESS
  // =====================
  static const success = Color(0xFF22C55E);
  static const successDark = Color(0xFF166534);
  static const successLight = Color(0xFFDCFCE7);

  // =====================
  // ❌ ERROR
  // =====================
  static const error = Color(0xFFEF4444);
  static const errorLight = Color(0xFFFEE2E2);
  static const errorDark = Color(0xFF991B1B);
  static const errorContainerDark = Color(0xFF7F1D1D);

  // =====================
  // ⚪ LIGHT NEUTRALS
  // =====================
  static const background = Color(0xFFF8FAFC);
  static const surface = Colors.white;
  static const border = Color(0xFFE5E7EB);

  static const textPrimary = Color(0xFF0F172A);
  static const textSecondary = Color(0xFF475569);
  static const textDisabled = Color(0xFF94A3B8);

  // =====================
  // 🌙 DARK MODE
  // =====================
  static const darkBackground = Color(0xFF020617);
  static const darkSurface = Color(0xFF0F172A);
  static const darkCard = Color(0xFF111827);
  static const darkBorder = Color(0xFF1F2937);

  static const darkTextPrimary = Color(0xFFF8FAFC);
  static const darkTextSecondary = Color(0xFFCBD5F5);

  // Inverse / utility
  static const inversePrimary = Color(0xFF93C5FD);
  static const darkInversePrimary = Color(0xFF2563EB);

  // Dark primaries
  static const darkPrimary = Color(0xFF3B82F6);
  static const darkSuccess = Color(0xFF4ADE80);
  static const darkError = Color(0xFFF87171);
}
