import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends ChangeNotifier {
  static String get _bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4392358942856616/5366391830';
    }
    return 'ca-app-pub-4392358942856616/5366391830'; // iOS placeholder
  }

  static String get _interstitialAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4392358942856616/3311074132';
    }
    return 'ca-app-pub-4392358942856616/3311074132'; // iOS placeholder
  }

  static String get _appOpenAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-4392358942856616/2081752943';
    }
    return 'ca-app-pub-4392358942856616/2081752943'; // iOS placeholder
  }

  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoaded = false;

  AppOpenAd? _appOpenAd;
  bool _isAppOpenLoaded = false;
  bool _isShowingAppOpenAd = false;
  bool _hasShownAppOpenThisSession = false;

  int _resetCount = 0;
  bool _initialized = false;

  bool get isBannerLoaded => _isBannerLoaded;
  BannerAd? get bannerAd => _bannerAd;

  Future<void> initialize() async {
    if (_initialized) {
      return;
    }

    await MobileAds.instance.initialize();

    final ConsentRequestParameters params = ConsentRequestParameters();

    ConsentInformation.instance.requestConsentInfoUpdate(
      params,
      () async {
        if (await ConsentInformation.instance.isConsentFormAvailable()) {
          ConsentForm.loadAndShowConsentFormIfRequired((FormError? error) {
            if (error != null) {
              debugPrint('Consent form error: ${error.message}');
            }
            loadBannerAd();
            loadInterstitialAd();
            loadAppOpenAd();
          });
          return;
        }

        loadBannerAd();
        loadInterstitialAd();
        loadAppOpenAd();
      },
      (FormError error) {
        debugPrint('Consent update error: ${error.message}');
        loadBannerAd();
        loadInterstitialAd();
        loadAppOpenAd();
      },
    );

    _initialized = true;
  }

  void loadBannerAd({VoidCallback? onLoaded}) {
    _bannerAd?.dispose();
    _isBannerLoaded = false;
    notifyListeners();

    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (Ad ad) {
          _isBannerLoaded = true;
          notifyListeners();
          onLoaded?.call();
          debugPrint('✓ Banner ad loaded');
        },
        onAdFailedToLoad: (Ad ad, LoadAdError error) {
          _isBannerLoaded = false;
          notifyListeners();
          ad.dispose();
          debugPrint('✗ Banner ad failed: ${error.message}');
          Future<void>.delayed(
            const Duration(seconds: 30),
            () => loadBannerAd(),
          );
        },
      ),
    );

    _bannerAd!.load();
  }

  Widget buildBannerWidget() {
    if (!_isBannerLoaded || _bannerAd == null) {
      return const SizedBox(height: 50);
    }

    return SizedBox(
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }

  void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          _interstitialAd = ad;
          _isInterstitialLoaded = true;
          debugPrint('✓ Interstitial ad loaded');

          _interstitialAd!.fullScreenContentCallback =
              FullScreenContentCallback(
            onAdDismissedFullScreenContent: (Ad ad) {
              ad.dispose();
              _isInterstitialLoaded = false;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
              ad.dispose();
              _isInterstitialLoaded = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isInterstitialLoaded = false;
          debugPrint('✗ Interstitial failed: ${error.message}');
          Future<void>.delayed(const Duration(seconds: 30), loadInterstitialAd);
        },
      ),
    );
  }

  void onCounterReset() {
    _resetCount += 1;
    if (_resetCount % 10 == 0) {
      showInterstitialAd();
    }
  }

  void showInterstitialAd() {
    if (_isInterstitialLoaded && _interstitialAd != null) {
      _interstitialAd!.show();
    }
  }

  void loadAppOpenAd() {
    AppOpenAd.load(
      adUnitId: _appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (AppOpenAd ad) {
          _appOpenAd = ad;
          _isAppOpenLoaded = true;
          debugPrint('✓ App Open ad loaded');

          _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdShowedFullScreenContent: (Ad ad) {
              _isShowingAppOpenAd = true;
            },
            onAdDismissedFullScreenContent: (Ad ad) {
              _isShowingAppOpenAd = false;
              _isAppOpenLoaded = false;
              ad.dispose();
              loadAppOpenAd();
            },
            onAdFailedToShowFullScreenContent: (Ad ad, AdError error) {
              _isShowingAppOpenAd = false;
              _isAppOpenLoaded = false;
              ad.dispose();
              loadAppOpenAd();
            },
          );
        },
        onAdFailedToLoad: (LoadAdError error) {
          _isAppOpenLoaded = false;
          debugPrint('✗ App Open ad failed: ${error.message}');
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable() {
    if (_hasShownAppOpenThisSession ||
        !_isAppOpenLoaded ||
        _isShowingAppOpenAd) {
      return;
    }

    _hasShownAppOpenThisSession = true;
    _appOpenAd?.show();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _interstitialAd?.dispose();
    _appOpenAd?.dispose();
    super.dispose();
  }
}

final AdService adService = AdService();
