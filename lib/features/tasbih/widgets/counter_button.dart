// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/features/tasbih/widgets/counter_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import '../../../core/constants/app_colors.dart';

class CounterButton extends StatefulWidget {
  const CounterButton({
    super.key,
    required this.onTap,
    required this.child,
    this.size = 180,
    this.flash = false,
  });

  final VoidCallback onTap;
  final Widget child;
  final double size;
  final bool flash;

  @override
  State<CounterButton> createState() => _CounterButtonState();
}

class _CounterButtonState extends State<CounterButton> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed == value) {
      return;
    }
    setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = NeumorphicTheme.isUsingDark(context);

    return GestureDetector(
      onTapDown: (_) => _setPressed(true),
      onTapUp: (_) => _setPressed(false),
      onTapCancel: () => _setPressed(false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: widget.flash
                ? <BoxShadow>[
                    BoxShadow(
                      color: AppColors.accentGreen.withOpacity(
                        isDark ? 0.45 : 0.32,
                      ),
                      blurRadius: 26,
                      spreadRadius: 1,
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Neumorphic(
            style: NeumorphicStyle(
              depth: _pressed ? -4 : 6,
              shape: _pressed
                  ? NeumorphicShape.concave
                  : NeumorphicShape.convex,
              boxShape: const NeumorphicBoxShape.circle(),
              color: NeumorphicTheme.baseColor(context),
            ),
            child: SizedBox(
              width: widget.size,
              height: widget.size,
              child: Center(child: widget.child),
            ),
          ),
        ),
      ),
    );
  }
}
