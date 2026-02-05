import 'package:google_mobile_ads/google_mobile_ads.dart';

class RewardedAdService {
  static RewardedAd? _ad;
  static bool _isReady = false;
  static const String adUnitId =
      "ca-app-pub-2590111716650280/7006352191";

  static void load() {
    RewardedAd.load(
      adUnitId: adUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _ad = ad;
          _isReady = true;

          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isReady = false;
              load();
            },
            onAdFailedToShowFullScreenContent: (ad, err) {
              ad.dispose();
              _isReady = false;
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

  /// Show rewarded ad
  static void show({required Function onRewardEarned}) {
    if (_isReady && _ad != null) {
      _ad!.show(
        onUserEarnedReward: (ad, reward) {
          onRewardEarned();
        },
      );

      _isReady = false;
    } else {
      onRewardEarned();
      load();
    }
  }
}
