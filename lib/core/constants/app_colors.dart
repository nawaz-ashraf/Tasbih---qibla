// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/core/constants/app_colors.dart
import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Light Neumorphic palette
  static const Color lightBackground = Color(0xFFE8EAF0);
  static const Color lightBase = Color(0xFFE8EAF0);
  static const Color lightShadowDark = Color(0xFFC8CAD0);
  static const Color lightShadowLight = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF2D3142);
  static const Color lightTextSecondary = Color(0xFF6B7280);

  // Dark Neumorphic palette
  static const Color darkBackground = Color(0xFF1E2130);
  static const Color darkBase = Color(0xFF252839);
  static const Color darkShadowDark = Color(0xFF161824);
  static const Color darkShadowLight = Color(0xFF2E3347);
  static const Color darkTextPrimary = Color(0xFFE8EAF0);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);

  // Shared accents
  static const Color accentGreen = Color(0xFF4CAF82);
  static const Color goldNeedle = Color(0xFFE2B13C);
  static const Color locationPin = Color(0xFFF2B950);
  static const Color inactiveGreyLight = Color(0xFF8E95A6);
  static const Color inactiveGreyDark = Color(0xFF8A92A6);
  static const Color compassTickLight = Color(0xFFBCC1CF);
  static const Color compassTickDark = Color(0xFF48506A);
  static const Color compassCenterDot = Color(0xFF2D3142);
  static const Color snackBarBg = Color(0xFF2D3142);
  static const Color warning = Color(0xFFE09F3E);
  static const Color error = Color(0xFFE35D6A);
  static const Color white = Color(0xFFFFFFFF);
  static const Color transparent = Color(0x00000000);

  static Color textPrimary(bool isDark) =>
      isDark ? darkTextPrimary : lightTextPrimary;

  static Color textSecondary(bool isDark) =>
      isDark ? darkTextSecondary : lightTextSecondary;

  static Color inactive(bool isDark) =>
      isDark ? inactiveGreyDark : inactiveGreyLight;

  static Color compassTick(bool isDark) =>
      isDark ? compassTickDark : compassTickLight;
}
