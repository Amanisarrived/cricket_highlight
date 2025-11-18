import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomeBannerAd extends StatefulWidget {
  const HomeBannerAd({super.key});

  @override
  State<HomeBannerAd> createState() => _HomeBannerAdState();
}

class _HomeBannerAdState extends State<HomeBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _loadAdaptiveBanner();
  }

  Future<void> _loadAdaptiveBanner() async {
    final width = MediaQuery.of(context).size.width.truncate();
    final orientation = MediaQuery.of(context).orientation;

    final AdSize? adSize =
    await AdSize.getAnchoredAdaptiveBannerAdSize(orientation, width);

    if (adSize == null) return;

    final banner = BannerAd(
      adUnitId: 'ca-app-pub-2590111716650280/5937052107',
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    );

    banner.load();
    _bannerAd = banner;
  }


  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox.shrink();

    return Container(
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: _bannerAd!.size.width.toDouble(),
      height: _bannerAd!.size.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
