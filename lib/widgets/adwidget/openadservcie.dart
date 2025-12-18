import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdService {
  static final AppOpenAdService _instance = AppOpenAdService._internal();
  factory AppOpenAdService() => _instance;

  AppOpenAdService._internal();

  static bool isReelsScreenOpen = false; // 🔥 reels guard

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  bool _isLoading = false;

  final String adUnitId = "ca-app-pub-2590111716650280/4670010385";

  /// Load Open App Ad
  void loadAd() {
    if (_isLoading) return;

    _isLoading = true;

    AppOpenAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          _isLoading = false;
        },
      ),
    );
  }

  /// Show Open App Ad if available
  void showAdIfAvailable({required void Function() onComplete}) {
    // ❌ reels ke beech open ad nahi
    if (isReelsScreenOpen) {
      onComplete();
      return;
    }

    if (_appOpenAd == null) {
      onComplete();
      return;
    }

    if (_isShowingAd) {
      onComplete();
      return;
    }

    _isShowingAd = true;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        _appOpenAd = null;
        loadAd(); // preload next
        onComplete();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        _appOpenAd = null;
        loadAd();
        onComplete();
      },
    );

    _appOpenAd!.show();
  }
}
