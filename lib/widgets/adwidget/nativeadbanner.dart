import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class NativeBannerAd extends StatefulWidget {
  const NativeBannerAd({super.key});

  @override
  State<NativeBannerAd> createState() => _NativeBannerAdState();
}

class _NativeBannerAdState extends State<NativeBannerAd> {
  NativeAd? _nativeAd;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    _nativeAd = NativeAd(
      adUnitId: 'ca-app-pub-3940256099942544/2247696110', // TEST ID
      factoryId: 'bannerAd', // must match your factory
      request: const AdRequest(),
      listener: NativeAdListener(
        onAdLoaded: (ad) {
          setState(() => _isLoaded = true);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    _nativeAd!.load();
  }

  @override
  void dispose() {
    _nativeAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) return const SizedBox(height: 0);

    return Container(
      height: 120,
      padding: const EdgeInsets.all(8),
      child: AdWidget(ad: _nativeAd!),
    );
  }
}
