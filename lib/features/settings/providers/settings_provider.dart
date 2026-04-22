import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../../../core/theme/theme_provider.dart';

class SettingsProvider extends ChangeNotifier {
  SettingsProvider();

  bool _vibrationEnabled = true;
  bool _soundEnabled = true;
  bool _nightMode = false;
  bool _keepScreenOn = true;
  bool _speechEnabled = false;

  final AudioPlayer _audioPlayer = AudioPlayer();
  final FlutterTts _tts = FlutterTts();

  bool get vibrationEnabled => _vibrationEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get nightMode => _nightMode;
  bool get keepScreenOn => _keepScreenOn;
  bool get speechEnabled => _speechEnabled;

  static const String _kVibration = 'setting_vibration';
  static const String _kSound = 'setting_sound';
  static const String _kNightMode = 'setting_night_mode';
  static const String _kKeepScreen = 'setting_keep_screen';
  static const String _kSpeech = 'setting_speech';

  Future<void> loadSettings() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    _vibrationEnabled = prefs.getBool(_kVibration) ?? true;
    _soundEnabled = prefs.getBool(_kSound) ?? true;
    _nightMode = prefs.getBool(_kNightMode) ?? false;
    _keepScreenOn = prefs.getBool(_kKeepScreen) ?? true;
    _speechEnabled = prefs.getBool(_kSpeech) ?? false;

    await _applyKeepScreen();
    notifyListeners();
  }

  Future<void> toggleVibration() async {
    _vibrationEnabled = !_vibrationEnabled;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kVibration, _vibrationEnabled);
    notifyListeners();
  }

  Future<void> toggleSound() async {
    _soundEnabled = !_soundEnabled;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSound, _soundEnabled);
    notifyListeners();
  }

  Future<void> toggleNightMode(BuildContext context) async {
    _nightMode = !_nightMode;
    final ThemeProvider themeProvider = context.read<ThemeProvider>();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kNightMode, _nightMode);

    await themeProvider.setTheme(
      _nightMode ? ThemeMode.dark : ThemeMode.light,
    );

    notifyListeners();
  }

  Future<void> toggleKeepScreen() async {
    _keepScreenOn = !_keepScreenOn;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kKeepScreen, _keepScreenOn);

    await _applyKeepScreen();
    notifyListeners();
  }

  Future<void> toggleSpeech() async {
    _speechEnabled = !_speechEnabled;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_kSpeech, _speechEnabled);
    notifyListeners();
  }

  Future<void> _applyKeepScreen() async {
    if (_keepScreenOn) {
      await WakelockPlus.enable();
      return;
    }
    await WakelockPlus.disable();
  }

  Future<void> playClickSound() async {
    if (!_soundEnabled) {
      return;
    }

    try {
      await _audioPlayer.stop();
      await _audioPlayer.play(AssetSource('sounds/click.mp3'));
    } catch (_) {
      // Ignore sound playback failures gracefully.
    }
  }

  Future<void> speakDhikr(String arabicText, String transliteration) async {
    if (!_speechEnabled) {
      return;
    }

    final String text = arabicText.trim().isNotEmpty
        ? arabicText.trim()
        : transliteration.trim();

    if (text.isEmpty) {
      return;
    }

    try {
      await _tts.stop();
      await _tts.setLanguage('ar-SA');
      await _tts.setSpeechRate(0.4);
      await _tts.setPitch(1.0);
      await _tts.speak(text);
    } catch (_) {
      // Ignore TTS failures gracefully.
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _tts.stop();
    super.dispose();
  }
}
