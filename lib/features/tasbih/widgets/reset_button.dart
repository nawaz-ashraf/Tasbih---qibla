// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/features/tasbih/widgets/reset_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class ResetButton extends StatelessWidget {
  const ResetButton({super.key, required this.onConfirm});

  final Future<void> Function() onConfirm;

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return Center(
      child: NeumorphicButton(
        onPressed: () async {
          final bool shouldReset = await _showResetDialog(context);
          if (shouldReset) {
            await onConfirm();
          }
        },
        style: NeumorphicStyle(
          depth: 3,
          shape: NeumorphicShape.convex,
          boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(18)),
          color: NeumorphicTheme.baseColor(context),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.refresh_rounded,
              color: AppColors.textSecondary(isDark),
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              AppStrings.reset,
              style: GoogleFonts.inter(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _showResetDialog(BuildContext context) async {
    final bool? accepted = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        final bool isDark = NeumorphicTheme.isUsingDark(dialogContext);

        return Dialog(
          backgroundColor: AppColors.transparent,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: 6,
              shape: NeumorphicShape.convex,
              boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)),
              color: NeumorphicTheme.baseColor(dialogContext),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    AppStrings.resetDialogTitle,
                    style: GoogleFonts.inter(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.resetDialogMessage,
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary(isDark),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      NeumorphicButton(
                        onPressed: () => Navigator.of(dialogContext).pop(false),
                        style: NeumorphicStyle(
                          depth: 3,
                          shape: NeumorphicShape.convex,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(14),
                          ),
                          color: NeumorphicTheme.baseColor(dialogContext),
                        ),
                        child: Text(
                          AppStrings.cancel,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary(isDark),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      NeumorphicButton(
                        onPressed: () => Navigator.of(dialogContext).pop(true),
                        style: NeumorphicStyle(
                          depth: -3,
                          shape: NeumorphicShape.concave,
                          boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(14),
                          ),
                          color: AppColors.accentGreen,
                        ),
                        child: Text(
                          AppStrings.confirm,
                          style: GoogleFonts.inter(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

    return accepted ?? false;
  }
}
