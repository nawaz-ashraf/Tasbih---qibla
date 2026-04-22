import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../services/qibla_calculator.dart';
import 'compass_needle.dart';

class QiblaCompass extends StatefulWidget {
  const QiblaCompass({super.key, required this.reading});

  final QiblaReading reading;

  @override
  State<QiblaCompass> createState() => _QiblaCompassState();
}

class _QiblaCompassState extends State<QiblaCompass> {
  double _prevCompassDeg = 0;
  double _prevNeedleDeg = 0;

  double _lerpAngle(double from, double to) {
    final double diff = (to - from + 540) % 360 - 180;
    return from + diff;
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    final double targetCompassDeg = -widget.reading.deviceHeading;
    final double targetNeedleDeg = widget.reading.qiblaBearing;

    final double compassEnd = _lerpAngle(_prevCompassDeg, targetCompassDeg);
    final double needleEnd = _lerpAngle(_prevNeedleDeg, targetNeedleDeg);

    return SizedBox(
      width: 280,
      height: 280,
      child: Neumorphic(
        style: NeumorphicStyle(
          depth: 6,
          shape: NeumorphicShape.convex,
          boxShape: const NeumorphicBoxShape.circle(),
          color: NeumorphicTheme.baseColor(context),
        ),
        padding: const EdgeInsets.all(12),
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Neumorphic(
              style: NeumorphicStyle(
                depth: -6,
                shape: NeumorphicShape.concave,
                boxShape: const NeumorphicBoxShape.circle(),
                color: NeumorphicTheme.baseColor(context),
              ),
              child: const SizedBox(width: 250, height: 250),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: _prevCompassDeg, end: compassEnd),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (
                BuildContext context,
                double angleDeg,
                Widget? child,
              ) {
                _prevCompassDeg = angleDeg;
                final double angleRad = angleDeg * (math.pi / 180);
                return Transform.rotate(angle: angleRad, child: child);
              },
              child: CustomPaint(
                size: const Size.square(230),
                painter: _CompassRosePainter(isDark: isDark),
              ),
            ),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: _prevNeedleDeg, end: needleEnd),
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
              builder: (
                BuildContext context,
                double angleDeg,
                Widget? child,
              ) {
                _prevNeedleDeg = angleDeg;
                final double angleRad = angleDeg * (math.pi / 180);
                return Transform.rotate(angle: angleRad, child: child);
              },
              child: const CompassNeedle(size: 220),
            ),
            Container(
              width: 14,
              height: 14,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.compassCenterDot,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompassRosePainter extends CustomPainter {
  _CompassRosePainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = size.width / 2;

    final Paint ringPaint = Paint()
      ..color = AppColors.compassTick(isDark).withOpacity(0.45)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.3;

    canvas.drawCircle(center, radius - 6, ringPaint);

    for (int degree = 0; degree < 360; degree += 15) {
      final double rad = degree * math.pi / 180;
      final bool major = degree % 90 == 0;
      final double outer = radius - 10;
      final double inner = major ? radius - 26 : radius - 18;

      final Offset p1 = Offset(
        center.dx + outer * math.cos(rad),
        center.dy + outer * math.sin(rad),
      );
      final Offset p2 = Offset(
        center.dx + inner * math.cos(rad),
        center.dy + inner * math.sin(rad),
      );

      canvas.drawLine(
        p1,
        p2,
        Paint()
          ..color = AppColors.compassTick(isDark)
          ..strokeWidth = major ? 2.1 : 1.1,
      );
    }

    _drawLabel(
      canvas: canvas,
      center: center,
      radius: radius,
      angleDegree: 270,
      text: AppStrings.directionNorth,
      color: AppColors.accentGreen,
    );
    _drawLabel(
      canvas: canvas,
      center: center,
      radius: radius,
      angleDegree: 0,
      text: AppStrings.directionEast,
      color: AppColors.textPrimary(isDark),
    );
    _drawLabel(
      canvas: canvas,
      center: center,
      radius: radius,
      angleDegree: 90,
      text: AppStrings.directionSouth,
      color: AppColors.textPrimary(isDark),
    );
    _drawLabel(
      canvas: canvas,
      center: center,
      radius: radius,
      angleDegree: 180,
      text: AppStrings.directionWest,
      color: AppColors.textPrimary(isDark),
    );
  }

  void _drawLabel({
    required Canvas canvas,
    required Offset center,
    required double radius,
    required double angleDegree,
    required String text,
    required Color color,
  }) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: GoogleFonts.inter(
          color: color,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final double rad = angleDegree * math.pi / 180;
    final double labelRadius = radius - 38;

    final Offset offset = Offset(
      center.dx + labelRadius * math.cos(rad) - (painter.width / 2),
      center.dy + labelRadius * math.sin(rad) - (painter.height / 2),
    );

    painter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _CompassRosePainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
