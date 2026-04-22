// /Users/nawazashraf/Downloads/nawaz/Nawaz2/project/Tasbih & qibla/lib/main.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'core/services/ad_service.dart';
import 'core/services/app_lifecycle_observer.dart';
import 'core/theme/theme_provider.dart';
import 'features/qibla/providers/qibla_provider.dart';
import 'features/settings/providers/settings_provider.dart';
import 'features/tasbih/providers/tasbih_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await adService.initialize();
  appLifecycleObserver.init();

  final ThemeProvider themeProvider = ThemeProvider();
  final SettingsProvider settingsProvider = SettingsProvider();
  final TasbihProvider tasbihProvider = TasbihProvider(settingsProvider);
  final QiblaProvider qiblaProvider = QiblaProvider();

  await Future.wait(<Future<void>>[
    themeProvider.loadTheme(),
    settingsProvider.loadSettings(),
    tasbihProvider.loadState(),
    qiblaProvider.initialize(),
  ]);

  await themeProvider.setTheme(
    settingsProvider.nightMode ? ThemeMode.dark : ThemeMode.light,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeProvider>.value(value: themeProvider),
        ChangeNotifierProvider<SettingsProvider>.value(value: settingsProvider),
        ChangeNotifierProvider<TasbihProvider>.value(value: tasbihProvider),
        ChangeNotifierProvider<QiblaProvider>.value(value: qiblaProvider),
      ],
      child: const TasbihQiblaApp(),
    ),
  );

  WidgetsBinding.instance.addPostFrameCallback((_) {
    Future<void>.delayed(const Duration(milliseconds: 1200), () {
      adService.showAppOpenAdIfAvailable();
    });
  });
}
