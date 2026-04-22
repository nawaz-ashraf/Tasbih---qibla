// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/features/tasbih/providers/tasbih_provider.dart
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/constants/dhikr_data.dart';
import '../../../core/services/ad_service.dart';
import '../../../core/utils/haptic_helper.dart';
import '../../settings/providers/settings_provider.dart';

class TasbihProvider extends ChangeNotifier {
  TasbihProvider(this._settingsProvider);

  static const int infiniteTarget = 0;

  static const String _countKey = 'tasbih_count';
  static const String _targetKey = 'tasbih_target';
  static const String _dhikrKey = 'tasbih_dhikr_id';

  int _count = 0;
  int _target = 33;
  DhikrModel _selectedDhikr = dhikrList.first;
  bool _targetReached = false;
  bool _isCustomTarget = false;

  SharedPreferences? _prefs;
  final SettingsProvider _settingsProvider;

  int get count => _count;
  int get target => _target;
  DhikrModel get selectedDhikr => _selectedDhikr;
  bool get targetReached => _targetReached;
  bool get isCustomTarget => _isCustomTarget;

  double get progress {
    if (_target <= 0) {
      return 0;
    }
    return (_count / _target).clamp(0.0, 1.0);
  }

  Future<void> loadState() async {
    _prefs ??= await SharedPreferences.getInstance();

    _count = _prefs?.getInt(_countKey) ?? 0;
    _target = _prefs?.getInt(_targetKey) ?? 33;

    final int savedDhikrId = _prefs?.getInt(_dhikrKey) ?? dhikrList.first.id;
    _selectedDhikr = dhikrList.firstWhere(
      (DhikrModel dhikr) => dhikr.id == savedDhikrId,
      orElse: () => dhikrList.first,
    );

    _isCustomTarget = _target > 0 && !_isPresetTarget(_target);
    _targetReached = false;
    notifyListeners();
  }

  Future<void> increment() async {
    _count += 1;
    _targetReached = false;

    if (_settingsProvider.vibrationEnabled) {
      await HapticHelper.lightTap();
    }

    if (_settingsProvider.soundEnabled) {
      await _settingsProvider.playClickSound();
    }

    if (_target > 0 && _count >= _target) {
      _targetReached = true;
      if (_settingsProvider.vibrationEnabled) {
        await HapticHelper.targetReached();
      }
    }

    notifyListeners();
    await _persist();
  }

  Future<void> reset() async {
    _count = 0;
    _targetReached = false;
    notifyListeners();
    adService.onCounterReset();
    await _persist();
  }

  Future<void> setTarget(int target) async {
    _target = target <= 0 ? infiniteTarget : target;
    _isCustomTarget = false;
    _count = 0;
    _targetReached = false;
    notifyListeners();
    await _persist();
  }

  Future<void> setCustomTarget(int customValue) async {
    if (customValue <= 0) {
      return;
    }

    _target = customValue;
    _isCustomTarget = true;
    _count = 0;
    _targetReached = false;
    notifyListeners();
    await _persist();
  }

  Future<void> setDhikr(DhikrModel dhikr) async {
    _selectedDhikr = dhikr;
    _count = 0;
    _targetReached = false;
    notifyListeners();
    await _settingsProvider.speakDhikr(
      _selectedDhikr.arabic,
      _selectedDhikr.transliteration,
    );
    await _persist();
  }

  void clearTargetReached() {
    if (!_targetReached) {
      return;
    }

    _targetReached = false;
    notifyListeners();
  }

  Future<void> _persist() async {
    _prefs ??= await SharedPreferences.getInstance();
    await _prefs?.setInt(_countKey, _count);
    await _prefs?.setInt(_targetKey, _target);
    await _prefs?.setInt(_dhikrKey, _selectedDhikr.id);
  }

  bool _isPresetTarget(int value) {
    return value == 33 || value == 99 || value == 100;
  }
}
