// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/core/utils/haptic_helper.dart
import 'package:flutter/services.dart';
import 'package:vibration/vibration.dart';

class HapticHelper {
  HapticHelper._();

  static Future<void> lightTap() async {
    await HapticFeedback.lightImpact();
  }

  static Future<void> gentle() async {
    final bool hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator) {
      await Vibration.vibrate(duration: 45, amplitude: 40);
      return;
    }

    await HapticFeedback.selectionClick();
  }

  static Future<void> targetReached() async {
    final bool hasVibrator = await Vibration.hasVibrator();
    if (hasVibrator) {
      await Vibration.vibrate(pattern: <int>[0, 100, 50, 200]);
      return;
    }

    await HapticFeedback.heavyImpact();
  }
}
