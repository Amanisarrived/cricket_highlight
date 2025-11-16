import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialService {
  static InterstitialAd? _ad;
  static bool _isReady = false;

  static const String adUnitId =
      "ca-app-pub-3940256099942544/1033173712";

  static void load() {
    InterstitialAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _isReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              load(); // auto reload
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              load();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _isReady = false;
        },
      ),
    );
  }

  static void showAdIfReady({required Function onComplete}) {
    if (_isReady && _ad != null) {
      _ad!.show();
      _isReady = false;

      Future.delayed(const Duration(milliseconds: 300), () {
        onComplete();
      });
    } else {
      onComplete();
      load();
    }
  }
}
