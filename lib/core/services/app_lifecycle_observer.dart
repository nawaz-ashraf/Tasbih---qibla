import 'package:flutter/material.dart';

import 'ad_service.dart';

class AppLifecycleObserver with WidgetsBindingObserver {
  bool _isFirstLaunch = true;

  void init() {
    WidgetsBinding.instance.addObserver(this);
  }

  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      if (_isFirstLaunch) {
        _isFirstLaunch = false;
        return;
      }

      Future<void>.delayed(const Duration(milliseconds: 800), () {
        adService.showAppOpenAdIfAvailable();
      });
    }
  }
}

final AppLifecycleObserver appLifecycleObserver = AppLifecycleObserver();
