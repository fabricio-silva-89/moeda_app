import 'package:flutter/material.dart';

import 'ma_colors.dart';

/// ===============================
/// 🎨 COLORS ACCESSOR
/// ===============================
class MaColorTokens {
  final Color primary;
  final Color secondary;
  final Color success;
  final Color error;
  final Color errorContainerDark;

  final Color background;
  final Color surface;
  final Color border;

  final Color textPrimary;
  final Color textSecondary;

  const MaColorTokens({
    required this.primary,
    required this.secondary,
    required this.success,
    required this.error,
    required this.errorContainerDark,
    required this.background,
    required this.surface,
    required this.border,
    required this.textPrimary,
    required this.textSecondary,
  });
}

/// ===============================
/// 🧠 BUILD CONTEXT EXTENSIONS
/// ===============================
extension MaBuildContextX on BuildContext {
  /// Shortcut ThemeData
  ThemeData get theme => Theme.of(this);

  /// Shortcut ColorScheme (Material 3)
  ColorScheme get scheme => theme.colorScheme;

  /// Shortcut TextTheme
  TextTheme get text => theme.textTheme;

  /// Detect dark mode
  bool get isDark => theme.brightness == Brightness.dark;

  /// ===============================
  /// 🎨 DESIGN TOKENS
  /// ===============================
  MaColorTokens get colors {
    if (isDark) {
      return const MaColorTokens(
        primary: MaColors.darkPrimary,
        secondary: MaColors.secondary,
        success: MaColors.darkSuccess,
        error: MaColors.darkError,
        errorContainerDark: MaColors.errorContainerDark,
        background: MaColors.darkBackground,
        surface: MaColors.darkSurface,
        border: MaColors.darkBorder,
        textPrimary: MaColors.darkTextPrimary,
        textSecondary: MaColors.darkTextSecondary,
      );
    }

    return const MaColorTokens(
      primary: MaColors.primary,
      secondary: MaColors.secondary,
      success: MaColors.success,
      error: MaColors.error,
      errorContainerDark: MaColors.errorContainerDark,
      background: MaColors.background,
      surface: MaColors.surface,
      border: MaColors.border,
      textPrimary: MaColors.textPrimary,
      textSecondary: MaColors.textSecondary,
    );
  }
}
