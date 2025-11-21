import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdService {
  static final AppOpenAdService _instance = AppOpenAdService._internal();
  factory AppOpenAdService() => _instance;

  AppOpenAdService._internal();

  AppOpenAd? _appOpenAd;
  bool _isShowingAd = false;
  bool _isLoading = false;

  final String adUnitId = "ca-app-pub-2590111716650280/4670010385";
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

  void showAdIfAvailable() {
    if (_appOpenAd == null) return;
    if (_isShowingAd) return;

    _isShowingAd = true;

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAd = false;
        _appOpenAd = null;
        loadAd(); // Load next ad immediately
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAd = false;
        _appOpenAd = null;
        loadAd();
      },
    );

    _appOpenAd!.show();
  }
}
