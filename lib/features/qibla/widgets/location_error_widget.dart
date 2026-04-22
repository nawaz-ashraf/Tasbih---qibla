// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/features/qibla/widgets/location_error_widget.dart
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';

class LocationErrorWidget extends StatelessWidget {
  const LocationErrorWidget({
    super.key,
    required this.icon,
    required this.message,
    required this.actionLabel,
    required this.onAction,
    this.secondaryActionLabel,
    this.onSecondaryAction,
  });

  final IconData icon;
  final String message;
  final String actionLabel;
  final VoidCallback onAction;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryAction;

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Neumorphic(
              style: NeumorphicStyle(
                depth: 5,
                shape: NeumorphicShape.convex,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(20),
                ),
                color: NeumorphicTheme.baseColor(context),
              ),
              padding: const EdgeInsets.all(18),
              child: Column(
                children: <Widget>[
                  Icon(icon, size: 34, color: AppColors.warning),
                  const SizedBox(height: 10),
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            NeumorphicButton(
              onPressed: onAction,
              style: NeumorphicStyle(
                depth: -3,
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.roundRect(
                  BorderRadius.circular(16),
                ),
                color: AppColors.accentGreen,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Text(
                actionLabel,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.white,
                ),
              ),
            ),
            if (secondaryActionLabel != null && onSecondaryAction != null)
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: NeumorphicButton(
                  onPressed: onSecondaryAction,
                  style: NeumorphicStyle(
                    depth: 3,
                    shape: NeumorphicShape.convex,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(16),
                    ),
                    color: NeumorphicTheme.baseColor(context),
                  ),
                  child: Text(
                    secondaryActionLabel!,
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary(isDark),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
