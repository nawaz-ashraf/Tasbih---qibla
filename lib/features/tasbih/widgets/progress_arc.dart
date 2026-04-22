// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/features/tasbih/widgets/progress_arc.dart
import 'dart:math' as math;

import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import 'counter_button.dart';

class ProgressArc extends StatelessWidget {
  const ProgressArc({
    super.key,
    required this.progress,
    required this.count,
    required this.target,
    required this.onTap,
    required this.flashGoal,
  });

  final double progress;
  final int count;
  final int target;
  final VoidCallback onTap;
  final bool flashGoal;

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return SizedBox(
      width: 240,
      height: 240,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: const Size.square(240),
            painter: _ProgressArcPainter(progress: progress, isDark: isDark),
          ),
          CounterButton(
            onTap: onTap,
            size: 180,
            flash: flashGoal,
            child: const SizedBox.shrink(),
          ),
          IgnorePointer(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder:
                      (Widget child, Animation<double> animation) {
                    return ScaleTransition(scale: animation, child: child);
                  },
                  child: Text(
                    '$count',
                    key: ValueKey<int>(count),
                    style: GoogleFonts.inter(
                      fontSize: 64,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary(isDark),
                    ),
                  ),
                ),
                Text(
                  AppStrings.targetText(target),
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary(isDark),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressArcPainter extends CustomPainter {
  _ProgressArcPainter({required this.progress, required this.isDark});

  final double progress;
  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final double strokeWidth = 12;
    final Rect arcRect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: (size.width / 2) - strokeWidth,
    );

    final Paint basePaint = Paint()
      ..color = AppColors.compassTick(isDark).withOpacity(0.35)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    final Paint progressPaint = Paint()
      ..color = AppColors.accentGreen
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    const double startAngle = -math.pi / 2;
    const double fullSweep = 2 * math.pi;

    canvas.drawArc(arcRect, startAngle, fullSweep, false, basePaint);
    canvas.drawArc(
      arcRect,
      startAngle,
      fullSweep * progress.clamp(0, 1),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _ProgressArcPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.isDark != isDark;
  }
}
