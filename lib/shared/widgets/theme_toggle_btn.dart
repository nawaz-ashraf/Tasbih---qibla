// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/shared/widgets/theme_toggle_btn.dart
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_provider.dart';

class ThemeToggleButton extends StatelessWidget {
  const ThemeToggleButton({super.key, this.size = 46});

  final double size;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = context.watch<ThemeProvider>();
    final bool isDark = themeProvider.isDark;

    return NeumorphicButton(
      onPressed: themeProvider.toggleTheme,
      minDistance: -1,
      padding: EdgeInsets.zero,
      style: const NeumorphicStyle(
        depth: 4,
        shape: NeumorphicShape.convex,
        boxShape: NeumorphicBoxShape.circle(),
      ),
      child: SizedBox(
        width: size,
        height: size,
        child: Center(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 220),
            transitionBuilder: (Widget child, Animation<double> animation) {
              return FadeTransition(
                opacity: animation,
                child: ScaleTransition(scale: animation, child: child),
              );
            },
            child: Icon(
              isDark ? Icons.nightlight_round : Icons.wb_sunny_rounded,
              key: ValueKey<bool>(isDark),
              color: isDark ? AppColors.darkTextPrimary : AppColors.accentGreen,
              size: 22,
            ),
          ),
        ),
      ),
    );
  }
}
