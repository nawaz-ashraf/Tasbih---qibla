// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/core/theme/app_theme.dart
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../constants/app_colors.dart';

class AppTheme {
  AppTheme._();

  static const Duration quickDuration = Duration(milliseconds: 150);

  static NeumorphicThemeData get lightTheme {
    final TextTheme interTextTheme =
        GoogleFonts.interTextTheme(ThemeData.light().textTheme).apply(
          bodyColor: AppColors.lightTextPrimary,
          displayColor: AppColors.lightTextPrimary,
        );

    return NeumorphicThemeData(
      baseColor: AppColors.lightBase,
      accentColor: AppColors.accentGreen,
      defaultTextColor: AppColors.lightTextPrimary,
      variantColor: AppColors.lightTextSecondary,
      shadowDarkColor: AppColors.lightShadowDark,
      shadowLightColor: AppColors.lightShadowLight,
      lightSource: LightSource.topLeft,
      depth: 6,
      intensity: 0.65,
      textTheme: interTextTheme,
      iconTheme: const IconThemeData(color: AppColors.lightTextPrimary),
    );
  }

  static NeumorphicThemeData get darkTheme {
    final TextTheme interTextTheme =
        GoogleFonts.interTextTheme(ThemeData.dark().textTheme).apply(
          bodyColor: AppColors.darkTextPrimary,
          displayColor: AppColors.darkTextPrimary,
        );

    return NeumorphicThemeData(
      baseColor: AppColors.darkBase,
      accentColor: AppColors.accentGreen,
      defaultTextColor: AppColors.darkTextPrimary,
      variantColor: AppColors.darkTextSecondary,
      shadowDarkColor: AppColors.darkShadowDark,
      shadowLightColor: AppColors.darkShadowLight,
      lightSource: LightSource.topLeft,
      depth: 5,
      intensity: 0.5,
      textTheme: interTextTheme,
      iconTheme: const IconThemeData(color: AppColors.darkTextPrimary),
    );
  }
}
