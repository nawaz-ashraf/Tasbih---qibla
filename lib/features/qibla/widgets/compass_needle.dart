// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/features/qibla/widgets/compass_needle.dart
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';

class CompassNeedle extends StatelessWidget {
  const CompassNeedle({super.key, this.size = 220});

  final double size;

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          CustomPaint(
            size: Size.square(size),
            painter: _NeedlePainter(isDark: isDark),
          ),
          Align(
            alignment: const Alignment(0, -0.83),
            child: Text(
              AppStrings.kaabaEmoji,
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ],
      ),
    );
  }
}

class _NeedlePainter extends CustomPainter {
  _NeedlePainter({required this.isDark});

  final bool isDark;

  @override
  void paint(Canvas canvas, Size size) {
    final Offset center = Offset(size.width / 2, size.height / 2);

    final Paint shaftPaint = Paint()
      ..color = AppColors.goldNeedle
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;

    final Paint headPaint = Paint()
      ..color = AppColors.goldNeedle
      ..style = PaintingStyle.fill;

    final Paint tailPaint = Paint()
      ..color = AppColors.textSecondary(isDark).withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final Offset shaftTop = Offset(center.dx, size.height * 0.21);
    final Offset shaftBottom = Offset(center.dx, size.height * 0.74);

    canvas.drawLine(shaftBottom, shaftTop, shaftPaint);

    final Path headPath = Path()
      ..moveTo(center.dx, size.height * 0.10)
      ..lineTo(center.dx - size.width * 0.06, size.height * 0.26)
      ..lineTo(center.dx + size.width * 0.06, size.height * 0.26)
      ..close();

    final Path tailPath = Path()
      ..moveTo(center.dx, size.height * 0.90)
      ..lineTo(center.dx - size.width * 0.05, size.height * 0.74)
      ..lineTo(center.dx + size.width * 0.05, size.height * 0.74)
      ..close();

    canvas.drawPath(headPath, headPaint);
    canvas.drawPath(tailPath, tailPaint);

    final Paint centerPaint = Paint()
      ..color = AppColors.goldNeedle
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 6.5, centerPaint);
  }

  @override
  bool shouldRepaint(covariant _NeedlePainter oldDelegate) {
    return oldDelegate.isDark != isDark;
  }
}
