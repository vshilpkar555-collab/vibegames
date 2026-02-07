
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService {
  // TODO: Replace with your own Test ad unit IDs.
  // static final String bannerAdUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/6300978111'
  //     : 'ca-app-pub-3940256099942544/2934735716';
  // static final String interstitialAdUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/1033173712'
  //     : 'ca-app-pub-3940256099942544/4411468910';
  // static final String appOpenAdUnitId = Platform.isAndroid
  //     ? 'ca-app-pub-3940256099942544/9257395921'
  //     : 'ca-app-pub-3940256099942544/5662855259';
  // TODO: Replace with your own production ad unit IDs.
  static final String bannerAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-4609189373682977/6868629129'
      : 'ca-app-pub-3940256099942544/2934735716';
  static final String interstitialAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-4609189373682977/9303220779'
      : 'ca-app-pub-3940256099942544/4411468910';
  static final String appOpenAdUnitId = Platform.isAndroid
      ? 'ca-app-pub-4609189373682977/7990139106'
      : 'ca-app-pub-3940256099942544/5662855259';



  AppOpenAd? _appOpenAd;
  bool _isShowingAppOpenAd = false;
  int _gamePlayCount = 0;
  InterstitialAd? _interstitialAd;
  bool _isInterstitialAdReady = false;

  void loadAppOpenAd() {
    // Return if an ad is already loaded or being shown
    if (_appOpenAd != null || _isShowingAppOpenAd) {
      return;
    }

    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          if (kDebugMode) {
            print('AppOpenAd loaded.');
          }
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          if (kDebugMode) {
            print('AppOpenAd failed to load: \$error');
          }
        },
      ),
    );
  }

  void showAppOpenAd() {
    if (_appOpenAd == null || _isShowingAppOpenAd) {
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAppOpenAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        if (kDebugMode) {
          print('AppOpenAd failed to show: \$error');
        }
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }

  void loadInterstitialAd() {
    // Return if an ad is already loaded
    if (_interstitialAd != null) {
      return;
    }

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          if (kDebugMode) {
            print('InterstitialAd loaded.');
          }
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          if (kDebugMode) {
            print('InterstitialAd failed to load: \$error');
          }
        },
      ),
    );
  }

  void showInterstitialAd() {
    _gamePlayCount++;
    if (_gamePlayCount % 2 == 0 && _isInterstitialAdReady && _interstitialAd != null) {
      _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          loadInterstitialAd();
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _interstitialAd = null;
          _isInterstitialAdReady = false;
          loadInterstitialAd();
          if (kDebugMode) {
            print('InterstitialAd failed to show: \$error');
          }
        },
      );
      _interstitialAd!.show();
      _isInterstitialAdReady = false;
    }
  }

  void dispose() {
    _appOpenAd?.dispose();
    _interstitialAd?.dispose();
  }
}
